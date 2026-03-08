from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from dependencies.auth import require_role, CurrentUser
from database import get_db
import uuid
from services.storage_service import generate_signed_url
from core.firebase import get_db as get_firestore
from services.fcm_service import send_push_notification
import datetime

router = APIRouter()

@router.post("/generate")
async def generate_report(
    data: dict,
    current_user: CurrentUser = Depends(require_role(["admin", "customer", "supplier"])),
    db: Session = Depends(get_db)
):
    """
    Simulates report generation and FCM trigger when done
    """
    report_type = data.get("report_type", "supply_chain_audit")
    report_id = "REP-" + str(uuid.uuid4())[:8].upper()
    
    # Ideally starts a Celery background task...
    
    # Simulating the Completion:
    firestore_db = get_firestore()
    firestore_db.collection(f"notifications/{current_user.uid}/inbox").add({
        "type": "report_ready",
        "title": "Report Ready",
        "body": f"Your {report_type} is ready to download.",
        "data": {
            "type": "report_ready", 
            "report_id": report_id, 
            "action_route": f"/reports/{report_id}"
        },
        "is_read": False,
        "created_at": firestore_db.SERVER_TIMESTAMP
    })

    from models.database import User
    user = db.query(User).filter(User.firebase_uid == current_user.uid).first()
    if user and user.fcm_token:
        send_push_notification(
            token=user.fcm_token,
            title="Report Generated",
            body="Your report is ready to be downloaded.",
            data={
                 "action_route": f"/reports/{report_id}"
            }
        )
    
    return {"status": "success", "report_id": report_id}

@router.get("/{report_id}/download")
async def download_report(
    report_id: str,
    current_user: CurrentUser = Depends(require_role(["admin", "customer", "supplier"])),
    db: Session = Depends(get_db)
):
    path = f"reports/{current_user.uid}/{report_id}/report.pdf"
    url = generate_signed_url(path, expiry_minutes=1440) # 24 hrs
    return {"status": "success", "signed_url": url}
