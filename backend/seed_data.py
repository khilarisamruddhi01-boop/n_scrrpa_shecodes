import sys, os, datetime
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from backend.database import get_conn, init_db

NODES = [
    # ── AUTO DOMAIN ────────────────────────────────────────────────────
    ("AUTO_SUP_01","Exide Industries","supplier",3,"auto","India","low",22,91,95,0,18,20),
    ("AUTO_SUP_02","Bosch Stuttgart","supplier",3,"auto","Germany","low",18,95,92,0,12,15),
    ("AUTO_SUP_03","Aisin Seiki","supplier",3,"auto","Japan","low",20,93,88,0,16,18),
    ("AUTO_SUP_04","Yanfeng Shanghai","supplier",3,"auto","China","high",72,68,70,1,65,70),
    ("AUTO_MFG_01","Tata Motors Pune","manufacturer",2,"auto","India","low",30,85,90,0,28,30),
    ("AUTO_MFG_02","Mahindra Nashik","manufacturer",2,"auto","India","low",28,87,88,0,25,28),
    ("AUTO_DIST_01","AutoLogix Delhi","distributor",1,"auto","India","medium",40,78,82,0,35,42),
    ("AUTO_RET_01","CarMax Chennai","retailer",0,"auto","India","low",25,88,93,0,20,22),
    ("AUTO_LOG_01","DHL Auto Freight","logistics",1,"auto","Germany","low",15,97,98,0,10,12),
    # ── PHARMA DOMAIN ──────────────────────────────────────────────────
    ("PHARMA_SUP_01","RawChem Shanghai","supplier",3,"pharma","China","high",78,62,65,1,72,76),
    ("PHARMA_SUP_02","BASF Ludwigshafen","supplier",3,"pharma","Germany","low",16,96,94,0,12,14),
    ("PHARMA_SUP_03","Divi's Labs Hyd","supplier",3,"pharma","India","low",24,89,91,0,20,22),
    ("PHARMA_MFG_01","Sun Pharma Mumbai","manufacturer",2,"pharma","India","low",32,84,86,0,30,32),
    ("PHARMA_MFG_02","Cipla Goa","manufacturer",2,"pharma","India","low",30,86,89,0,27,29),
    ("PHARMA_DIST_01","MedLine India","distributor",1,"pharma","India","medium",45,76,80,0,40,44),
    ("PHARMA_REG_01","CDSCO New Delhi","regulatory",2,"pharma","India","low",10,99,99,0,5,8),
    ("PHARMA_RET_01","Apollo Pharmacy","retailer",0,"pharma","India","low",20,92,95,0,15,18),
    # ── ELECTRONICS DOMAIN ─────────────────────────────────────────────
    ("ELEC_SUP_01","TSMC Taiwan","supplier",3,"electronics","Taiwan","high",80,60,62,1,75,78),
    ("ELEC_SUP_02","Samsung Components","supplier",3,"electronics","S.Korea","medium",45,80,82,0,40,43),
    ("ELEC_SUP_03","Foxconn Shenzhen","supplier",3,"electronics","China","high",74,65,68,0,68,72),
    ("ELEC_MFG_01","Dixon Technologies","manufacturer",2,"electronics","India","low",28,88,90,0,24,26),
    ("ELEC_MFG_02","Flextronics Chennai","manufacturer",2,"electronics","India","low",26,90,92,0,22,24),
    ("ELEC_DIST_01","Ingram Micro Mumbai","distributor",1,"electronics","India","low",22,92,94,0,18,20),
    ("ELEC_DIST_02","TD Synnex Singapore","distributor",1,"electronics","Singapore","low",18,95,96,0,14,16),
    ("ELEC_RET_01","Reliance Digital","retailer",0,"electronics","India","low",18,94,96,0,14,16),
]

EDGES = [
    ("AUTO_SUP_01","AUTO_MFG_01",22,3,"truck",500,480,8),
    ("AUTO_SUP_02","AUTO_MFG_01",18,14,"sea",800,750,12),
    ("AUTO_SUP_03","AUTO_MFG_02",20,10,"air",300,290,10),
    ("AUTO_SUP_04","AUTO_MFG_01",72,20,"sea",600,700,35),
    ("AUTO_MFG_01","AUTO_DIST_01",30,2,"truck",1000,950,8),
    ("AUTO_MFG_02","AUTO_DIST_01",28,2,"truck",800,780,7),
    ("AUTO_DIST_01","AUTO_RET_01",25,1,"truck",900,880,5),
    ("AUTO_LOG_01","AUTO_DIST_01",15,5,"air",200,190,5),
    ("PHARMA_SUP_01","PHARMA_MFG_01",78,25,"sea",400,600,40),
    ("PHARMA_SUP_02","PHARMA_MFG_01",16,12,"sea",700,680,8),
    ("PHARMA_SUP_03","PHARMA_MFG_02",24,2,"truck",500,490,6),
    ("PHARMA_MFG_01","PHARMA_DIST_01",32,3,"truck",800,780,9),
    ("PHARMA_MFG_02","PHARMA_DIST_01",30,3,"truck",600,590,8),
    ("PHARMA_DIST_01","PHARMA_RET_01",25,1,"truck",900,880,5),
    ("PHARMA_REG_01","PHARMA_MFG_01",10,30,"none",999,999,2),
    ("ELEC_SUP_01","ELEC_MFG_01",80,30,"sea",200,500,45),
    ("ELEC_SUP_02","ELEC_MFG_01",45,7,"sea",400,390,18),
    ("ELEC_SUP_03","ELEC_MFG_02",74,20,"sea",350,340,30),
    ("ELEC_MFG_01","ELEC_DIST_01",28,2,"truck",600,580,7),
    ("ELEC_MFG_02","ELEC_DIST_02",26,3,"air",500,490,8),
    ("ELEC_DIST_01","ELEC_RET_01",22,1,"truck",700,690,5),
    ("ELEC_DIST_02","ELEC_RET_01",18,2,"air",400,390,5),
]

def seed():
    init_db()
    conn = get_conn()
    c = conn.cursor()
    c.execute("DELETE FROM risk_history")
    c.execute("DELETE FROM network_resilience")
    c.execute("DELETE FROM edges")
    c.execute("DELETE FROM nodes")
    now = datetime.datetime.utcnow().isoformat()
    c.executemany("""
        INSERT INTO nodes (id,label,type,tier,domain,geo_country,geo_risk_zone,
            risk_score,reliability,demand_match,is_spof,financial_risk,operational_risk,last_updated)
        VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    """, [n + (now,) for n in NODES])
    c.executemany("""
        INSERT INTO edges (source_id,target_id,risk_score,lead_days,transport,volume,demand,route_instability)
        VALUES (?,?,?,?,?,?,?,?)
    """, EDGES)
    # Seed initial risk history
    for n in NODES:
        c.execute("INSERT INTO risk_history (node_id,risk_score,timestamp) VALUES (?,?,?)", (n[0], n[7], now))
    conn.commit()
    conn.close()
    print(f"Seeded {len(NODES)} nodes, {len(EDGES)} edges.")

if __name__ == "__main__":
    seed()
