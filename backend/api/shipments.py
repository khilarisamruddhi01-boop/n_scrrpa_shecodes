from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from dependencies.auth import get_current_user, require_role, CurrentUser
from models.database import Shipment, Order
from database import get_db
import uuid
from datetime import datetime, timedelta
from core.firebase import get_db as get_firestore
from services.fcm_service import send_push_notification

router = APIRouter()

@router.post("/")
async def create_shipment(
    data: dict,
    current_user: CurrentUser = Depends(require_role(["supplier"])),
    db: Session = Depends(get_db)
):
    """
    Creates a new shipment, initiates realtime tracking in Firestore.
    """
    order_id = data.get("order_id")
    carrier = data.get("carrier", "FastTrack")
    
    order = db.query(Order).filter(Order.id == order_id).first()
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")

    shipment_id = "SHP-" + str(uuid.uuid4())[:8].upper()
    eta_dt = datetime.utcnow() + timedelta(days=2)
    
    new_shipment = Shipment(
        id=shipment_id,
        order_id=order_id,
        carrier_info={"name": carrier},
        current_lat=34.0522,  # Dummy start
        current_lng=-118.2437,
        eta=eta_dt,
        status="dispatched"
    )
    db.add(new_shipment)
    order.status = "dispatched"
    db.commit()
    db.refresh(new_shipment)
    
    # 1. Write to Firestore Realtime Data
    firestore_db = get_firestore()
    firestore_db.collection("realtime_data").document(f"shipments/{shipment_id}").set({
        "current_lat": 34.0522,
        "current_lng": -118.2437,
        "speed_kmh": 0,
        "last_updated": firestore_db.SERVER_TIMESTAMP,
        "eta_timestamp": eta_dt,
        "risk_score": 0.05,
        "supplier_org_id": current_user.org_id,
        "customer_org_id": order.customer_id,
        "status": "dispatched"
    })
    
    # 2. Trigger FCM to Customer (FCM-03)
    send_push_notification(
        topic=f"org_{order.customer_id}",
        title="Shipment En Route",
        body=f"Shipment {shipment_id} departed. ETA: {eta_dt.strftime('%d %b %Y')}",
        data={
            "type": "shipment_alert",
            "shipment_id": shipment_id,
            "action_route": f"/customer_shipment_tracking_s22"
        }
    )

    return {"status": "success", "shipment_id": shipment_id}

@router.patch("/{shipment_id}/location")
async def update_location(
    shipment_id: str,
    data: dict,
    current_user: CurrentUser = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Update GPS location from IoT/Driver App
    """
    lat = data.get("lat")
    lng = data.get("lng")
    speed = data.get("speed", 60)
    
    shipment = db.query(Shipment).filter(Shipment.id == shipment_id).first()
    if not shipment:
        raise HTTPException(status_code=404, detail="Shipment not found")

    shipment.current_lat = lat
    shipment.current_lng = lng
    db.commit()
    
    # Update Firestore for live map tracking
    firestore_db = get_firestore()
    firestore_db.collection("realtime_data").document(f"shipments/{shipment_id}").set({
        "current_lat": lat,
        "current_lng": lng,
        "speed_kmh": speed,
        "last_updated": firestore_db.SERVER_TIMESTAMP
    }, merge=True)
    
    # Risk check logic goes here or via Cloud Functions trigger
    return {"status": "success", "updated_lat": lat, "updated_lng": lng}
