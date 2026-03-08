from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from dependencies.auth import require_role, CurrentUser
from models.database import User
from database import get_db
from firebase_admin import auth as firebase_auth
from core.firebase import get_db as get_firestore

router = APIRouter()

@router.patch("/suppliers/{supplier_id}/approve")
async def approve_supplier(
    supplier_id: str,
    current_user: CurrentUser = Depends(require_role(["admin"])),
    db: Session = Depends(get_db)
):
    """
    Admin approves a supplier. Sets custom claims and starts their live profile.
    """
    user = db.query(User).filter(User.org_id == supplier_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="Supplier not found")
    
    # Update Role logic
    user.role = "supplier"
    db.commit()

    # Update Custom Claims
    try:
        firebase_auth.set_custom_user_claims(user.firebase_uid, {
            "role": "supplier",
            "org_id": supplier_id
        })
    except Exception as e:
        print(f"Error setting custom claims: {e}")

    # Create supplier_profiles in Firestore for live status
    firestore_db = get_firestore()
    firestore_db.collection(f"supplier_profiles").document(supplier_id).collection("live_status").document("status").set({
        "risk_score": 0.0,
        "active_shipments_count": 0,
        "last_updated": firestore_db.SERVER_TIMESTAMP,
        "has_active_alerts": False
    })

    return {"status": "success", "message": f"Supplier {supplier_id} approved."}
