from sqlalchemy import Column, String, Boolean, Enum, DateTime, ForeignKey, Integer, Float, JSON
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
import datetime

Base = declarative_base()

class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    firebase_uid = Column(String(128), unique=True, index=True, nullable=False)
    email = Column(String(255), unique=True, index=True, nullable=False)
    role = Column(Enum("admin", "supplier", "customer", name="user_role"), nullable=False)
    org_id = Column(String(128), index=True) # ID from Organizations table
    fcm_token = Column(String, nullable=True)
    is_email_verified = Column(Boolean, default=False)
    otp_code = Column(String(6), nullable=True)
    otp_expiry = Column(DateTime, nullable=True)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
    
class Order(Base):
    __tablename__ = "orders"
    
    id = Column(String(128), primary_key=True)
    customer_id = Column(String(128), index=True)
    supplier_id = Column(String(128), index=True)
    status = Column(Enum("pending", "accepted", "rejected", "dispatched", "delivered", "cancelled", name="order_status"))
    quantity = Column(Integer)
    product_sku = Column(String(128))
    total_value = Column(Float)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)

class Shipment(Base):
    __tablename__ = "shipments"
    
    id = Column(String(128), primary_key=True)
    order_id = Column(String(128), ForeignKey("orders.id"))
    carrier_info = Column(JSON) # Carrier name, tracking number, etc.
    current_lat = Column(Float)
    current_lng = Column(Float)
    eta = Column(DateTime)
    status = Column(String(50))
    risk_score = Column(Float, default=0.0)
    
class Alert(Base):
    __tablename__ = "alerts"
    
    id = Column(String(128), primary_key=True)
    type = Column(String(50))
    severity = Column(String(20))
    title = Column(String(255))
    message = Column(String)
    affected_nodes = Column(JSON) # List of affected org IDs or route segments
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
    is_active = Column(Boolean, default=True)
