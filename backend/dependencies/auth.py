from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from firebase_admin import auth
from pydantic import BaseModel
from typing import Optional

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

class CurrentUser(BaseModel):
    uid: str
    email: str
    role: Optional[str] = None
    org_id: Optional[str] = None
    email_verified: bool = False

async def get_current_user(token: str = Depends(oauth2_scheme)) -> CurrentUser:
    """
    Dependency to validate Firebase ID Token and return CurrentUser.
    """
    try:
        # Verify the ID token sent from the client
        decoded_token = auth.verify_id_token(token)
        
        email_verified = decoded_token.get("email_verified", False)
        # Note: Depending on rules, you might want to uncomment this to block unverified users entirely:
        # if not email_verified:
        #     raise HTTPException(
        #         status_code=status.HTTP_403_FORBIDDEN,
        #         detail="Email not verified"
        #     )
            
        return CurrentUser(
            uid=decoded_token["uid"],
            email=decoded_token.get("email", ""),
            role=decoded_token.get("role"),
            org_id=decoded_token.get("org_id"),
            email_verified=email_verified
        )
    except auth.InvalidIdTokenError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
    except Exception as e:
        if isinstance(e, HTTPException):
            raise e
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Authentication error: {str(e)}",
            headers={"WWW-Authenticate": "Bearer"},
        )

def require_role(allowed_roles: list):
    async def role_checker(user: CurrentUser = Depends(get_current_user)):
        if user.role not in allowed_roles:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You do not have permission to access this resource"
            )
        return user
    return role_checker
