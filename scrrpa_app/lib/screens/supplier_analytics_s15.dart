import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';
import 'dart:math' as math;

class SupplierAnalyticsS15Screen extends StatefulWidget {
  const SupplierAnalyticsS15Screen({super.key});

  @override
  State<SupplierAnalyticsS15Screen> createState() => _SupplierAnalyticsS15ScreenState();
}

class _SupplierAnalyticsS15ScreenState extends State<SupplierAnalyticsS15Screen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.analytics_outlined, color: Colors.white, size: 20),
        ),
        title: const Text('Supplier Analytics', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download, size: 16),
              label: const Text('Export', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Tabs
            Container(
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12))),
              child: TabBar(
                controller: _tabController,
                labelColor: primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: primaryColor,
                tabs: const [
                  Tab(icon: Icon(Icons.local_shipping_outlined, size: 20), text: 'Delivery'),
                  Tab(icon: Icon(Icons.inventory_2_outlined, size: 20), text: 'Orders'),
                  Tab(icon: Icon(Icons.warning_amber_outlined, size: 20), text: 'Risk'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Top Stats Row
            Row(
              children: [
                Expanded(child: _buildArcGaugeCard('Delivery Reliability', '94.2%', '+2.1%', primaryColor)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildBarChartCard('Order Frequency', primaryColor)),
                const SizedBox(width: 16),
                Expanded(child: _buildRadarCard('Route Risk Exposure', primaryColor)),
              ],
            ),
            const SizedBox(height: 16),

            // Delay Heatmap
            _buildHeatmapSection(primaryColor),
            const SizedBox(height: 16),

            // Route Table
            _buildRouteTable(primaryColor),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const SupplierBottomNav(currentIndex: 3),
    );
  }

  Widget _buildArcGaugeCard(String title, String value, String change, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(change, style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(size: const Size(200, 100), painter: ArcPainter(0.85, primaryColor)),
                Positioned(
                  bottom: 0,
                  child: Column(
                    children: [
                      Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const Text('ON-TIME RATE', style: TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChartCard(String title, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar(0.6, primaryColor),
              _buildBar(0.85, primaryColor),
              _buildBar(0.45, primaryColor),
              _buildBar(0.7, primaryColor),
              _buildBar(0.95, primaryColor),
              _buildBar(0.55, primaryColor),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('JAN', style: TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
              Text('JUN', style: TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double heightFactor, Color color) {
    return Container(
      width: 12,
      height: 60 * heightFactor,
      decoration: BoxDecoration(color: color.withValues(alpha: 0.2 + (0.8 * heightFactor)), borderRadius: const BorderRadius.vertical(top: Radius.circular(2))),
    );
  }

  Widget _buildRadarCard(String title, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: 80,
              height: 80,
              child: CustomPaint(painter: RadarPainter(primaryColor)),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('GEO', style: TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
              Text('POLIT', style: TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapSection(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Delay Heatmap', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Text('Correlation of shipping delays by day', style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 4, crossAxisSpacing: 4),
            itemCount: 28,
            itemBuilder: (context, index) {
              double intensity = math.Random(index).nextDouble();
              return Container(
                decoration: BoxDecoration(color: primaryColor.withValues(alpha: intensity.clamp(0.1, 1.0)), borderRadius: BorderRadius.circular(4)),
                child: Center(child: Text('${index + 1}', style: TextStyle(fontSize: 10, color: intensity > 0.5 ? Colors.white : Colors.black54))),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRouteTable(Color primaryColor) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active Route Status', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('View All', style: TextStyle(color: Color(0xFFEC5B13), fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          _buildRouteRow('RT-2044', 'ON TIME', 0.15, Colors.green),
          _buildRouteRow('RT-3091', '2H DELAY', 0.45, Colors.orange),
          _buildRouteRow('RT-8821', 'CRITICAL', 0.85, Colors.red),
        ],
      ),
    );
  }

  Widget _buildRouteRow(String id, String status, double risk, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
      child: Row(
        children: [
          Expanded(child: Text(id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
            child: Text(status, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 60,
            child: LinearProgressIndicator(value: risk, backgroundColor: Colors.grey.shade100, color: color, minHeight: 4, borderRadius: BorderRadius.circular(2)),
          ),
        ],
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  final double progress;
  final Color color;
  ArcPainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade100
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height);
    const radius = 80.0;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi, math.pi, false, paint);

    paint.color = color;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi, math.pi * progress, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class RadarPainter extends CustomPainter {
  final Color color;
  RadarPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (var i = 1; i <= 3; i++) {
      canvas.drawCircle(center, radius * (i / 3), paint);
    }

    final path = Path();
    path.moveTo(center.dx, center.dy - radius * 0.8);
    path.lineTo(center.dx + radius * 0.7, center.dy - radius * 0.3);
    path.lineTo(center.dx + radius * 0.5, center.dy + radius * 0.6);
    path.lineTo(center.dx - radius * 0.5, center.dy + radius * 0.6);
    path.lineTo(center.dx - radius * 0.7, center.dy - radius * 0.3);
    path.close();

    canvas.drawPath(path, Paint()..color = color.withValues(alpha: 0.3)..style = PaintingStyle.fill);
    canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
