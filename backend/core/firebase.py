import firebase_admin
from firebase_admin import credentials, firestore, storage, auth, messaging
import os
import json

def initialize_firebase():
    """
    Initializes Firebase Admin SDK.
    Uses SERVICE_ACCOUNT_KEY path from .env or default environment.
    """
    import logging
    logger = logging.getLogger(__name__)

    service_account_path = os.getenv("FIREBASE_SERVICE_ACCOUNT_JSON")
    
    if not firebase_admin._apps:
        try:
            if service_account_path and os.path.exists(service_account_path):
                cred = credentials.Certificate(service_account_path)
            else:
                cred_json = os.getenv("FIREBASE_SERVICE_ACCOUNT_RAW")
                if cred_json:
                    cred = credentials.Certificate(json.loads(cred_json))
                else:
                    logger.warning("No Firebase credentials provided. Trying Application Default Credentials.")
                    cred = credentials.ApplicationDefault()
            
            firebase_admin.initialize_app(cred, {
                'storageBucket': os.getenv("FIREBASE_STORAGE_BUCKET")
            })
        except Exception as e:
            logger.error(f"Failed to initialize Firebase: {e}")
            return {"db": None, "bucket": None}
    
    try:
        return {
            "db": firestore.client(),
            "bucket": storage.bucket(),
        }
    except Exception as e:
        logger.error(f"Failed to get Firebase clients: {e}")
        return {"db": None, "bucket": None}

def get_db():
    return firestore.client()

def get_bucket():
    return storage.bucket()
