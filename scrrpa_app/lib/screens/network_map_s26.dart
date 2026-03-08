import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/network_providers.dart';
import '../widgets/role_bottom_nav.dart';

class NetworkMapS26Screen extends ConsumerStatefulWidget {
  const NetworkMapS26Screen({super.key});

  @override
  ConsumerState<NetworkMapS26Screen> createState() => _NetworkMapS26ScreenState();
}

class _NetworkMapS26ScreenState extends ConsumerState<NetworkMapS26Screen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const lightBgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: lightBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.menu, color: Colors.black87), onPressed: () {}),
        title: const Text('Supply Network Map', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red.withValues(alpha: 0.2))),
            child: const Row(
              children: [
                Icon(Icons.error, color: Colors.red, size: 14),
                SizedBox(width: 8),
                Text('3 CRITICAL SPOF', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.filter_list, size: 16),
              label: const Text('Filters', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ),
        ],
      ),
      body: ref.watch(networkGraphProvider).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (networkData) {
          final nodes = networkData['nodes'] as List<dynamic>? ?? [];
          final spofState = ref.watch(spofAnalysisProvider);

          return Stack(
            children: [
              // Grid Map Background
          Positioned.fill(child: CustomPaint(painter: NetworkGridPainter())),

          // Graph Connections
          Positioned.fill(child: CustomPaint(painter: NetworkEdgePainter())),

          // Nodes
          _buildNode(100, 150, 'North Factory A', Icons.factory_outlined, primaryColor, false),
          _buildNode(100, 450, 'East Supply Hub', Icons.factory_outlined, primaryColor, false),
          _buildNode(450, 280, 'Global Retail HQ', Icons.corporate_fare_outlined, Colors.grey, false),

          // SPOF Node with Pulse
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Positioned(
                left: 240,
                top: 300,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(width: 80 * (1 + 0.2 * _pulseController.value), height: 80 * (1 + 0.2 * _pulseController.value), decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.2 * (1 - _pulseController.value)), shape: BoxShape.circle)),
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.red.withValues(alpha: 0.4), blurRadius: 20)]),
                          child: const Icon(Icons.local_shipping, color: Colors.white, size: 36),
                        ),
                        Positioned(top: 0, right: 0, child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.red)), child: const Icon(Icons.priority_high, size: 12, color: Colors.red))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Central SPOF Hub', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13)),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Text('RISK: 9.8', style: TextStyle(color: Colors.red, fontSize: 8, fontWeight: FontWeight.bold))),
                  ],
                ),
              );
            },
          ),

          // Map Controls
          Positioned(
            right: 16,
            top: 16,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)]),
                  child: Column(
                    children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.add, color: Colors.grey)),
                      const Divider(height: 1, indent: 8, endIndent: 8),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.remove, color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildMapControl(Icons.near_me_outlined),
                const SizedBox(height: 12),
                _buildMapControl(Icons.layers_outlined),
              ],
            ),
          ),

          // Legend
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
              child: const Row(
                children: [
                  _LegendItem('Suppliers', primaryColor),
                  SizedBox(width: 16),
                  _LegendItem('SPOF Risks', Colors.red),
                  SizedBox(width: 16),
                  _LegendItem('Customers', Colors.grey),
                ],
              ),
            ),
          ),
        ],
      );
        },
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 2),
    );
  }

  Widget _buildNode(double x, double y, String label, IconData icon, Color color, bool isSPOF) {
    return Positioned(
      left: x,
      top: y,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: color, width: 2), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)]),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMapControl(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)]),
      child: Icon(icon, color: Colors.grey, size: 20),
    );
  }
}

class NetworkGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFEC5B13).withValues(alpha: 0.05)..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NetworkEdgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFEC5B13).withValues(alpha: 0.3)..strokeWidth = 2..style = PaintingStyle.stroke;

    _drawEdge(canvas, const Offset(164, 182), const Offset(275, 305), paint);
    _drawEdge(canvas, const Offset(164, 482), const Offset(275, 370), paint);
    _drawEdge(canvas, const Offset(310, 335), const Offset(450, 312), paint);

    // SPOF Critical Edge
    final criticalPaint = Paint()..color = Colors.red.withValues(alpha: 0.3)..strokeWidth = 2..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(164, 482), const Offset(450, 312), criticalPaint);
  }

  void _drawEdge(Canvas canvas, Offset start, Offset end, Paint paint) {
    canvas.drawLine(start, end, paint);
    // Minimal arrowhead logic could go here
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  const _LegendItem(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
