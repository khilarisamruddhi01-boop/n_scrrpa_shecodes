import firebase_admin
from firebase_admin import messaging

def send_push_notification(topic: str = None, token: str = None, title: str = "", body: str = "", data: dict = None):
    """
    Sends FCM Push Notifications either by topic or specific token.
    """
    if not (topic or token):
        return

    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=body
        ),
        data=data or {},
    )
    
    if topic:
        message.topic = topic
    elif token:
        message.token = token
        
    try:
        response = messaging.send(message)
        return response
    except Exception as e:
        print(f"Failed to send FCM: {e}")
        return None
