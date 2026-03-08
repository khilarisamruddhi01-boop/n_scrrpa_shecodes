import 'package:flutter/material.dart';

class PredictiveAnalyticsS28Screen extends StatefulWidget {
  const PredictiveAnalyticsS28Screen({super.key});

  @override
  State<PredictiveAnalyticsS28Screen> createState() => _PredictiveAnalyticsS28ScreenState();
}

class _PredictiveAnalyticsS28ScreenState extends State<PredictiveAnalyticsS28Screen> {
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
          child: Container(decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.analytics, color: primaryColor)),
        ),
        title: const Text('Disruption Forecast', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.notifications_none, color: Colors.grey), onPressed: () {})],
      ),
      body: Column(
        children: [
          // Nav
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildNavItem('30 Days', true, primaryColor),
                _buildNavItem('60 Days', false, primaryColor),
                _buildNavItem('90 Days', false, primaryColor),
                _buildNavItem('Custom', false, primaryColor),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Probability Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black.withValues(alpha: 0.05)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('OVERALL DISRUPTION PROBABILITY', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('68.4%', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                              child: const Row(
                                children: [
                                  Icon(Icons.trending_up, color: Colors.green, size: 14),
                                  SizedBox(width: 4),
                                  Text('+12.3%', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Text('Based on real-time global supply chain telemetry', style: TextStyle(color: Colors.grey, fontSize: 10, fontStyle: FontStyle.italic)),
                        const SizedBox(height: 32),
                        SizedBox(height: 140, child: CustomPaint(painter: DisruptionChartPainter(primaryColor))),
                        const SizedBox(height: 16),
                        const Row(
                          children: [
                            _LegendItem(primaryColor, 'Predicted Probability'),
                            SizedBox(width: 16),
                            _LegendItem(Color(0xFFFFE0D1), '95% Confidence Band'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Exposure Breakdown
                  const Text('Risk Exposure Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildRiskCard('Port Congestion', 'Singapore backlog inc. transit time.', '82%', '+96h', 'High Impact', Icons.tsunami, primaryColor, Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildRiskCard('Semiconductor Shortage', 'Tier 2 material deficit in Silicon.', '45%', '-15%', 'Mid Impact', Icons.factory, primaryColor, Colors.orange)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Recommendation
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: primaryColor.withValues(alpha: 0.1))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_outline, color: primaryColor, size: 24),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('AI Recommendation', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
                              SizedBox(height: 4),
                              Text('Switching Route #24 to Air Freight via Doha could reduce delay probability by 34% for critical shipments arriving within Day 15-20.', style: TextStyle(fontSize: 13, height: 1.4)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Overview'),
          BottomNavigationBarItem(icon: Icon(Icons.query_stats), label: 'Predictions'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, bool isActive, Color primaryColor) {
    return Expanded(
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isActive ? primaryColor : Colors.grey))),
          if (isActive) Container(height: 2, color: primaryColor),
        ],
      ),
    );
  }

  Widget _buildRiskCard(String title, String desc, String prob, String stat, String tag, IconData icon, Color primaryColor, Color tagColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: tagColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: tagColor, size: 20)),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: tagColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)), child: Text(tag, style: TextStyle(color: tagColor, fontSize: 8, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('PROBABILITY', style: TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold)), Text(prob, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [const Text('DELAY/RISK', style: TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold)), Text(stat, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18))]),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: double.parse(prob.replaceAll('%', '')) / 100, backgroundColor: Colors.grey.shade100, valueColor: AlwaysStoppedAnimation(primaryColor), minHeight: 4, borderRadius: BorderRadius.circular(2)),
        ],
      ),
    );
  }
}

class DisruptionChartPainter extends CustomPainter {
  final Color color;
  DisruptionChartPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final areaPaint = Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.0)]).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final linePaint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;
    final confidencePaint = Paint()..color = color.withValues(alpha: 0.1)..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.cubicTo(size.width * 0.2, size.height * 0.6, size.width * 0.3, size.height * 0.8, size.width * 0.5, size.height * 0.4);
    path.cubicTo(size.width * 0.7, size.height * 0.2, size.width * 0.8, size.height * 0.5, size.width, size.height * 0.3);

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final confPath = Path();
    confPath.moveTo(0, size.height * 0.6);
    confPath.cubicTo(size.width * 0.2, size.height * 0.5, size.width * 0.3, size.height * 0.7, size.width * 0.5, size.height * 0.3);
    confPath.cubicTo(size.width * 0.7, size.height * 0.1, size.width * 0.8, size.height * 0.4, size.width, size.height * 0.2);
    confPath.lineTo(size.width, size.height * 0.4);
    confPath.cubicTo(size.width * 0.8, size.height * 0.6, size.width * 0.7, size.height * 0.3, size.width * 0.5, size.height * 0.5);
    confPath.cubicTo(size.width * 0.3, size.height * 0.9, size.width * 0.2, size.height * 0.7, 0, size.height * 0.8);
    confPath.close();

    canvas.drawPath(confPath, confidencePaint);
    canvas.drawPath(fillPath, areaPaint);
    canvas.drawPath(path, linePaint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem(this.color, this.label);
  @override
  Widget build(BuildContext context) {
    return Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))), const SizedBox(width: 6), Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10))]);
  }
}
