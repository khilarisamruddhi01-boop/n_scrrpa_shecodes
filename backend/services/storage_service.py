import datetime
from core.firebase import get_bucket
import os

def generate_signed_url(blob_path: str, expiry_minutes: int = 60) -> str:
    """
    Generate a signed URL for reading/downloading an object from Firebase Storage.
    """
    try:
        bucket = get_bucket()
        blob = bucket.blob(blob_path)
        url = blob.generate_signed_url(
            expiration=datetime.timedelta(minutes=expiry_minutes),
            method="GET",
            version="v4"
        )
        return url
    except Exception as e:
        print(f"Error generating signed URL for {blob_path}: {e}")
        return None

def generate_upload_signed_url(blob_path: str, expiry_minutes: int = 15) -> str:
    """
    Generate a signed URL for uploading an object to Firebase Storage directly from the client.
    """
    try:
        bucket = get_bucket()
        blob = bucket.blob(blob_path)
        url = blob.generate_signed_url(
            expiration=datetime.timedelta(minutes=expiry_minutes),
            method="PUT",
            version="v4",
            content_type="application/pdf" # Can be customized based on requirements
        )
        return url
    except Exception as e:
        print(f"Error generating upload signed URL for {blob_path}: {e}")
        return None
