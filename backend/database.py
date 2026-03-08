import sqlite3, os

DB_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "nscra.db")

def get_conn():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA journal_mode=WAL")
    return conn

def init_db():
    conn = get_conn()
    conn.executescript("""
    CREATE TABLE IF NOT EXISTS nodes (
        id               TEXT PRIMARY KEY,
        label            TEXT NOT NULL,
        type             TEXT NOT NULL,
        tier             INTEGER DEFAULT 0,
        domain           TEXT NOT NULL,
        geo_country      TEXT NOT NULL,
        geo_risk_zone    TEXT DEFAULT 'medium',
        risk_score       REAL DEFAULT 50.0,
        reliability      REAL DEFAULT 80.0,
        demand_match     REAL DEFAULT 85.0,
        is_spof          INTEGER DEFAULT 0,
        financial_risk   REAL DEFAULT 40.0,
        operational_risk REAL DEFAULT 40.0,
        last_updated     TEXT,
        notes            TEXT DEFAULT ''
    );

    CREATE TABLE IF NOT EXISTS edges (
        id               INTEGER PRIMARY KEY AUTOINCREMENT,
        source_id        TEXT NOT NULL,
        target_id        TEXT NOT NULL,
        risk_score       REAL DEFAULT 30.0,
        lead_days        INTEGER DEFAULT 7,
        transport        TEXT DEFAULT 'truck',
        volume           REAL DEFAULT 100.0,
        demand           REAL DEFAULT 90.0,
        route_instability REAL DEFAULT 10.0
    );

    CREATE TABLE IF NOT EXISTS risk_history (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        node_id     TEXT NOT NULL,
        risk_score  REAL NOT NULL,
        timestamp   TEXT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS network_resilience (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        resilience_score REAL NOT NULL,
        spof_count      INTEGER DEFAULT 0,
        high_risk_count INTEGER DEFAULT 0,
        timestamp       TEXT NOT NULL
    );
    """)
    conn.commit()
    conn.close()
