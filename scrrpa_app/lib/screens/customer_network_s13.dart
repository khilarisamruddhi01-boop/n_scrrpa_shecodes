import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class CustomerNetworkS13Screen extends StatefulWidget {
  const CustomerNetworkS13Screen({super.key});

  @override
  State<CustomerNetworkS13Screen> createState() => _CustomerNetworkS13ScreenState();
}

class _CustomerNetworkS13ScreenState extends State<CustomerNetworkS13Screen> {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1E3A5F);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Customer Network', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search & Filter
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
                  child: const TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: Colors.grey, size: 20),
                      hintText: 'Search by sector or risk level...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All Sectors', primaryColor.withValues(alpha: 0.1), primaryColor, true),
                      const SizedBox(width: 8),
                      _buildFilterChip('Low Risk', Colors.green.withValues(alpha: 0.1), Colors.green, false),
                      const SizedBox(width: 8),
                      _buildFilterChip('Medium', Colors.amber.withValues(alpha: 0.1), Colors.amber, false),
                      const SizedBox(width: 8),
                      _buildFilterChip('High Risk', Colors.red.withValues(alpha: 0.1), Colors.red, false),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Graph Canvas
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  color: const Color(0xFF0F172A), // Dark canvas
                  child: CustomPaint(
                    painter: NetworkPainter(),
                  ),
                ),
                // Zoom Controls
                Positioned(
                  bottom: 24,
                  right: 16,
                  child: Column(
                    children: [
                      _buildZoomBtn(Icons.add),
                      const SizedBox(height: 8),
                      _buildZoomBtn(Icons.remove),
                      const SizedBox(height: 8),
                      _buildZoomBtn(Icons.center_focus_strong),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Legend
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('LEGEND', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLegendItem(Colors.green, 'Low Risk'),
                    _buildLegendItem(Colors.amber, 'Medium Risk'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLegendItem(Colors.red, 'High Risk'),
                    _buildLegendItem(primaryColor, 'Supplier'),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Node Size = Order Volume', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    Row(
                      children: [
                        Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.black12, shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        Container(width: 9, height: 9, decoration: const BoxDecoration(color: Colors.black12, shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        Container(width: 12, height: 12, decoration: const BoxDecoration(color: Colors.black12, shape: BoxShape.circle)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Edge Width = Frequency', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    Row(
                      children: [
                        Container(width: 30, height: 1, color: Colors.black12),
                        const SizedBox(width: 8),
                        Container(width: 30, height: 3, color: Colors.black12),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomerBottomNav(currentIndex: 3),
    );
  }

  Widget _buildFilterChip(String label, Color bg, Color text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20), border: Border.all(color: text.withValues(alpha: 0.2))),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: text, fontSize: 11, fontWeight: FontWeight.bold)),
          if (isSelected) const Icon(Icons.keyboard_arrow_down, size: 14, color: Color(0xFF1E3A5F)),
        ],
      ),
    );
  }

  Widget _buildZoomBtn(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))]),
      child: Icon(icon, color: const Color(0xFF1E3A5F), size: 20),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class NetworkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final nodes = [
      {'offset': const Offset(-80, -100), 'color': Colors.red, 'radius': 22.0, 'label': 'Stop B', 'client': 'TechFlow'},
      {'offset': const Offset(100, -80), 'color': Colors.green, 'radius': 18.0, 'label': 'C-1', 'client': 'LogiCorp'},
      {'offset': const Offset(-100, 100), 'color': Colors.amber, 'radius': 26.0, 'label': 'C-2', 'client': 'BuildIt Ltd'},
      {'offset': const Offset(80, 80), 'color': Colors.green, 'radius': 20.0, 'label': 'C-3', 'client': 'EcoSystems'},
      {'offset': const Offset(20, -120), 'color': Colors.amber, 'radius': 15.0, 'label': 'C-4', 'client': 'FastTrack'},
    ];

    final edgePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeCap = StrokeCap.round;

    // Draw Edges
    for (var node in nodes) {
      final nodeOffset = center + (node['offset'] as Offset);
      edgePaint.strokeWidth = (node['radius'] as double) / 4;
      canvas.drawLine(center, nodeOffset, edgePaint);
    }

    // Draw Central Node
    final mainPaint = Paint()..color = const Color(0xFF1E3A5F);
    canvas.drawCircle(center, 35, mainPaint);
    _drawText(canvas, center, 'Stop A', 10, Colors.white);

    // Draw Client Nodes
    for (var node in nodes) {
      final nodeOffset = center + (node['offset'] as Offset);
      final nodePaint = Paint()..color = node['color'] as Color;
      canvas.drawCircle(nodeOffset, node['radius'] as double, nodePaint);
      _drawText(canvas, nodeOffset, node['label'] as String, 8, Colors.white);
      _drawText(canvas, nodeOffset + const Offset(0, 30), node['client'] as String, 10, Colors.white54);
    }
  }

  void _drawText(Canvas canvas, Offset offset, String text, double fontSize, Color color) {
    final span = TextSpan(style: TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.bold), text: text);
    final tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, offset - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
