import os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from flask import Flask, render_template, send_from_directory
from backend.database import init_db
from backend.routes.network import network_bp, risk_bp

app = Flask(__name__, template_folder="frontend", static_folder="frontend/static")
app.register_blueprint(network_bp)
app.register_blueprint(risk_bp)

@app.route("/")
def index():
    return render_template("network_map.html")

if __name__ == "__main__":
    init_db()
    # Seed if empty
    from backend.database import get_conn
    conn = get_conn()
    count = conn.execute("SELECT COUNT(*) FROM nodes").fetchone()[0]
    conn.close()
    if count == 0:
        print("Seeding database...")
        from backend.seed_data import seed
        seed()
    else:
        print(f"DB ready — {count} nodes.")
    app.run(debug=True, port=5001)
