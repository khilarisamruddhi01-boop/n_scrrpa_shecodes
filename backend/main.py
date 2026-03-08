from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from core.firebase import initialize_firebase
import os
from dotenv import load_dotenv

load_dotenv()

app = FastAPI(title="N-SCRRA Backend", version="1.0.0")

# CORS Configuration
origins = [
    "http://localhost",
    "http://localhost:3000", # Example for web admin
    "*", # For development
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

from database import engine
from models import database as models_db
models_db.Base.metadata.create_all(bind=engine)

@app.on_event("startup")
async def startup_event():
    app.state.firebase = initialize_firebase()

@app.get("/")
async def root():
    return {"message": "N-SCRRA API is running", "version": "1.0.0"}

from api import auth, orders, shipments, alerts, admin, simulation, reports, network
app.include_router(auth.router, prefix="/auth", tags=["Authentication"])
app.include_router(orders.router, prefix="/orders", tags=["Orders"])
app.include_router(shipments.router, prefix="/shipments", tags=["Shipments"])
app.include_router(alerts.router, prefix="/alerts", tags=["Alerts / Intelligence"])
app.include_router(admin.router, prefix="/admin", tags=["Admin"])
app.include_router(simulation.router, prefix="/simulation", tags=["Simulation"])
app.include_router(reports.router, prefix="/reports", tags=["Reports"])
app.include_router(network.router, prefix="/network", tags=["Network Analytics"])
