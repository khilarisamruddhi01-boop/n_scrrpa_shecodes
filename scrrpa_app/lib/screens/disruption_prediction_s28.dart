import 'package:flutter/material.dart';

class DisruptionPredictionS28Screen extends StatefulWidget {
  const DisruptionPredictionS28Screen({super.key});

  @override
  State<DisruptionPredictionS28Screen> createState() => _DisruptionPredictionS28ScreenState();
}

class _DisruptionPredictionS28ScreenState extends State<DisruptionPredictionS28Screen> {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.analytics_outlined, color: primaryColor, size: 20)),
        ),
        title: const Text('Disruption Forecast', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [IconButton(icon: const Icon(Icons.notifications_none, color: Colors.grey), onPressed: () {})],
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildTab('30 Days', true, primaryColor),
                _buildTab('60 Days', false, primaryColor),
                _buildTab('90 Days', false, primaryColor),
                _buildTab('Custom Range', false, primaryColor),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Probability card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black.withValues(alpha: 0.05)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('OVERALL DISRUPTION PROBABILITY', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('68.4%', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: -1)),
                      const SizedBox(width: 8),
                      const Padding(padding: EdgeInsets.only(bottom: 8), child: Row(children: [Icon(Icons.trending_up, color: Colors.green, size: 16), Text('+12.3%', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14))])),
                    ],
                  ),
                  const Text('Based on real-time global supply chain telemetry', style: TextStyle(color: Colors.grey, fontSize: 11, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 24),
                  // Mock Chart
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: CustomPaint(painter: _ChartPainter(primaryColor)),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildLegendItem('Predicted Probability', primaryColor),
                      const SizedBox(width: 16),
                      _buildLegendItem('95% Confidence Band', primaryColor.withValues(alpha: 0.1)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            const Text('Risk Exposure Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Risk cards
            _buildRiskCard('Port Congestion (Singapore)', 'Vessel backlog expected to increase transit time by 4.2 days.', '82%', '+96h', 'High Impact', Colors.red, primaryColor),
            const SizedBox(height: 16),
            _buildRiskCard('Semiconductor Shortage', 'Tier 2 supplier reporting material deficit in Silicon wafers.', '45%', '-15%', 'Mid Impact', Colors.orange, primaryColor),
            const SizedBox(height: 24),

            // AI Recommendation
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.05), border: Border.all(color: primaryColor.withValues(alpha: 0.1)), borderRadius: BorderRadius.circular(16)),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb_outline, color: primaryColor),
                  SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('AI Recommendation', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14)), SizedBox(height: 4), Text('Switching Route #24 to Air Freight via Doha could reduce delay probability by 34% for critical shipments arriving within Day 15-20.', style: TextStyle(fontSize: 13, color: Colors.black87))])),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Overview'),
          BottomNavigationBarItem(icon: Icon(Icons.query_stats_outlined), label: 'Predictions'),
          BottomNavigationBarItem(icon: Icon(Icons.history_outlined), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool isActive, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(right: 24),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isActive ? primaryColor : Colors.transparent, width: 2))),
      child: Text(label, style: TextStyle(color: isActive ? primaryColor : Colors.grey, fontSize: 13, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 6), Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10))]);
  }

  Widget _buildRiskCard(String title, String desc, String probText, String impactText, String urgency, Color urgencyColor, Color primaryColor) {
    double prob = double.parse(probText.replaceAll('%', '')) / 100.0;
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(title.contains('Port') ? Icons.waves : Icons.factory_outlined, color: primaryColor, size: 18)),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: urgencyColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)), child: Text(urgency.toUpperCase(), style: TextStyle(color: urgencyColor, fontSize: 8, fontWeight: FontWeight.bold))),
                  ],
                ),
                const SizedBox(height: 12),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('PROBABILITY', style: TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold)), Text(probText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(title.contains('Port') ? 'ETA DELAY' : 'INVENTORY RISK', style: const TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold)), Text(impactText, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor))]),
                  ],
                ),
              ],
            ),
          ),
          LinearProgressIndicator(value: prob, backgroundColor: Colors.grey.shade100, valueColor: AlwaysStoppedAnimation(primaryColor), minHeight: 4),
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final Color mainColor;
  _ChartPainter(this.mainColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = mainColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.5, size.width * 0.4, size.height * 0.7);
    path.cubicTo(size.width * 0.6, size.height * 0.9, size.width * 0.8, size.height * 0.4, size.width, size.height * 0.3);

    final bandPaint = Paint()
      ..color = mainColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final bandPath = Path();
    bandPath.moveTo(0, size.height * 0.6);
    bandPath.quadraticBezierTo(size.width * 0.2, size.height * 0.4, size.width * 0.4, size.height * 0.6);
    bandPath.cubicTo(size.width * 0.6, size.height * 0.8, size.width * 0.8, size.height * 0.3, size.width, size.height * 0.2);
    bandPath.lineTo(size.width, size.height * 0.4);
    bandPath.cubicTo(size.width * 0.8, size.height * 0.5, size.width * 0.6, size.height * 1.0, size.width * 0.4, size.height * 0.8);
    bandPath.quadraticBezierTo(size.width * 0.2, size.height * 0.6, 0, size.height * 0.8);
    bandPath.close();

    canvas.drawPath(bandPath, bandPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
