from flask import Blueprint, jsonify, request
from backend.database import get_conn
from datetime import datetime
import networkx as nx
import numpy as np

try:
    from sklearn.ensemble import IsolationForest
    SKLEARN_OK = True
except ImportError:
    SKLEARN_OK = False

network_bp = Blueprint("network", __name__)
risk_bp    = Blueprint("risk",    __name__)

GEO_RISK_VAL = {"low": 10, "medium": 50, "high": 90}

def row_to_node(r):
    return {k: r[k] for k in r.keys()}

def compute_risk(row):
    return (
        0.30 * row["financial_risk"] +
        0.25 * row["operational_risk"] +
        0.25 * GEO_RISK_VAL.get(row["geo_risk_zone"], 50) +
        0.20 * (100 - row["reliability"])
    )

# ── NODES ─────────────────────────────────────────────────────────────────────
@network_bp.route("/api/nodes")
def get_nodes():
    conn = get_conn()
    domain = request.args.get("domain")
    if domain:
        rows = conn.execute("SELECT * FROM nodes WHERE domain=?", (domain,)).fetchall()
    else:
        rows = conn.execute("SELECT * FROM nodes").fetchall()
    conn.close()
    return jsonify([dict(r) for r in rows])

@network_bp.route("/api/edges")
def get_edges():
    conn = get_conn()
    rows = conn.execute("SELECT * FROM edges").fetchall()
    conn.close()
    # rename source_id/target_id to source/target for D3
    result = []
    for r in rows:
        d = dict(r)
        d["source"] = d.pop("source_id")
        d["target"] = d.pop("target_id")
        result.append(d)
    return jsonify(result)

@network_bp.route("/api/nodes", methods=["POST"])
def create_node():
    data = request.json
    now = datetime.utcnow().isoformat()
    conn = get_conn()
    conn.execute("""
        INSERT OR REPLACE INTO nodes
        (id,label,type,tier,domain,geo_country,geo_risk_zone,risk_score,
         reliability,demand_match,is_spof,financial_risk,operational_risk,last_updated,notes)
        VALUES (:id,:label,:type,:tier,:domain,:geo_country,:geo_risk_zone,:risk_score,
         :reliability,:demand_match,:is_spof,:financial_risk,:operational_risk,?,?)
    """, {**data, "last_updated": now, "notes": data.get("notes","")})
    conn.commit()
    row = conn.execute("SELECT * FROM nodes WHERE id=?", (data["id"],)).fetchone()
    conn.close()
    return jsonify(dict(row)), 201

@network_bp.route("/api/nodes/<node_id>", methods=["PUT"])
def update_node(node_id):
    data = request.json
    now = datetime.utcnow().isoformat()
    conn = get_conn()
    node = conn.execute("SELECT * FROM nodes WHERE id=?", (node_id,)).fetchone()
    if not node:
        conn.close()
        return jsonify({"error": "Not found"}), 404
    merged = {**dict(node), **data, "last_updated": now}
    merged["risk_score"] = compute_risk(merged)
    conn.execute("""
        UPDATE nodes SET label=:label,type=:type,tier=:tier,domain=:domain,
        geo_country=:geo_country,geo_risk_zone=:geo_risk_zone,risk_score=:risk_score,
        reliability=:reliability,demand_match=:demand_match,is_spof=:is_spof,
        financial_risk=:financial_risk,operational_risk=:operational_risk,last_updated=:last_updated
        WHERE id=:id
    """, merged)
    conn.commit()
    row = conn.execute("SELECT * FROM nodes WHERE id=?", (node_id,)).fetchone()
    conn.close()
    return jsonify(dict(row))

@network_bp.route("/api/nodes/<node_id>", methods=["DELETE"])
def delete_node(node_id):
    conn = get_conn()
    conn.execute("DELETE FROM edges WHERE source_id=? OR target_id=?", (node_id, node_id))
    conn.execute("DELETE FROM nodes WHERE id=?", (node_id,))
    conn.commit()
    conn.close()
    return jsonify({"deleted": node_id})

@network_bp.route("/api/summary")
def summary():
    conn = get_conn()
    nodes = conn.execute("SELECT * FROM nodes").fetchall()
    edges = conn.execute("SELECT * FROM edges").fetchall()
    conn.close()
    rels = [r["reliability"] for r in nodes]
    return jsonify({
        "total_nodes": len(nodes),
        "total_edges": len(edges),
        "spof_count": sum(1 for n in nodes if n["is_spof"]),
        "high_risk_count": sum(1 for n in nodes if n["risk_score"] >= 70),
        "avg_reliability": round(float(np.mean(rels)), 1) if rels else 0,
        "domains": list({n["domain"] for n in nodes}),
    })

# ── DETECTIONS ────────────────────────────────────────────────────────────────
@risk_bp.route("/api/detections")
def detections():
    conn = get_conn()
    nodes = [dict(r) for r in conn.execute("SELECT * FROM nodes").fetchall()]
    edges = [dict(r) for r in conn.execute("SELECT * FROM edges").fetchall()]
    node_map = {n["id"]: n for n in nodes}
    conn.close()

    # Build NetworkX graph
    G = nx.DiGraph()
    for n in nodes:
        G.add_node(n["id"])
    for e in edges:
        G.add_edge(e["source_id"], e["target_id"])

    # 1. SPOF — articulation points
    UG = G.to_undirected()
    art_pts = set(nx.articulation_points(UG)) if len(UG.nodes) > 1 else set()

    # Update is_spof in DB
    upd_conn = get_conn()
    for n in nodes:
        new_spof = 1 if n["id"] in art_pts else 0
        if n["is_spof"] != new_spof:
            upd_conn.execute("UPDATE nodes SET is_spof=? WHERE id=?", (new_spof, n["id"]))
            n["is_spof"] = new_spof
    upd_conn.commit()
    upd_conn.close()

    spof_list = [
        {"id": n["id"], "label": n["label"], "domain": n["domain"],
         "risk_score": n["risk_score"], "geo_country": n["geo_country"]}
        for n in nodes if n["id"] in art_pts
    ]

    # 2. Geo concentration
    country_counts = {}
    for n in nodes:
        country_counts[n["geo_country"]] = country_counts.get(n["geo_country"], 0) + 1
    total = len(nodes) or 1
    geo_flags = sorted([
        {"country": c, "count": cnt, "pct": round(cnt/total*100, 1), "flagged": cnt/total > 0.4}
        for c, cnt in country_counts.items()
    ], key=lambda x: -x["count"])

    # 3. Reliability
    rel_flags = [
        {"id": n["id"], "label": n["label"], "reliability": n["reliability"],
         "domain": n["domain"], "threshold": 70,
         "severity": "critical" if n["reliability"] < 60 else "warning"}
        for n in nodes if n["reliability"] < 70
    ]

    # 4. Demand-Supply Mismatch
    mm_flags = []
    for e in edges:
        ratio = e["volume"] / e["demand"] if e["demand"] > 0 else 1.0
        if ratio < 0.8:
            src = node_map.get(e["source_id"], {})
            tgt = node_map.get(e["target_id"], {})
            mm_flags.append({
                "edge_id": e["id"],
                "source": src.get("label", e["source_id"]),
                "target": tgt.get("label", e["target_id"]),
                "supply_volume": e["volume"],
                "demand": e["demand"],
                "ratio": round(ratio, 2),
                "gap": round(e["demand"] - e["volume"], 1),
            })

    # 5. ML — IsolationForest
    ml_anomalies = []
    if SKLEARN_OK and len(nodes) >= 5:
        feats = np.array([
            [n["risk_score"], n["reliability"], n["financial_risk"],
             n["operational_risk"], n["demand_match"]]
            for n in nodes
        ])
        clf = IsolationForest(contamination=0.15, random_state=42)
        preds = clf.fit_predict(feats)
        for n, p in zip(nodes, preds):
            if p == -1:
                ml_anomalies.append({
                    "id": n["id"], "label": n["label"], "domain": n["domain"],
                    "risk_score": n["risk_score"], "reliability": n["reliability"],
                })

    # 6. Betweenness Centrality
    centrality = nx.betweenness_centrality(G)
    top5 = sorted(centrality.items(), key=lambda x: -x[1])[:5]
    critical = [
        {"id": nid, "label": node_map[nid]["label"], "domain": node_map[nid]["domain"],
         "centrality": round(sc, 4), "risk_score": node_map[nid]["risk_score"]}
        for nid, sc in top5 if nid in node_map
    ]

    return jsonify({
        "spof":             {"count": len(spof_list),   "nodes": spof_list},
        "geo_concentration":{"flagged": sum(1 for g in geo_flags if g["flagged"]), "breakdown": geo_flags},
        "reliability":      {"count": len(rel_flags),   "nodes": rel_flags},
        "demand_mismatch":  {"count": len(mm_flags),    "edges": mm_flags},
        "ml_anomalies":     {"count": len(ml_anomalies),"nodes": ml_anomalies, "model": "IsolationForest"},
        "critical_nodes":   {"nodes": critical,          "metric": "betweenness_centrality"},
        "generated_at":     datetime.utcnow().isoformat(),
    })

@risk_bp.route("/api/risk/recalculate", methods=["POST"])
def recalculate_all():
    conn = get_conn()
    nodes = conn.execute("SELECT * FROM nodes").fetchall()
    now = datetime.utcnow().isoformat()
    for n in nodes:
        rs = compute_risk(dict(n))
        conn.execute("UPDATE nodes SET risk_score=?, last_updated=? WHERE id=?",
                     (round(rs, 2), now, n["id"]))
    conn.commit()
    conn.close()
    return jsonify({"updated": len(nodes), "timestamp": now})
