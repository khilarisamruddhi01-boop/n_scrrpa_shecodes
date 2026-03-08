import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class ShipmentTrackingS12Screen extends StatelessWidget {
  const ShipmentTrackingS12Screen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const navyDeep = Color(0xFF1E3A5F);

    return Scaffold(
      body: Stack(
        children: [
          // 1. Simulated Map Layer
          Positioned.fill(
            child: Container(
              color: const Color(0xFFF1F5F9),
              child: CustomPaint(
                painter: MapPainter(),
              ),
            ),
          ),

          // 2. Custom App Bar Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    border: const Border(bottom: BorderSide(color: Colors.black12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: navyDeep),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TRACKING',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade500,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const Text(
                              '#SHP-99281',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: navyDeep,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Stack(
                          children: [
                            const Icon(Icons.notifications_none, color: navyDeep),
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Alert Strip
                Container(
                  width: double.infinity,
                  color: const Color(0xFFFFF7ED),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Color(0xFFEA580C), size: 18),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Minor congestion at I-95 North: +15m delay',
                          style: TextStyle(color: Color(0xFF9A3412), fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('DETAILS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFEA580C))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. Floating Action Buttons
          Positioned(
            right: 16,
            bottom: 300,
            child: Column(
              children: [
                _buildMapControl(Icons.layers_outlined),
                const SizedBox(height: 12),
                _buildMapControl(Icons.my_location),
                const SizedBox(height: 12),
                Container(
                  width: 48,
                  height: 56,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: primaryColor.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.route, color: Colors.white, size: 20),
                      Text('RECALC', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 4. Draggable Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.2,
            maxChildSize: 0.6,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        width: 48,
                        height: 5,
                        decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                              child: const Text('IN-TRANSIT', style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 4),
                            const Text('ETA: 4h 20m', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: navyDeep)),
                            const Text('Oct 28, 2023 • 05:30 PM', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.security, color: Colors.green, size: 18),
                                const SizedBox(width: 4),
                                const Text('12/100', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                              ],
                            ),
                            const Text('RISK SCORE', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      children: [
                        Expanded(child: _InfoTile(label: 'ORIGIN', value: 'Stop A Factory, NJ', subValue: 'Departure: 08:00 AM')),
                        SizedBox(width: 16),
                        Expanded(child: _InfoTile(label: 'DESTINATION', value: 'Stop B Customer, MA', subValue: 'Total Dist: 240 mi')),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(backgroundColor: Colors.grey.shade100, child: const Icon(Icons.person, color: Colors.grey)),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ASSIGNED DRIVER', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                            Text('Marcus Thorne', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                        const Spacer(),
                        _buildCircleAction(Icons.call),
                        const SizedBox(width: 12),
                        _buildCircleAction(Icons.chat_bubble_outline),
                      ],
                    ),
                    const SizedBox(height: 100), // Space for bottom nav
                  ],
                ),
              );
            },
          ),

          // 5. Fixed Bottom Nav
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: const SupplierBottomNav(currentIndex: 2),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControl(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Icon(icon, color: Colors.grey.shade600),
    );
  }

  Widget _buildCircleAction(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
      child: Icon(icon, color: const Color(0xFFEC5B13), size: 18),
    );
  }

}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final String subValue;

  const _InfoTile({required this.label, required this.value, required this.subValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
          Text(subValue, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
        ],
      ),
    );
  }
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    // Draw grid lines
    final gridPaint = Paint()..color = Colors.black12..strokeWidth = 0.5;
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // Draw route
    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.8)
      ..lineTo(size.width * 0.3, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.6, size.width * 0.4, size.height * 0.4)
      ..lineTo(size.width * 0.7, size.height * 0.2);
    
    // Dashed effect manually
    final dashPaint = Paint()
      ..color = const Color(0xFFEC5B13)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    
    canvas.drawPath(path, dashPaint);

    // Vehicle Marker
    final vehiclePos = Offset(size.width * 0.45, size.height * 0.5);
    canvas.drawCircle(vehiclePos, 8, Paint()..color = const Color(0xFFEC5B13));
    canvas.drawCircle(vehiclePos, 15, Paint()..color = const Color(0xFFEC5B13).withValues(alpha: 0.2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
