import math
from firebase_admin import firestore, messaging
import asyncio

async def calculate_route_risk(current_lat, current_lng, route_geojson):
    """
    Simulates checking current position against risk overlay.
    In real implementation, this would query Neo4j or a GIS service.
    """
    # Dummy calculation: distance from a 'high risk area'
    high_risk_center = (40.7128, -74.0060) # Example: NYC
    dist = math.sqrt((current_lat - high_risk_center[0])**2 + (current_lng - high_risk_center[1])**2)
    
    risk_score = max(0.0, min(1.0, 1.0 - (dist / 10.0)))
    return risk_score

async def process_shipment_update(shipment_id, data):
    """
    Called when a shipment location is updated.
    Updates Firestore and checks for risk alerts.
    """
    db = firestore.client()
    
    current_lat = data.get("lat")
    current_lng = data.get("lng")
    
    # 1. Calculate Risk
    risk_score = await calculate_route_risk(current_lat, current_lng, data.get("route"))
    
    # 2. Update Firestore for real-time tracking (Section 3.1)
    shipment_ref = db.collection("realtime_data").document(shipment_id)
    shipment_ref.update({
        "current_lat": current_lat,
        "current_lng": current_lng,
        "risk_score": risk_score,
        "last_updated": firestore.SERVER_TIMESTAMP
    })
    
    # 3. If risk is high, generate an alert (Section 3.3)
    if risk_score > 0.7:
        alert_data = {
            "type": "route_risk",
            "severity": "high",
            "title": "High Risk Detected",
            "message": f"Shipment {shipment_id} is entering a high-risk zone.",
            "affected_shipment_ids": [shipment_id],
            "created_at": firestore.SERVER_TIMESTAMP,
            "is_active": True
        }
        db.collection("alerts").add(alert_data)
        
        # 4. Trigger FCM (Section 4.1-4.2)
        # This would typically use the org topic
        message = messaging.Message(
            topic=f"shipment_{shipment_id}",
            notification=messaging.Notification(
                title="Risk Alert: Shipment Delayed",
                body="Route disruption detected for your active shipment."
            ),
            data={
                "type": "risk_alert",
                "shipment_id": shipment_id,
                "action_route": f"/shipment_tracking_s12?id={shipment_id}"
            }
        )
        messaging.send(message)
