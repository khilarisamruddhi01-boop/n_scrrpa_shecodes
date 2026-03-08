import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/firestore_service.dart';
import '../widgets/role_bottom_nav.dart';

class CustomerShipmentTrackingS22Screen extends ConsumerStatefulWidget {
  final String shipmentId;
  const CustomerShipmentTrackingS22Screen({super.key, this.shipmentId = "SHP-4429"});

  @override
  ConsumerState<CustomerShipmentTrackingS22Screen> createState() => _CustomerShipmentTrackingS22ScreenState();
}

class _CustomerShipmentTrackingS22ScreenState extends ConsumerState<CustomerShipmentTrackingS22Screen> {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const navyColor = Color(0xFF0F172A);
    final firestoreService = ref.read(firestoreServiceProvider);

    return StreamBuilder<DocumentSnapshot>(
      stream: firestoreService.getShipmentStream(widget.shipmentId),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() as Map<String, dynamic>?;
        final riskScore = data?['risk_score'] ?? 0.05;
        final status = data?['status'] ?? 'In-Transit';
        final eta = data?['eta_timestamp'] != null 
            ? (data?['eta_timestamp'] as Timestamp).toDate().difference(DateTime.now())
            : const Duration(hours: 2, minutes: 45);

        return Scaffold(
          body: Stack(
            children: [
              // Map Background
              Positioned.fill(child: Container(color: const Color(0xFF1E293B))),
              Positioned.fill(child: CustomPaint(painter: TrackingMapPainter(
                truckProgress: 0.6,
              ))),

              // Header Overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, left: 16, right: 16, bottom: 20),
                  decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [navyColor.withValues(alpha: 0.8), Colors.transparent])),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCircleBtn(Icons.arrow_back, navyColor, onTap: () => Navigator.pop(context)),
                      Column(
                        children: [
                          const Text('LIVE TRACKING', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                          Text('#${widget.shipmentId}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                      _buildCircleBtn(Icons.help_outline, navyColor),
                    ],
                  ),
                ),
              ),

              // Map Controls
              Positioned(
                right: 16,
                top: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  children: [
                    _buildMapControl(Icons.add),
                    const SizedBox(height: 8),
                    _buildMapControl(Icons.remove),
                    const SizedBox(height: 16),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: primaryColor.withValues(alpha: 0.3), blurRadius: 10)]),
                      child: const Icon(Icons.my_location, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),

              // Bottom Sheet
              DraggableScrollableSheet(
                initialChildSize: 0.4,
                minChildSize: 0.35,
                maxChildSize: 0.9,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(color: Color(0xFFF8F6F6), borderRadius: BorderRadius.vertical(top: Radius.circular(36)), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 40)]),
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      children: [
                        Center(child: Container(width: 48, height: 6, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(3)))),
                        const SizedBox(height: 24),

                        // Info Grid
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('EST. ARRIVAL', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                                Row(
                                  children: [
                                    const Icon(Icons.schedule, color: primaryColor, size: 20),
                                    const SizedBox(width: 8),
                                    Text('${eta.inHours}h ${eta.inMinutes % 60}m', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: navyColor)),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('CURRENT STATUS', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                                  child: Text(status, style: const TextStyle(color: primaryColor, fontSize: 13, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Details Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
                          child: Row(
                            children: [
                              Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle), child: const Icon(Icons.local_shipping_outlined, color: Colors.grey, size: 20)),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Transport Mode', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                    Text('Road Freight', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Icon(riskScore > 0.5 ? Icons.warning_amber_rounded : Icons.check_circle, 
                                           color: riskScore > 0.5 ? Colors.orange : Colors.green, size: 14),
                                      const SizedBox(width: 4),
                                      Text(riskScore > 0.5 ? 'Alert Detected' : 'On Schedule', 
                                           style: TextStyle(color: riskScore > 0.5 ? Colors.orange : Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Text(riskScore > 0.5 ? 'Medium Risk Alert' : 'Low Risk Indicator', 
                                       style: const TextStyle(color: Colors.grey, fontSize: 9)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Timeline
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle)),
                                  Container(width: 2, height: 40, color: Colors.grey.shade300),
                                  Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle)),
                                ],
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Origin', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)), Text('Stark Factory - Berlin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))]),
                                        Text('08:30 AM', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Destination', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)), Text('North Warehouse - Munich', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey))]),
                                        Text('--:--', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Confirm Btn
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                color: status == 'Arrived' ? primaryColor : Colors.grey.shade200, 
                                borderRadius: BorderRadius.circular(16), 
                                border: Border.all(color: Colors.grey.shade300, style: BorderStyle.none)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.verified_outlined, color: status == 'Arrived' ? Colors.white : Colors.grey, size: 20),
                                  const SizedBox(width: 8),
                                  Text('Confirm Delivery', 
                                       style: TextStyle(color: status == 'Arrived' ? Colors.white : Colors.grey, fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text('Button will activate when the vehicle is within 500m of Stop B.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 10, fontStyle: FontStyle.italic)),
                          ],
                        ),
                        const SizedBox(height: 200),
                      ],
                    ),
                  );
                },
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: const CustomerBottomNav(currentIndex: 2),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCircleBtn(IconData icon, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildMapControl(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(color: const Color(0xFF0F172A).withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

class TrackingMapPainter extends CustomPainter {
  final double truckProgress;
  TrackingMapPainter({this.truckProgress = 0.6});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    final routePaint = Paint()
      ..color = const Color(0xFFEC5B13)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.6, size.width * 0.8, size.height * 0.2);

    canvas.drawPath(path, routePaint);

    final factoryPaint = Paint()..color = const Color(0xFFEC5B13);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.7), 6, factoryPaint);

    final warehousePaint = Paint()..color = const Color(0xFF22C55E)..strokeWidth = 2..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 8, warehousePaint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 8, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);

    final truckPos = Offset(size.width * (0.2 + 0.6 * truckProgress), size.height * (0.7 - 0.5 * truckProgress));
    canvas.drawCircle(truckPos, 14, Paint()..color = const Color(0xFFEC5B13).withValues(alpha: 0.3));
    canvas.drawCircle(truckPos, 8, factoryPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
