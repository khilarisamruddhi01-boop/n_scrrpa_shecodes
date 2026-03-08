"""
N-SCRRA API Routes — Parts 1, 2, 3, 4
Part 1: Network CRUD  → /api/nodes, /api/edges
Part 2: Risk Detection → /api/detections
Part 3: Visualization  → /api/nodes/<id>/detail
Part 4: Risk Scoring   → /api/resilience, /api/risk/history/<id>
"""

from flask import Blueprint, jsonify, request
from backend.database import get_conn
from datetime import datetime
import networkx as nx
import numpy as np

try:
    from sklearn.ensemble import IsolationForest
    from sklearn.linear_model import LinearRegression
    SKLEARN_OK = True
except ImportError:
    SKLEARN_OK = False

network_bp = Blueprint("network", __name__)
risk_bp    = Blueprint("risk",    __name__)

GEO_RISK_VAL = {"low": 10, "medium": 50, "high": 90}

# ── PART 4: Risk Score Formula ─────────────────────────────────────────────
def compute_node_risk(row):
    """Part 4: Weighted formula — financial 30% + operational 25% + geo 25% + reliability 20%"""
    geo_val = GEO_RISK_VAL.get(row.get("geo_risk_zone", "medium"), 50)
    return round(
        0.30 * row.get("financial_risk", 40) +
        0.25 * row.get("operational_risk", 40) +
        0.25 * geo_val +
        0.20 * (100 - row.get("reliability", 80)),
        2
    )

def compute_edge_risk(source_risk, target_risk, route_instability=10):
    """Part 4: Edge risk = average of source + target risk + route instability factor"""
    return round((source_risk + target_risk) / 2 + route_instability * 0.3, 2)

def compute_resilience(nodes, edges):
    """Part 4: Network Resilience = 100 - weighted avg risk (SPOFs weighted 3x)"""
    if not nodes:
        return 100.0
    total_weight = 0
    weighted_sum = 0
    for n in nodes:
        w = 3 if n.get("is_spof") else 1
        weighted_sum += n["risk_score"] * w
        total_weight += w
    base = weighted_sum / total_weight if total_weight else 50
    return round(max(0, 100 - base), 2)

def node_dict(r):
    d = dict(r)
    d["is_spof"] = bool(d.get("is_spof", 0))
    return d

def edge_dict(e):
    d = dict(e)
    d["source"] = d.pop("source_id", d.get("source"))
    d["target"] = d.pop("target_id", d.get("target"))
    return d

def build_nx_graph(conn):
    nodes = [dict(r) for r in conn.execute("SELECT * FROM nodes").fetchall()]
    edges = [dict(r) for r in conn.execute("SELECT * FROM edges").fetchall()]
    G = nx.DiGraph()
    for n in nodes: G.add_node(n["id"])
    for e in edges: G.add_edge(e["source_id"], e["target_id"])
    return G, nodes, edges

# ══════════════════════════════════════════════════════════════════
# PART 1 — Network CRUD
# ══════════════════════════════════════════════════════════════════

@network_bp.route("/api/nodes")
def get_nodes():
    conn = get_conn()
    domain = request.args.get("domain")
    q = "SELECT * FROM nodes WHERE domain=?" if domain else "SELECT * FROM nodes"
    rows = conn.execute(q, (domain,) if domain else ()).fetchall()
    conn.close()
    return jsonify([node_dict(r) for r in rows])


@network_bp.route("/api/edges")
def get_edges():
    conn = get_conn()
    rows = conn.execute("SELECT * FROM edges").fetchall()
    conn.close()
    return jsonify([edge_dict(r) for r in rows])


@network_bp.route("/api/nodes", methods=["POST"])
def create_node():
    data = request.json
    now = datetime.utcnow().isoformat()
    data["risk_score"] = compute_node_risk(data)
    conn = get_conn()
    conn.execute("""
        INSERT OR REPLACE INTO nodes
        (id,label,type,tier,domain,geo_country,geo_risk_zone,risk_score,
         reliability,demand_match,is_spof,financial_risk,operational_risk,last_updated,notes)
        VALUES (:id,:label,:type,:tier,:domain,:geo_country,:geo_risk_zone,:risk_score,
         :reliability,:demand_match,:is_spof,:financial_risk,:operational_risk,?,?)
    """, {**data, "risk_score": data["risk_score"]}, )
    # Workaround: use named + positional
    conn.execute("""
        INSERT OR REPLACE INTO nodes
        (id,label,type,tier,domain,geo_country,geo_risk_zone,risk_score,
         reliability,demand_match,is_spof,financial_risk,operational_risk,last_updated,notes)
        VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    """, (data["id"],data["label"],data["type"],data.get("tier",0),data["domain"],
          data["geo_country"],data.get("geo_risk_zone","medium"),data["risk_score"],
          data.get("reliability",80),data.get("demand_match",85),data.get("is_spof",0),
          data.get("financial_risk",40),data.get("operational_risk",40),now,data.get("notes","")))
    # Save to risk_history
    conn.execute("INSERT INTO risk_history (node_id,risk_score,timestamp) VALUES (?,?,?)",
                 (data["id"], data["risk_score"], now))
    conn.commit()
    row = conn.execute("SELECT * FROM nodes WHERE id=?", (data["id"],)).fetchone()
    conn.close()
    return jsonify(node_dict(row)), 201


@network_bp.route("/api/nodes/<node_id>", methods=["PUT"])
def update_node(node_id):
    data = request.json
    now = datetime.utcnow().isoformat()
    conn = get_conn()
    existing = conn.execute("SELECT * FROM nodes WHERE id=?", (node_id,)).fetchone()
    if not existing:
        conn.close()
        return jsonify({"error": "Not found"}), 404
    merged = {**dict(existing), **data}
    merged["risk_score"] = compute_node_risk(merged)
    merged["last_updated"] = now
    conn.execute("""
        UPDATE nodes SET label=?,type=?,tier=?,domain=?,geo_country=?,geo_risk_zone=?,
        risk_score=?,reliability=?,demand_match=?,is_spof=?,financial_risk=?,
        operational_risk=?,last_updated=?,notes=? WHERE id=?
    """, (merged["label"],merged["type"],merged["tier"],merged["domain"],merged["geo_country"],
          merged["geo_risk_zone"],merged["risk_score"],merged["reliability"],merged["demand_match"],
          merged["is_spof"],merged["financial_risk"],merged["operational_risk"],
          merged["last_updated"],merged.get("notes",""),node_id))
    # Update edge risks for connected edges
    _recalc_connected_edges(conn, node_id, merged["risk_score"])
    conn.execute("INSERT INTO risk_history (node_id,risk_score,timestamp) VALUES (?,?,?)",
                 (node_id, merged["risk_score"], now))
    conn.commit()
    row = conn.execute("SELECT * FROM nodes WHERE id=?", (node_id,)).fetchone()
    conn.close()
    return jsonify(node_dict(row))


@network_bp.route("/api/nodes/<node_id>", methods=["DELETE"])
def delete_node(node_id):
    conn = get_conn()
    conn.execute("DELETE FROM edges WHERE source_id=? OR target_id=?", (node_id, node_id))
    conn.execute("DELETE FROM risk_history WHERE node_id=?", (node_id,))
    conn.execute("DELETE FROM nodes WHERE id=?", (node_id,))
    conn.commit()
    conn.close()
    return jsonify({"deleted": node_id})


@network_bp.route("/api/nodes/<node_id>/detail")
def node_detail(node_id):
    conn = get_conn()
    node = conn.execute("SELECT * FROM nodes WHERE id=?", (node_id,)).fetchone()
    if not node:
        conn.close()
        return jsonify({"error": "Not found"}), 404
    node = node_dict(node)
    out_edges = [dict(r) for r in conn.execute(
        "SELECT e.*,n.label as target_label FROM edges e JOIN nodes n ON e.target_id=n.id WHERE e.source_id=?",
        (node_id,)).fetchall()]
    in_edges = [dict(r) for r in conn.execute(
        "SELECT e.*,n.label as source_label FROM edges e JOIN nodes n ON e.source_id=n.id WHERE e.target_id=?",
        (node_id,)).fetchall()]
    history = [dict(r) for r in conn.execute(
        "SELECT risk_score,timestamp FROM risk_history WHERE node_id=? ORDER BY timestamp DESC LIMIT 10",
        (node_id,)).fetchall()]
    conn.close()
    return jsonify({**node, "out_edges": out_edges, "in_edges": in_edges, "history": history})


@network_bp.route("/api/summary")
def summary():
    conn = get_conn()
    nodes = [dict(r) for r in conn.execute("SELECT * FROM nodes").fetchall()]
    edges = [dict(r) for r in conn.execute("SELECT * FROM edges").fetchall()]
    conn.close()
    rels = [n["reliability"] for n in nodes]
    res = compute_resilience(nodes, edges)
    return jsonify({
        "total_nodes": len(nodes),
        "total_edges": len(edges),
        "spof_count": sum(1 for n in nodes if n["is_spof"]),
        "high_risk_count": sum(1 for n in nodes if n["risk_score"] >= 70),
        "avg_reliability": round(float(np.mean(rels)), 1) if rels else 0,
        "network_resilience": res,
        "domains": list({n["domain"] for n in nodes}),
    })


# ══════════════════════════════════════════════════════════════════
# PART 2 — Risk Detection
# ══════════════════════════════════════════════════════════════════

@risk_bp.route("/api/detections")
def detections():
    conn = get_conn()
    G, nodes, edges = build_nx_graph(conn)
    node_map = {n["id"]: n for n in nodes}

    # 1. SPOF — articulation points
    UG = G.to_undirected()
    art_pts = set(nx.articulation_points(UG)) if len(UG.nodes) > 1 else set()
    upd = get_conn()
    for n in nodes:
        new_spof = 1 if n["id"] in art_pts else 0
        if n["is_spof"] != new_spof:
            upd.execute("UPDATE nodes SET is_spof=? WHERE id=?", (new_spof, n["id"]))
            n["is_spof"] = new_spof
    upd.commit(); upd.close()

    spof_list = [{"id":n["id"],"label":n["label"],"domain":n["domain"],
                  "risk_score":n["risk_score"],"geo_country":n["geo_country"]}
                 for n in nodes if n["id"] in art_pts]

    # 2. Geo Concentration
    cc = {}
    for n in nodes: cc[n["geo_country"]] = cc.get(n["geo_country"],0)+1
    total = len(nodes) or 1
    geo_flags = sorted([{"country":c,"count":cnt,"pct":round(cnt/total*100,1),"flagged":cnt/total>0.4}
                        for c,cnt in cc.items()], key=lambda x:-x["count"])

    # 3. Reliability alerts
    rel_flags = [{"id":n["id"],"label":n["label"],"reliability":n["reliability"],
                  "domain":n["domain"],"threshold":70,
                  "severity":"critical" if n["reliability"]<60 else "warning"}
                 for n in nodes if n["reliability"]<70]

    # 4. Demand-Supply Mismatch
    mm_flags = []
    for e in edges:
        ratio = e["volume"]/e["demand"] if e["demand"]>0 else 1
        if ratio < 0.8:
            src = node_map.get(e["source_id"],{})
            tgt = node_map.get(e["target_id"],{})
            mm_flags.append({"edge_id":e["id"],"source":src.get("label",e["source_id"]),
                              "target":tgt.get("label",e["target_id"]),"supply_volume":e["volume"],
                              "demand":e["demand"],"ratio":round(ratio,2),"gap":round(e["demand"]-e["volume"],1)})

    # 5. ML — IsolationForest anomaly detection
    ml_anomalies = []
    if SKLEARN_OK and len(nodes) >= 5:
        feats = np.array([[n["risk_score"],n["reliability"],n["financial_risk"],
                           n["operational_risk"],n["demand_match"]] for n in nodes])
        clf = IsolationForest(contamination=0.15, random_state=42)
        preds = clf.fit_predict(feats)
        ml_anomalies = [{"id":n["id"],"label":n["label"],"domain":n["domain"],
                         "risk_score":n["risk_score"],"reliability":n["reliability"]}
                        for n,p in zip(nodes,preds) if p==-1]

    # 6. Betweenness Centrality (NetworkX)
    centrality = nx.betweenness_centrality(G)
    top5 = sorted(centrality.items(), key=lambda x:-x[1])[:5]
    critical = [{"id":nid,"label":node_map[nid]["label"],"domain":node_map[nid]["domain"],
                 "centrality":round(sc,4),"risk_score":node_map[nid]["risk_score"]}
                for nid,sc in top5 if nid in node_map]

    # 7. Monte Carlo cascade failure simulation (Part 4 bonus)
    cascade_prob = _monte_carlo_cascade(G, nodes, node_map, simulations=500)

    conn.close()
    return jsonify({
        "spof":             {"count":len(spof_list),"nodes":spof_list},
        "geo_concentration":{"flagged":sum(1 for g in geo_flags if g["flagged"]),"breakdown":geo_flags},
        "reliability":      {"count":len(rel_flags),"nodes":rel_flags},
        "demand_mismatch":  {"count":len(mm_flags),"edges":mm_flags},
        "ml_anomalies":     {"count":len(ml_anomalies),"nodes":ml_anomalies,"model":"IsolationForest"},
        "critical_nodes":   {"nodes":critical,"metric":"betweenness_centrality"},
        "cascade_risk":     cascade_prob,
        "generated_at":     datetime.utcnow().isoformat(),
    })


def _monte_carlo_cascade(G, nodes, node_map, simulations=500):
    """Monte Carlo: simulate random node failures, estimate cascade probability"""
    if len(nodes) < 3:
        return {"probability": 0, "simulations": simulations}
    failures = 0
    node_ids = [n["id"] for n in nodes]
    rng = np.random.default_rng(42)
    for _ in range(simulations):
        # Remove random high-risk node
        high_risk = [n["id"] for n in nodes if n["risk_score"] > 60]
        if not high_risk:
            continue
        failed = rng.choice(high_risk)
        H = G.copy()
        H.remove_node(failed)
        # Check if graph became disconnected
        if not nx.is_weakly_connected(H) if len(H.nodes) > 0 else True:
            failures += 1
    prob = round(failures / simulations * 100, 1)
    return {"probability": prob, "simulations": simulations, "unit": "%"}


# ══════════════════════════════════════════════════════════════════
# PART 4 — Risk Scoring & Resilience
# ══════════════════════════════════════════════════════════════════

@risk_bp.route("/api/resilience")
def resilience():
    conn = get_conn()
    nodes = [dict(r) for r in conn.execute("SELECT * FROM nodes").fetchall()]
    edges = [dict(r) for r in conn.execute("SELECT * FROM edges").fetchall()]
    score = compute_resilience(nodes, edges)
    spof_count = sum(1 for n in nodes if n.get("is_spof"))
    high_risk   = sum(1 for n in nodes if n["risk_score"] >= 70)
    now = datetime.utcnow().isoformat()
    conn.execute("INSERT INTO network_resilience (resilience_score,spof_count,high_risk_count,timestamp) VALUES (?,?,?,?)",
                 (score, spof_count, high_risk, now))
    conn.commit()
    # Trend: last 10 snapshots
    trend = [dict(r) for r in conn.execute(
        "SELECT resilience_score,timestamp FROM network_resilience ORDER BY id DESC LIMIT 10").fetchall()]
    conn.close()
    grade = "A" if score>=85 else "B" if score>=70 else "C" if score>=55 else "D" if score>=40 else "F"
    return jsonify({
        "score": score, "grade": grade,
        "spof_count": spof_count, "high_risk_nodes": high_risk,
        "total_nodes": len(nodes),
        "interpretation": _interpret_resilience(score),
        "trend": list(reversed(trend)),
        "timestamp": now,
    })


def _interpret_resilience(score):
    if score >= 85: return "Highly Resilient — minimal disruption risk"
    if score >= 70: return "Resilient — manageable risks present"
    if score >= 55: return "Moderate Risk — attention required"
    if score >= 40: return "High Risk — significant vulnerabilities"
    return "Critical — network at severe risk of disruption"


@risk_bp.route("/api/risk/history/<node_id>")
def risk_history(node_id):
    conn = get_conn()
    rows = conn.execute(
        "SELECT risk_score,timestamp FROM risk_history WHERE node_id=? ORDER BY timestamp ASC",
        (node_id,)).fetchall()
    node = conn.execute("SELECT label,risk_score FROM nodes WHERE id=?", (node_id,)).fetchone()
    conn.close()
    if not node:
        return jsonify({"error": "Node not found"}), 404
    return jsonify({
        "node_id": node_id,
        "label": node["label"],
        "current_risk": node["risk_score"],
        "history": [{"risk_score": r["risk_score"], "timestamp": r["timestamp"]} for r in rows],
    })


@risk_bp.route("/api/risk/recalculate", methods=["POST"])
def recalculate_all():
    """Recalculate all node and edge risk scores using Part 4 formula"""
    conn = get_conn()
    nodes = [dict(r) for r in conn.execute("SELECT * FROM nodes").fetchall()]
    now = datetime.utcnow().isoformat()
    for n in nodes:
        rs = compute_node_risk(n)
        conn.execute("UPDATE nodes SET risk_score=?,last_updated=? WHERE id=?", (rs, now, n["id"]))
        conn.execute("INSERT INTO risk_history (node_id,risk_score,timestamp) VALUES (?,?,?)", (n["id"], rs, now))
        n["risk_score"] = rs
    # Recalculate edge risks
    edges = [dict(r) for r in conn.execute("SELECT * FROM edges").fetchall()]
    node_map = {n["id"]: n for n in nodes}
    for e in edges:
        src_risk = node_map.get(e["source_id"], {}).get("risk_score", 50)
        tgt_risk = node_map.get(e["target_id"], {}).get("risk_score", 50)
        er = compute_edge_risk(src_risk, tgt_risk, e.get("route_instability", 10))
        conn.execute("UPDATE edges SET risk_score=? WHERE id=?", (er, e["id"]))
    conn.commit()
    conn.close()
    return jsonify({"updated_nodes": len(nodes), "updated_edges": len(edges), "timestamp": now})


@risk_bp.route("/api/risk/predict/<node_id>")
def predict_risk(node_id):
    """ML: LinearRegression to predict future risk score from history"""
    conn = get_conn()
    rows = conn.execute(
        "SELECT risk_score,timestamp FROM risk_history WHERE node_id=? ORDER BY timestamp ASC",
        (node_id,)).fetchall()
    conn.close()
    if len(rows) < 3 or not SKLEARN_OK:
        return jsonify({"error": "Insufficient history or sklearn unavailable"}), 400
    X = np.arange(len(rows)).reshape(-1,1)
    y = np.array([r["risk_score"] for r in rows])
    model = LinearRegression().fit(X, y)
    next_pred = float(model.predict([[len(rows)]])[0])
    trend = "increasing" if model.coef_[0] > 0.5 else "decreasing" if model.coef_[0] < -0.5 else "stable"
    return jsonify({
        "node_id": node_id,
        "current_risk": float(y[-1]),
        "predicted_next": round(max(0, min(100, next_pred)), 2),
        "trend": trend,
        "slope": round(float(model.coef_[0]), 4),
        "data_points": len(rows),
    })


def _recalc_connected_edges(conn, node_id, new_risk):
    """Part 4: Auto-update edge risks when a node changes"""
    node_map = {r["id"]: dict(r) for r in conn.execute("SELECT * FROM nodes").fetchall()}
    edges = conn.execute("SELECT * FROM edges WHERE source_id=? OR target_id=?", (node_id, node_id)).fetchall()
    for e in edges:
        e = dict(e)
        src = node_map.get(e["source_id"], {}).get("risk_score", 50)
        tgt = node_map.get(e["target_id"], {}).get("risk_score", 50)
        if e["source_id"] == node_id: src = new_risk
        if e["target_id"] == node_id: tgt = new_risk
        er = compute_edge_risk(src, tgt, e.get("route_instability", 10))
        conn.execute("UPDATE edges SET risk_score=? WHERE id=?", (er, e["id"]))
