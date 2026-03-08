from fastapi import APIRouter, Depends, HTTPException, status
from firebase_admin import auth as firebase_auth
from sqlalchemy.orm import Session
from dependencies.auth import get_current_user, CurrentUser
from pydantic import BaseModel
from typing import Optional
from database import get_db
from models.database import User
import secrets
import datetime

router = APIRouter()

class UserRegister(BaseModel):
    uid: str
    email: str
    role: str
    org_name: Optional[str] = None
    # Add other fields as needed for S04/S38

@router.post("/register")
async def register_user(user_data: UserRegister, db: Session = Depends(get_db)):
    """
    Syncs Firebase user with PostgreSQL and sets Custom Claims (role).
    Called from Flutter after Firebase Auth registration.
    """
    try:
        # Check if user already exists
        db_user = db.query(User).filter(User.firebase_uid == user_data.uid).first()
        if db_user:
            return {"status": "success", "message": f"User {user_data.email} already registered."}

        # 1. Update Custom Claims in Firebase (Role-Based Access Control)
        # In a real scenario, role might be 'pending' until admin approval (S38)
        org_id = "ORG_" + user_data.uid[:8] # Placeholder org_id
        firebase_auth.set_custom_user_claims(user_data.uid, {
            "role": user_data.role,
            "org_id": org_id 
        })
        
        otp_code = "".join([str(secrets.randbelow(10)) for _ in range(6)])
        otp_expiry = datetime.datetime.utcnow() + datetime.timedelta(minutes=15)

        # 2. Store in PostgreSQL
        new_user = User(
            firebase_uid=user_data.uid, 
            email=user_data.email, 
            role=user_data.role,
            org_id=org_id,
            is_email_verified=False,
            otp_code=otp_code,
            otp_expiry=otp_expiry
        )
        db.add(new_user)
        db.commit()
        db.refresh(new_user)
        
        # In a real app, send the OTP via SMTP/SendGrid here.
        print(f"DEBUG: Sent OTP {otp_code} to {user_data.email}")
        
        return {"status": "success", "message": f"User {user_data.email} registered. OTP sent."}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))

class OTPVerify(BaseModel):
    otp: str

@router.post("/verify-otp")
async def verify_otp(data: OTPVerify, current_user: CurrentUser = Depends(get_current_user), db: Session = Depends(get_db)):
    """
    Validates the 6-digit OTP, updates PostgreSQL and Firebase Custom Claims.
    """
    user = db.query(User).filter(User.firebase_uid == current_user.uid).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
        
    if user.is_email_verified:
        return {"status": "success", "message": "Email already verified"}
        
    if not user.otp_code or user.otp_code != data.otp:
        raise HTTPException(status_code=400, detail="Invalid OTP code")
        
    if user.otp_expiry and datetime.datetime.utcnow() > user.otp_expiry:
        raise HTTPException(status_code=400, detail="OTP code has expired")
        
    # Mark as verified in PostgreSQL
    user.is_email_verified = True
    user.otp_code = None
    user.otp_expiry = None
    db.commit()
    
    # Mark as verified in Firebase
    firebase_auth.update_user(current_user.uid, email_verified=True)
    
    return {"status": "success", "message": "Email verified successfully"}

@router.post("/resend-otp")
async def resend_otp(current_user: CurrentUser = Depends(get_current_user), db: Session = Depends(get_db)):
    """
    Regenerates OTP and updates expiry.
    """
    user = db.query(User).filter(User.firebase_uid == current_user.uid).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
        
    if user.is_email_verified:
        return {"status": "success", "message": "Email already verified"}
        
    otp_code = "".join([str(secrets.randbelow(10)) for _ in range(6)])
    user.otp_code = otp_code
    user.otp_expiry = datetime.datetime.utcnow() + datetime.timedelta(minutes=15)
    db.commit()
    
    # In a real app, send the OTP via SMTP/SendGrid here.
    print(f"DEBUG: Resent OTP {otp_code} to {user.email}")
    
    return {"status": "success", "message": "New OTP sent"}

class GoogleUserAuth(BaseModel):
    uid: str
    email: str
    role: str

@router.post("/google")
async def google_auth(user_data: GoogleUserAuth, db: Session = Depends(get_db)):
    """
    Syncs Firebase Google Auth user with PostgreSQL. Upserts if necessary.
    """
    try:
        db_user = db.query(User).filter(User.firebase_uid == user_data.uid).first()
        
        org_id = "ORG_" + user_data.uid[:8] # Placeholder org_id
        
        if not db_user:
            # Upsert PostgreSQL User
            new_user = User(
                firebase_uid=user_data.uid,
                email=user_data.email,
                role=user_data.role,
                org_id=org_id,
                is_email_verified=True # Google emails are verified
            )
            db.add(new_user)
            db.commit()
            db.refresh(new_user)
            
            # Set Custom Claims in Firebase
            firebase_auth.set_custom_user_claims(user_data.uid, {
                "role": user_data.role,
                "org_id": org_id 
            })
            
            return {
                "status": "success", 
                "message": "User created", 
                "role": user_data.role, 
                "org_id": org_id
            }
        else:
            # Ensure email is updated just in case
            if db_user.email != user_data.email:
                db_user.email = user_data.email
                db.commit()
                
            return {
                "status": "success", 
                "message": "User exists", 
                "role": db_user.role, 
                "org_id": db_user.org_id
            }
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/me")
async def get_me(current_user: CurrentUser = Depends(get_current_user)):
    """
    Returns user profile combined from Firebase token and PostgreSQL.
    """
    return {
        "uid": current_user.uid,
        "email": current_user.email,
        "role": current_user.role,
        "org_id": current_user.org_id,
        "status": "active"
    }

@router.post("/fcm-token")
async def update_fcm_token(data: dict, current_user: CurrentUser = Depends(get_current_user), db: Session = Depends(get_db)):
    """
    Updates the user's FCM token for push notifications.
    """
    token = data.get("token")
    if not token:
        raise HTTPException(status_code=400, detail="Token missing")
    
    # Update in PostgreSQL
    user = db.query(User).filter(User.firebase_uid == current_user.uid).first()
    if user:
        user.fcm_token = token
        db.commit()
    
    return {"status": "success"}
