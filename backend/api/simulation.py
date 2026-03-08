from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from dependencies.auth import require_role, CurrentUser
from database import get_db
import uuid
from core.firebase import get_db as get_firestore

router = APIRouter()

@router.post("/run")
async def run_simulation(
    data: dict,
    current_user: CurrentUser = Depends(require_role(["admin", "customer"])),
    db: Session = Depends(get_db)
):
    """
    Run Cascade Simulation and track via Firestore
    """
    trigger_node_id = data.get("trigger_node_id")
    event_type = data.get("event_type", "bankruptcy")
    
    session_id = "SIM-" + str(uuid.uuid4())[:8].upper()
    
    # Normally Neo4j does complex Cascade simulation here.

    firestore_db = get_firestore()
    firestore_db.collection("simulation_sessions").document(session_id).set({
        "session_id": session_id,
        "triggered_by_uid": current_user.uid,
        "trigger_node_id": trigger_node_id,
        "event_type": event_type,
        "status": "completed",
        "current_step": 3,
        "total_steps": 3,
        "steps": [
            {"step": 1, "affected_nodes": [trigger_node_id], "impact_metrics": {"revenue_at_risk": 500}},
            {"step": 2, "affected_nodes": ["NODE-A"], "impact_metrics": {"revenue_at_risk": 1500}},
            {"step": 3, "affected_nodes": ["NODE-B"], "impact_metrics": {"revenue_at_risk": 3000}},
        ],
        "impact_summary": {"nodes_affected": 3, "pct_network_disrupted": 10},
        "created_at": firestore_db.SERVER_TIMESTAMP
    })

    return {"status": "success", "session_id": session_id}
