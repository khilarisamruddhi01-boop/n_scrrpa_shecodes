import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreServiceProvider = Provider((ref) => FirestoreService());

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream for real-time shipment updates
  Stream<DocumentSnapshot> getShipmentStream(String shipmentId) {
    return _db.collection('realtime_data').doc(shipmentId).snapshots();
  }

  // Stream for user notification inbox
  Stream<QuerySnapshot> getNotificationStream(String uid) {
    return _db
        .collection('notifications')
        .doc(uid)
        .collection('inbox')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  // Mark notification as read
  Future<void> markNotificationRead(String uid, String notificationId) async {
    await _db
        .collection('notifications')
        .doc(uid)
        .collection('inbox')
        .doc(notificationId)
        .update({'is_read': true});
  }

  // Stream for global/scoped alerts
  Stream<QuerySnapshot> getAlertsStream({String? orgId, String? sector}) {
    // Basic query, complex logic handled by composite indexes and backend fan-out
    return _db
        .collection('alerts')
        .where('is_active', isEqualTo: true)
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  // Acknowledge alert
  Future<void> acknowledgeAlert(String uid, String alertId) async {
    await _db.collection('alerts').doc(alertId).update({
      'acknowledged_by': FieldValue.arrayUnion([uid])
    });
  }
}
