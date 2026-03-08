import 'package:flutter/material.dart';
import 'dart:math' as math;

class RiskIntelligenceS27Screen extends StatefulWidget {
  const RiskIntelligenceS27Screen({super.key});

  @override
  State<RiskIntelligenceS27Screen> createState() => _RiskIntelligenceS27ScreenState();
}

class _RiskIntelligenceS27ScreenState extends State<RiskIntelligenceS27Screen> {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.pop(context)),
        title: const Text('Risk Intelligence', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.share_outlined, color: Colors.black87), onPressed: () {})],
      ),
      body: Column(
        children: [
          // Tab Nav
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TabItem('Overview', false),
                _TabItem('Detailed Analytics', true),
                _TabItem('History', false),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Radar & Sector Comparison
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildRadarCard(primaryColor)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildSectorComparison(primaryColor)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Trend Chart
                  _buildTrendForecast(primaryColor),
                  const SizedBox(height: 16),
                  
                  // Historical Table
                  _buildHistoricalTable(primaryColor),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.public_outlined), label: 'Risk Map'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytics'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Reports'),
        ],
      ),
    );
  }

  Widget _buildRadarCard(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Risk Dimensions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 24),
          SizedBox(height: 140, child: CustomPaint(painter: RadarChartPainter(primaryColor), child: Container())),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                RichText(text: const TextSpan(children: [TextSpan(text: '74', style: TextStyle(color: Color(0xFFEC5B13), fontSize: 24, fontWeight: FontWeight.bold)), TextSpan(text: '/100', style: TextStyle(color: Colors.grey, fontSize: 12))])),
                const Text('Aggregate Risk Index', style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectorComparison(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sector Risk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 16),
          _buildSectorBar('Mfg', 0.82, primaryColor),
          _buildSectorBar('Tech', 0.64, primaryColor),
          _buildSectorBar('Energy', 0.91, Colors.red),
          _buildSectorBar('Agri', 0.45, primaryColor),
          _buildSectorBar('Log', 0.77, primaryColor),
        ],
      ),
    );
  }

  Widget _buildSectorBar(String label, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)), Text('${(progress * 100).toInt()}%', style: const TextStyle(fontSize: 10))]),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.shade100, valueColor: AlwaysStoppedAnimation(color), minHeight: 6, borderRadius: BorderRadius.circular(3)),
        ],
      ),
    );
  }

  Widget _buildTrendForecast(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Risk Trends & Forecast', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Row(
                children: [
                  _LegendCircle(primaryColor.withValues(alpha: 0.2), 'Confidence'),
                  const SizedBox(width: 12),
                  _LegendLine(primaryColor, 'Risk Level'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(height: 120, width: double.infinity, child: CustomPaint(painter: TrendForecastPainter(primaryColor))),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('JAN', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
              Text('MAR', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
              Text('MAY', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
              Text('JUL', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoricalTable(Color primaryColor) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Historical Risk Events', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                TextButton(onPressed: () {}, child: Text('Export CSV', style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const Divider(height: 1),
          _buildEventRow('Oct 12, 2023', 'Disruption', 'Critical (8.9)', Colors.red, 'Mitigated', Colors.green),
          _buildEventRow('Aug 28, 2023', 'Geopolitical', 'High (7.2)', Colors.orange, 'Ongoing', Colors.orange),
          _buildEventRow('Jun 15, 2023', 'Currency', 'Medium (5.4)', primaryColor, 'Resolved', Colors.green),
        ],
      ),
    );
  }

  Widget _buildEventRow(String date, String type, String score, Color scoreColor, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), Text(type, style: const TextStyle(color: Colors.grey, fontSize: 10))])),
          Expanded(child: Text(score, style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold, fontSize: 10))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)), child: Text(status, style: TextStyle(color: statusColor, fontSize: 8, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isActive;
  const _TabItem(this.label, this.isActive);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isActive ? const Color(0xFFEC5B13) : Colors.grey))),
        if (isActive) Container(height: 3, width: 40, decoration: const BoxDecoration(color: Color(0xFFEC5B13), borderRadius: BorderRadius.vertical(top: Radius.circular(3)))),
      ],
    );
  }
}

class _LegendCircle extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendCircle(this.color, this.label);
  @override
  Widget build(BuildContext context) {
    return Row(children: [Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))), const SizedBox(width: 4), Text(label, style: const TextStyle(color: Colors.grey, fontSize: 9))]);
  }
}

class _LegendLine extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendLine(this.color, this.label);
  @override
  Widget build(BuildContext context) {
    return Row(children: [Container(width: 12, height: 2, color: color), const SizedBox(width: 4), Text(label, style: const TextStyle(color: Colors.grey, fontSize: 9))]);
  }
}

class RadarChartPainter extends CustomPainter {
  final Color color;
  RadarChartPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final gridPaint = Paint()..color = Colors.grey.shade200..style = PaintingStyle.stroke..strokeWidth = 1;

    for (var i = 1; i <= 3; i++) {
      final r = radius * (i / 3);
      final path = Path();
      for (var j = 0; j < 6; j++) {
        final angle = (j * 60) * math.pi / 180;
        final x = center.dx + r * math.cos(angle);
        final y = center.dy + r * math.sin(angle);
        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    final dataPaint = Paint()..color = color.withValues(alpha: 0.3)..style = PaintingStyle.fill;
    final strokePaint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2;
    final dataPath = Path();
    final scales = [0.8, 0.7, 0.9, 0.6, 0.75, 0.85];
    for (var j = 0; j < 6; j++) {
      final angle = (j * 60) * math.pi / 180;
      final x = center.dx + radius * scales[j] * math.cos(angle);
      final y = center.dy + radius * scales[j] * math.sin(angle);
      if (j == 0) {
        dataPath.moveTo(x, y);
      } else {
        dataPath.lineTo(x, y);
      }
    }
    dataPath.close();
    canvas.drawPath(dataPath, dataPaint);
    canvas.drawPath(dataPath, strokePaint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TrendForecastPainter extends CustomPainter {
  final Color color;
  TrendForecastPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final confidencePaint = Paint()..color = color.withValues(alpha: 0.1)..style = PaintingStyle.fill;
    final trendPaint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2;

    final trendPath = Path();
    trendPath.moveTo(0, size.height * 0.7);
    trendPath.quadraticBezierTo(size.width * 0.2, size.height * 0.4, size.width * 0.4, size.height * 0.6);
    trendPath.quadraticBezierTo(size.width * 0.7, size.height * 0.8, size.width, size.height * 0.5);

    final upperPath = Path();
    upperPath.moveTo(0, size.height * 0.6);
    upperPath.quadraticBezierTo(size.width * 0.2, size.height * 0.3, size.width * 0.4, size.height * 0.5);
    upperPath.quadraticBezierTo(size.width * 0.7, size.height * 0.7, size.width, size.height * 0.4);

    final lowerPath = Path();
    lowerPath.moveTo(0, size.height * 0.8);
    lowerPath.quadraticBezierTo(size.width * 0.2, size.height * 0.5, size.width * 0.4, size.height * 0.7);
    lowerPath.quadraticBezierTo(size.width * 0.7, size.height * 0.9, size.width, size.height * 0.6);

    final fillPath = Path();
    fillPath.moveTo(0, size.height * 0.6);
    fillPath.quadraticBezierTo(size.width * 0.2, size.height * 0.3, size.width * 0.4, size.height * 0.5);
    fillPath.quadraticBezierTo(size.width * 0.7, size.height * 0.7, size.width, size.height * 0.4);
    fillPath.lineTo(size.width, size.height * 0.6);
    fillPath.quadraticBezierTo(size.width * 0.7, size.height * 0.9, size.width * 0.4, size.height * 0.7);
    fillPath.quadraticBezierTo(size.width * 0.2, size.height * 0.5, 0, size.height * 0.8);
    fillPath.close();

    canvas.drawPath(fillPath, confidencePaint);
    canvas.drawPath(trendPath, trendPaint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
