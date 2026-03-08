from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from dependencies.auth import get_current_user, require_role, CurrentUser
from models.database import Order
from database import get_db
import uuid
from datetime import datetime
from core.firebase import get_db as get_firestore
from services.fcm_service import send_push_notification

router = APIRouter()

@router.post("/")
async def create_order(
    data: dict, 
    current_user: CurrentUser = Depends(require_role(["customer"])),
    db: Session = Depends(get_db)
):
    """
    Customer creates an order. Triggers FCM to supplier.
    """
    supplier_id = data.get("supplier_id")
    quantity = data.get("quantity")
    product_sku = data.get("product_sku")
    
    order_id = "ORD-" + str(uuid.uuid4())[:8].upper()
    
    new_order = Order(
        id=order_id,
        customer_id=current_user.org_id,
        supplier_id=supplier_id,
        status="pending",
        quantity=quantity,
        product_sku=product_sku,
        total_value=data.get("total_value", 0.0)
    )
    
    db.add(new_order)
    db.commit()
    db.refresh(new_order)
    
    # Send FCM Notification to Supplier topic
    # In a real system you'd look up the supplier's token or topic
    send_push_notification(
        topic=f"org_{supplier_id}",
        title="New Order Received",
        body=f"Order #{order_id} from {current_user.email} — {quantity} units",
        data={
            "type": "order_update", 
            "order_id": order_id, 
            "action_route": f"/supplier/order/{order_id}"
        }
    )
    
    # Write to Firestore Inbox
    firestore_db = get_firestore()
    firestore_db.collection(f"notifications/{supplier_id}/inbox").add({
        "type": "order_update",
        "title": "New Order Received",
        "body": f"Order #{order_id} from {current_user.email} — {quantity} units",
        "data": {
            "type": "order_update", 
            "order_id": order_id, 
            "action_route": f"/supplier/order/{order_id}"
        },
        "is_read": False,
        "created_at": firestore_db.SERVER_TIMESTAMP
    })

    return {"status": "success", "order_id": order_id}

@router.patch("/{order_id}/status")
async def update_order_status(
    order_id: str,
    data: dict,
    current_user: CurrentUser = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Update order status and notify the other party.
    """
    status = data.get("status")
    if not status:
        raise HTTPException(status_code=400, detail="Status required")

    order = db.query(Order).filter(Order.id == order_id).first()
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")

    order.status = status
    db.commit()
    
    # Notify customer if accepted
    if status == "accepted" and current_user.role == "supplier":
        send_push_notification(
            topic=f"org_{order.customer_id}",
            title="Order Accepted",
            body=f"Your order #{order_id} was accepted.",
            data={
                "type": "order_update",
                "order_id": order_id,
                "status": "accepted",
                "action_route": "/customer_orders_s21"
            }
        )
        
        # Write to Firestore Inbox
        firestore_db = get_firestore()
        firestore_db.collection(f"notifications/{order.customer_id}/inbox").add({
            "type": "order_update",
            "title": "Order Accepted",
            "body": f"Your order #{order_id} was accepted.",
            "data": {
                "type": "order_update",
                "order_id": order_id,
                "status": "accepted",
                "action_route": "/customer_orders_s21"
            },
            "is_read": False,
            "created_at": firestore_db.SERVER_TIMESTAMP
        })

    return {"status": "success", "order_id": order_id, "new_status": status}
