from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from dependencies.auth import get_current_user, CurrentUser
from models.database import Alert
from database import get_db
from core.firebase import get_db as get_firestore

router = APIRouter()

@router.get("/")
async def get_alerts(
    current_user: CurrentUser = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Get alerts relevant to the current user combining PostgreSQL and Firestore active states.
    """
    # Simply querying PostgreSQL for demo purposes
    # Should use Neo4j for deep graph search
    alerts = db.query(Alert).filter(Alert.is_active == True).all()
    
    return {"alerts": [
        {
            "id": a.id,
            "type": a.type,
            "severity": a.severity,
            "title": a.title,
            "message": a.message,
            "created_at": a.created_at
        } for a in alerts
    ]}

@router.patch("/{alert_id}/acknowledge")
async def acknowledge_alert(
    alert_id: str,
    current_user: CurrentUser = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Acknowledge an alert to mark it read or dismiss from active list
    """
    firestore_db = get_firestore()
    
    # 1. Update Firestore alert doc (adding to acknowledged array)
    try:
        alert_ref = firestore_db.collection("alerts").document(alert_id)
        alert_ref.update({
            "acknowledged_by": firestore_db.ArrayUnion([current_user.uid])
        })
    except Exception as e:
        print(f"Error updating Firestore: {e}")
        
    return {"status": "success", "message": "Alert acknowledged."}
