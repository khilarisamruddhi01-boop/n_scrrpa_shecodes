import 'package:flutter/material.dart';

class RouteOptimizationS31Screen extends StatefulWidget {
  const RouteOptimizationS31Screen({super.key});

  @override
  State<RouteOptimizationS31Screen> createState() => _RouteOptimizationS31ScreenState();
}

class _RouteOptimizationS31ScreenState extends State<RouteOptimizationS31Screen> {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);

    return Scaffold(
      body: Stack(
        children: [
          // Background "Map"
          Positioned.fill(child: Container(color: const Color(0xFFE5E7EB))),
          Positioned.fill(child: CustomPaint(painter: RouteMapPainter(primaryColor))),

          // Heatmaps
          Positioned(top: 100, left: 150, child: _buildHeatmap(primaryColor)),
          Positioned(bottom: 300, right: 100, child: _buildHeatmap(primaryColor, size: 200)),

          // Top Inputs Panel
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(20), border: Border.all(color: primaryColor.withValues(alpha: 0.1)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20)]),
              child: Row(
                children: [
                  Column(
                    children: [
                      Icon(Icons.radio_button_checked, color: primaryColor, size: 14),
                      Container(width: 2, height: 24, color: Colors.grey),
                      Icon(Icons.location_on, color: primaryColor, size: 14),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        _buildFakeInput('Silicon Valley Tech Center'),
                        const SizedBox(height: 8),
                        _buildFakeInput('San Francisco Downtown Terminal'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(width: 48, height: 48, decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.sync, color: Colors.white)),
                ],
              ),
            ),
          ),

          // Floating Controls
          Positioned(
            right: 16,
            top: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              children: [
                _buildFloatBtn(Icons.layers_outlined, primaryColor, isActive: true),
                _buildFloatBtn(Icons.my_location, Colors.grey),
                _buildFloatBtn(Icons.add, Colors.grey),
                _buildFloatBtn(Icons.remove, Colors.grey),
              ],
            ),
          ),

          // Legend
          Positioned(
            bottom: 340,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LegendItem('Optimized Route', primaryColor, isDashed: false),
                  const SizedBox(height: 8),
                  _LegendItem('Previous Route', Colors.grey, isDashed: true),
                  const SizedBox(height: 8),
                  _LegendItem('Congestion / Risk', primaryColor.withValues(alpha: 0.3), isCircle: true),
                ],
              ),
            ),
          ),

          // Bottom Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 320,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: const BorderRadius.vertical(top: Radius.circular(32)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 30)]),
              child: Column(
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Route Optimized', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), Text('Efficiency increased by 22%', style: TextStyle(color: Colors.grey.shade500, fontSize: 13))]),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)), child: const Text('SAFE ROUTE FOUND', style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold))),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _buildMetricCard('Distance', '14.2', 'km', '-2.4km', Colors.green),
                      const SizedBox(width: 12),
                      _buildMetricCard('Transit Time', '24', 'min', '-8 min', Colors.green, isHighlight: true, primaryColor: primaryColor),
                      const SizedBox(width: 12),
                      _buildMetricCard('Risk Score', '1.2', '/ 5', 'Low Risk', Colors.green, icon: Icons.security),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.navigation), label: const Text('Start Optimized Trip', style: TextStyle(fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, minimumSize: const Size(0, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))))),
                      const SizedBox(width: 12),
                      OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(minimumSize: const Size(64, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: const Icon(Icons.share, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFakeInput(String text) {
    return Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)), child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87)));
  }

  Widget _buildFloatBtn(IconData icon, Color color, {bool isActive = false}) {
    return Container(margin: const EdgeInsets.only(bottom: 8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isActive ? Color(0xFFEC5B13) : Colors.black12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]), child: IconButton(onPressed: () {}, icon: Icon(icon, color: isActive ? Color(0xFFEC5B13) : color), iconSize: 20));
  }

  Widget _buildHeatmap(Color color, {double size = 150}) {
    return Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.05), Colors.transparent])));
  }

  Widget _buildMetricCard(String label, String value, String unit, String diff, Color diffColor, {bool isHighlight = false, Color primaryColor = Colors.orange, IconData? icon}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: isHighlight ? primaryColor.withValues(alpha: 0.05) : Colors.grey.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: isHighlight ? primaryColor.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.05))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(), style: TextStyle(color: isHighlight ? primaryColor : Colors.grey, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
            const SizedBox(height: 4),
            Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isHighlight ? primaryColor : Colors.black)), const SizedBox(width: 2), Text(unit, style: TextStyle(fontSize: 10, color: isHighlight ? primaryColor.withValues(alpha: 0.6) : Colors.grey))]),
            const SizedBox(height: 4),
            Row(children: [Icon(icon ?? Icons.arrow_downward, size: 10, color: diffColor), const SizedBox(width: 4), Text(diff, style: TextStyle(color: diffColor, fontSize: 8, fontWeight: FontWeight.bold))]),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDashed;
  final bool isCircle;
  const _LegendItem(this.label, this.color, {this.isDashed = false, this.isCircle = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isCircle) Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)) else Container(width: 20, height: 4, decoration: BoxDecoration(color: isDashed ? null : color, borderRadius: BorderRadius.circular(2), border: isDashed ? Border.all(color: color, width: 1, style: BorderStyle.solid) : null)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 9)),
      ],
    );
  }
}

class RouteMapPainter extends CustomPainter {
  final Color primaryColor;
  RouteMapPainter(this.primaryColor);
  @override
  void paint(Canvas canvas, Size size) {
    final paintPrev = Paint()..color = Colors.grey.shade400..strokeWidth = 3..style = PaintingStyle.stroke;
    final paintOpt = Paint()..color = primaryColor..strokeWidth = 5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;

    final pathPrev = Path();
    pathPrev.moveTo(size.width * 0.2, size.height * 0.7);
    pathPrev.quadraticBezierTo(size.width * 0.4, size.height * 0.65, size.width * 0.5, size.height * 0.5);
    pathPrev.quadraticBezierTo(size.width * 0.6, size.height * 0.35, size.width * 0.8, size.height * 0.3);

    final pathOpt = Path();
    pathOpt.moveTo(size.width * 0.2, size.height * 0.7);
    pathOpt.quadraticBezierTo(size.width * 0.3, size.height * 0.6, size.width * 0.45, size.height * 0.58);
    pathOpt.quadraticBezierTo(size.width * 0.6, size.height * 0.55, size.width * 0.8, size.height * 0.3);

    // Draw previous route with dashes
    _drawDashedPath(canvas, pathPrev, paintPrev);
    canvas.drawPath(pathOpt, paintOpt);

    // Points
    final pointPaint = Paint()..color = primaryColor..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.7), 6, pointPaint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.3), 6, pointPaint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const double dashWidth = 8.0;
    const double dashSpace = 8.0;
    final metrics = path.computeMetrics();
    for (var metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + dashWidth), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
