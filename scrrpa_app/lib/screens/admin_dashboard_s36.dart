import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class AdminDashboardS36Screen extends StatefulWidget {
  const AdminDashboardS36Screen({super.key});

  @override
  State<AdminDashboardS36Screen> createState() => _AdminDashboardS36ScreenState();
}

class _AdminDashboardS36ScreenState extends State<AdminDashboardS36Screen> with TickerProviderStateMixin {
  late AnimationController _pingController;

  @override
  void initState() {
    super.initState();
    _pingController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _pingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.shield_outlined, color: Colors.white, size: 20)),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('S36 Core Admin', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
            Text('SYSTEM STATUS: OPTIMAL', style: TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: IconButton(icon: const Icon(Icons.notifications_none, color: primaryColor), onPressed: () {})),
              Positioned(top: 12, right: 12, child: Container(width: 8, height: 8, decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle, border: Border.all(color: bgColor, width: 2)))),
            ],
          ),
          const Padding(padding: EdgeInsets.only(right: 16, left: 4), child: CircleAvatar(radius: 18, backgroundColor: primaryColor, child: Text('SJ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)))),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Stats Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _buildStatCard(context, 'API Latency', '24ms', '-4ms (15m)', Icons.speed, primaryColor, route: '/system_health_s41'),
                _buildStatCard(context, 'System Uptime', '99.98%', '+0.01%', Icons.cloud_done_outlined, primaryColor, isPositive: true, route: '/system_health_s41'),
                _buildStatCard(context, 'Error Rate', '0.02%', '-0.01%', Icons.error_outline, primaryColor, isPositive: true, route: '/system_health_s41'),
                _buildStatCard(context, 'Supplier Approvals', '12 Pending', 'View queue →', Icons.verified_user_outlined, Colors.white, bgColor: primaryColor, route: '/supplier_approvals_s38'),
              ],
            ),
            const SizedBox(height: 16),

            // Activity Chart
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('User Activity Trends', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text('Live throughput tracking', style: TextStyle(color: Colors.grey, fontSize: 12))]), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)), child: const Text('Last 24 Hours', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)))]),
                  const SizedBox(height: 24),
                  const Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [Text('12.4k', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)), SizedBox(width: 8), Text('+12% vs yesterday', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12))]),
                  const SizedBox(height: 24),
                  SizedBox(height: 150, width: double.infinity, child: CustomPaint(painter: ActivityLinePainter(primaryColor))),
                  const SizedBox(height: 8),
                  const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('00:00', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)), Text('08:00', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)), Text('16:00', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)), Text('23:59', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold))]),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Active Disruptions Map
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Active Disruptions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Row(children: [Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)), const SizedBox(width: 8), const Text('3 Global Alerts', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12))])]),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                    child: Stack(
                      children: [
                        Center(child: Opacity(opacity: 0.1, child: Icon(Icons.public, size: 150, color: Colors.grey.shade400))),
                        _buildMapPing(0.3, 0.25, Colors.red),
                        _buildMapPing(0.7, 0.6, primaryColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Side panels
            _buildSourceStatus(primaryColor),
            const SizedBox(height: 16),
            _buildAuditLogs(primaryColor),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 0),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String val, String sub, IconData icon, Color primaryColor, {bool isPositive = false, Color? bgColor, String? route}) {
    return GestureDetector(
      onTap: () {
        if (route != null) Navigator.pushNamed(context, route);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: bgColor ?? Colors.white, borderRadius: BorderRadius.circular(16), border: bgColor == null ? Border.all(color: primaryColor.withValues(alpha: 0.05)) : null, boxShadow: bgColor != null ? [BoxShadow(color: primaryColor.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))] : null),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: TextStyle(color: bgColor == null ? Colors.grey.shade500 : Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)), Icon(icon, color: bgColor == null ? primaryColor : Colors.white, size: 16)]),
            const Spacer(),
            Text(val, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: bgColor == null ? Colors.black : Colors.white)),
            const SizedBox(height: 4),
            if (label == 'Supplier Approvals') Text(sub, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)) else Row(children: [Icon(isPositive ? Icons.trending_up : Icons.trending_down, size: 12, color: isPositive ? Colors.green : primaryColor), const SizedBox(width: 4), Text(sub, style: TextStyle(color: isPositive ? Colors.green : primaryColor, fontSize: 10, fontWeight: FontWeight.bold))]),
          ],
        ),
      ),
    );
  }

  Widget _buildMapPing(double top, double left, Color color) {
    return Positioned(
      top: 200 * top,
      left: 300 * left,
      child: AnimatedBuilder(
        animation: _pingController,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(width: 32 * _pingController.value, height: 32 * _pingController.value, decoration: BoxDecoration(color: color.withValues(alpha: 1 - _pingController.value), shape: BoxShape.circle)),
              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2))),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSourceStatus(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Data Source Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.2,
            children: [
              _buildSourceItem('AWS-West', 'Stable', Colors.green),
              _buildSourceItem('Azure-East', 'Stable', Colors.green),
              _buildSourceItem('DB-Primary', 'Syncing', primaryColor),
              _buildSourceItem('Redis-Cache', 'High Load', Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSourceItem(String name, String status, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black.withValues(alpha: 0.02))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
          const SizedBox(height: 4),
          Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)), const SizedBox(width: 8), Text(status, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))]),
        ],
      ),
    );
  }

  Widget _buildAuditLogs(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Audit Events', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          _buildAuditItem('admin_jane', 'updated security policy', '2 mins ago • IP: 192.168.1.45', Icons.person_outline, Colors.grey),
          _buildAuditItem('Logistics_Hub', 'New API Key generated', '14 mins ago • System Event', Icons.key_outlined, primaryColor),
          _buildAuditItem('System', 'Suspicious login attempt blocked', '42 mins ago • Location: Unknown', Icons.lock_outline, Colors.red),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade100, foregroundColor: Colors.black, elevation: 0, minimumSize: const Size(double.infinity, 44), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text('Download Full Audit Log', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildAuditItem(String user, String action, String meta, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 36, height: 36, decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), shape: BoxShape.circle), child: Icon(icon, size: 18, color: iconColor)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [RichText(text: TextSpan(style: const TextStyle(color: Colors.black87, fontSize: 13), children: [TextSpan(text: user, style: const TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: ' $action')])), const SizedBox(height: 2), Text(meta.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5))])),
        ],
      ),
    );
  }
}

class ActivityLinePainter extends CustomPainter {
  final Color color;
  ActivityLinePainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.cubicTo(size.width * 0.1, size.height * 0.2, size.width * 0.2, size.height * 0.8, size.width * 0.3, size.height * 0.4);
    path.cubicTo(size.width * 0.45, size.height * 0.1, size.width * 0.55, size.height * 0.9, size.width * 0.7, size.height * 0.3);
    path.cubicTo(size.width * 0.85, size.height * 0.1, size.width * 0.9, size.height * 0.5, size.width, size.height * 0.2);

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final paintLine = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;
    final paintFill = Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [color.withValues(alpha: 0.2), Colors.transparent]).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, paintFill);
    canvas.drawPath(path, paintLine);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
