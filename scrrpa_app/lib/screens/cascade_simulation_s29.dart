import 'package:flutter/material.dart';

class CascadeSimulationS29Screen extends StatefulWidget {
  const CascadeSimulationS29Screen({super.key});

  @override
  State<CascadeSimulationS29Screen> createState() => _CascadeSimulationS29ScreenState();
}

class _CascadeSimulationS29ScreenState extends State<CascadeSimulationS29Screen> with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Left Sidebar (Impact Metrics)
          Container(
            width: 280,
            decoration: BoxDecoration(color: Colors.white, border: Border(right: BorderSide(color: primaryColor.withValues(alpha: 0.1)))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.hub, color: Colors.white, size: 20)),
                      const SizedBox(width: 12),
                      const Text('Cascade S29', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('IMPACT METRICS', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                        const SizedBox(height: 16),
                        _buildMetricBox('Nodes Affected', '1,284', '+12%', Colors.red, primaryColor),
                        _buildMetricBox('Revenue at Risk', '\$4.2M', 'High', Colors.red, Colors.black),
                        _buildMetricBox('Avg. Propagation', '42ms', 'Stable', Colors.grey, Colors.black, isSmall: true),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                _buildSidebarAction(Icons.settings, 'Simulation Settings'),
                _buildSidebarAction(Icons.help_outline, 'Documentation'),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // Main Main Area
          Expanded(
            child: Column(
              children: [
                // Header
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: primaryColor.withValues(alpha: 0.1)))),
                  child: Row(
                    children: [
                      _buildHeaderTab('Simulation Mode', true, primaryColor),
                      const SizedBox(width: 32),
                      _buildHeaderTab('Graph View', false, primaryColor),
                      const Spacer(),
                      OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.download, size: 16), label: const Text('Export Report', style: TextStyle(fontSize: 12))),
                      const SizedBox(width: 12),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.save_outlined), style: IconButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white)),
                    ],
                  ),
                ),

                // Simulation Canvas
                Expanded(
                  child: Stack(
                    children: [
                      Container(color: const Color(0xFFF9FAFB)),
                      // Grid Background
                      Positioned.fill(child: CustomPaint(painter: SimulationGridPainter(primaryColor))),

                      // Canvas Content
                      Center(
                        child: SizedBox(
                          width: 600,
                          height: 400,
                          child: Stack(
                            children: [
                              Positioned.fill(child: CustomPaint(painter: GraphLinkPainter(primaryColor))),
                              // Ripple Effect Node
                              Center(
                                child: AnimatedBuilder(
                                  animation: _rippleController,
                                  builder: (context, child) {
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(width: 48 * (1 + 0.8 * _rippleController.value), height: 48 * (1 + 0.8 * _rippleController.value), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: primaryColor.withValues(alpha: 0.5 * (1 - _rippleController.value)), width: 2))),
                                        Container(width: 48, height: 48, decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: primaryColor.withValues(alpha: 0.4), blurRadius: 20)]), child: const Icon(Icons.bolt, color: Colors.white, size: 24)),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              // Pulsing Secondary Nodes
                              _buildPulsingNode(150, 100, primaryColor),
                              _buildPulsingNode(450, 100, primaryColor),
                              _buildStaticNode(300, 350, Colors.grey.shade400),
                            ],
                          ),
                        ),
                      ),

                      // Toolbag
                      Positioned(
                        top: 24,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.black.withValues(alpha: 0.05)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(width: 8, height: 8, decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle)),
                                const SizedBox(width: 8),
                                const Text('Simulation Running: Cascade Event S29', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                const SizedBox(width: 12),
                                const Text('|', style: TextStyle(color: Colors.grey)),
                                const SizedBox(width: 12),
                                const Text('Step 142/500', style: TextStyle(color: Colors.grey, fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Controls
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: primaryColor.withValues(alpha: 0.1)))),
                  child: Row(
                    children: [
                      // Transport
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            IconButton(onPressed: () {}, icon: const Icon(Icons.restart_alt, size: 20)),
                            IconButton(onPressed: () {}, icon: const Icon(Icons.skip_previous, size: 20)),
                            Container(width: 44, height: 44, decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.play_arrow, color: Colors.white)),
                            IconButton(onPressed: () {}, icon: const Icon(Icons.skip_next, size: 20)),
                            IconButton(onPressed: () {}, icon: const Icon(Icons.stop, size: 20)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Timeline
                      Expanded(
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('00:00:00', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                                Text('Current: 00:14:22', style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                                Text('01:00:00', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SliderTheme(
                              data: SliderThemeData(trackHeight: 2, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6), activeTrackColor: primaryColor, inactiveTrackColor: Colors.grey.shade200, thumbColor: Colors.white, overlayColor: primaryColor.withValues(alpha: 0.1)),
                              child: Slider(value: 0.42, onChanged: (v) {}),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Speed
                      Row(
                        children: [
                          const Text('SPEED ', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                          DropdownButton<String>(value: '1.0x', underline: const SizedBox(), items: ['0.5x', '1.0x', '2.0x'].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))).toList(), onChanged: (v) {}),
                        ],
                      ),
                      const VerticalDivider(width: 32),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.layers_outlined, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Right Toolbar
          Container(
            width: 56,
            decoration: BoxDecoration(color: Colors.white, border: Border(left: BorderSide(color: primaryColor.withValues(alpha: 0.1)))),
            child: Column(
              children: [
                const SizedBox(height: 24),
                IconButton(onPressed: () {}, icon: const Icon(Icons.zoom_in, color: Colors.grey)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.zoom_out, color: Colors.grey)),
                const Divider(height: 32, indent: 12, endIndent: 12),
                IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list, color: Colors.grey)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.layers_outlined, color: Colors.grey)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: primaryColor), style: IconButton.styleFrom(backgroundColor: primaryColor.withValues(alpha: 0.1))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBox(String label, String value, String sub, Color subColor, Color valColor, {bool isSmall = false}) {
    const primaryColor = Color(0xFFEC5B13);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: primaryColor.withValues(alpha: 0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: TextStyle(fontSize: isSmall ? 20 : 28, fontWeight: FontWeight.bold, color: valColor)),
              Row(children: [if (sub == '+12%') Icon(Icons.trending_up, size: 12, color: subColor), const SizedBox(width: 4), Text(sub, style: TextStyle(color: subColor, fontSize: 10, fontWeight: FontWeight.bold))]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarAction(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(children: [Icon(icon, color: Colors.grey, size: 20), const SizedBox(width: 12), Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))]),
        ),
      ),
    );
  }

  Widget _buildHeaderTab(String label, bool isActive, Color primaryColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isActive ? primaryColor : Colors.grey)),
        if (isActive) const SizedBox(height: 4),
        if (isActive) Container(height: 4, width: 60, decoration: BoxDecoration(color: primaryColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))),
      ],
    );
  }

  Widget _buildPulsingNode(double x, double y, Color color) {
    return Positioned(
      left: x - 16,
      top: y - 16,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: color, width: 2), boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3 * _pulseController.value), blurRadius: 10)]),
            child: Center(child: Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle))),
          );
        },
      ),
    );
  }

  Widget _buildStaticNode(double x, double y, Color color) {
    return Positioned(
      left: x - 16,
      top: y - 16,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: color, width: 2)),
        child: Center(child: Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle))),
      ),
    );
  }
}

class SimulationGridPainter extends CustomPainter {
  final Color color;
  SimulationGridPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: 0.1)..strokeWidth = 0.5;
    const double gap = 24.0;
    for (double i = 0; i < size.width; i += gap) {
      for (double j = 0; j < size.height; j += gap) {
        canvas.drawCircle(Offset(i, j), 0.5, paint);
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GraphLinkPainter extends CustomPainter {
  final Color color;
  GraphLinkPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: 0.2)..strokeWidth = 2..style = PaintingStyle.stroke;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawLine(center, const Offset(150, 100), paint);
    canvas.drawLine(center, const Offset(450, 100), paint);
    canvas.drawLine(center, const Offset(300, 350), paint);
    canvas.drawLine(const Offset(150, 100), const Offset(50, 150), paint);
    canvas.drawLine(const Offset(450, 100), const Offset(550, 150), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
