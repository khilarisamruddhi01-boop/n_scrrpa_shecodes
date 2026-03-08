import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class SystemHealthS41Screen extends StatefulWidget {
  const SystemHealthS41Screen({super.key});

  @override
  State<SystemHealthS41Screen> createState() => _SystemHealthS41ScreenState();
}

class _SystemHealthS41ScreenState extends State<SystemHealthS41Screen> {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.health_and_safety_outlined, color: Colors.white, size: 20)),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(text: const TextSpan(style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16), children: [TextSpan(text: 'System Health '), TextSpan(text: '(S41)', style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.normal))])),
            const Text('Monitoring 4 active regions', style: TextStyle(color: Colors.grey, fontSize: 10)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.grey), onPressed: () {}),
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(icon: const Icon(Icons.notifications_none, color: Colors.grey), onPressed: () {}),
              Positioned(top: 12, right: 12, child: Container(width: 8, height: 8, decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)))),
            ],
          ),
          const Padding(padding: EdgeInsets.only(right: 16, left: 4), child: CircleAvatar(radius: 16, backgroundColor: Color(0x1AEC5B13), child: Icon(Icons.person, color: primaryColor, size: 20))),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Real-time metrics
            Row(
              children: [
                _buildMetricCard('API Latency', '45ms', '+5%', Icons.timer_outlined, 0.45, primaryColor, isUp: true),
                const SizedBox(width: 12),
                _buildMetricCard('Error Rate', '0.02%', '-0.01%', Icons.error_outline, 0.02, Colors.green, isUp: false),
                const SizedBox(width: 12),
                _buildMetricCard('DB Load', '18%', '+2%', Icons.storage_outlined, 0.18, primaryColor, isUp: true),
              ],
            ),
            const SizedBox(height: 32),

            // Service status
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Service Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), TextButton.icon(onPressed: () {}, icon: const Icon(Icons.refresh, size: 14, color: primaryColor), label: const Text('Refresh All', style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold)))]),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.9,
              children: [
                _buildServiceCard('Auth Service', 'V2.4.1 • cluster-a1', 'Online', Icons.verified_user_outlined, Colors.green, primaryColor),
                _buildServiceCard('API Gateway', 'V3.1.0 • edge-main', 'Online', Icons.hub_outlined, Colors.green, primaryColor),
                _buildServiceCard('Worker Node', 'Memory Pressure: 92%', 'Degraded', Icons.engineering_outlined, Colors.orange, primaryColor, isActionPrimary: true),
                _buildServiceCard('Database', 'Primary-Replica Sync: OK', 'Online', Icons.storage_outlined, Colors.green, primaryColor),
              ],
            ),
            const SizedBox(height: 32),

            // Logs
            Container(
              decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.1))),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: const Color(0xFF1E293B),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)), const SizedBox(width: 8), const Text('LIVE LOGS', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1))]),
                        Row(children: [const Text('All Services', style: TextStyle(color: Colors.white38, fontSize: 10)), const Icon(Icons.expand_more, color: Colors.white38, size: 14), const SizedBox(width: 8), const Icon(Icons.download, color: Colors.white38, size: 14)]),
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(12),
                    child: ListView(
                      children: [
                        _buildLogItem('14:22:01', 'INFO', 'Auth-Service: Token validated for UID: 98231', Colors.blue),
                        _buildLogItem('14:22:03', 'INFO', 'API-Gateway: GET /v1/products/list - 200 OK (12ms)', Colors.blue),
                        _buildLogItem('14:22:05', 'WARN', 'Worker-Node: GC cycle taking longer than expected (400ms)', Colors.orange),
                        _buildLogItem('14:22:07', 'ERROR', 'Database: Deadlock detected in transaction #91223', Colors.red),
                        _buildLogItem('14:22:10', 'INFO', 'API-Gateway: POST /v1/orders/create - 201 Created (45ms)', Colors.blue),
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
      bottomNavigationBar: const AdminBottomNav(currentIndex: 4),
    );
  }

  Widget _buildMetricCard(String label, String val, String trend, IconData icon, double progress, Color color, {required bool isUp}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)), Icon(icon, color: const Color(0xFFEC5B13), size: 14)]),
            const SizedBox(height: 8),
            Text(val, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(children: [Icon(isUp ? Icons.trending_up : Icons.trending_down, size: 10, color: isUp ? Colors.red : Colors.green), Text(trend, style: TextStyle(color: isUp ? Colors.red : Colors.green, fontSize: 10, fontWeight: FontWeight.bold))]),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress, backgroundColor: color.withValues(alpha: 0.1), valueColor: AlwaysStoppedAnimation(color), minHeight: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(String title, String sub, String status, IconData icon, Color statusColor, Color primaryColor, {bool isActionPrimary = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: isActionPrimary ? primaryColor.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.05)), boxShadow: isActionPrimary ? [BoxShadow(color: primaryColor.withValues(alpha: 0.1), blurRadius: 4)] : null),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: statusColor, size: 16)),
              Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)), child: Text(status.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 8, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 9, fontStyle: FontStyle.italic)),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.restart_alt, size: 14),
            label: const Text('Restart', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(backgroundColor: isActionPrimary ? primaryColor : Colors.grey.shade100, foregroundColor: isActionPrimary ? Colors.white : Colors.black87, elevation: 0, minimumSize: const Size(double.infinity, 36), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          ),
        ],
      ),
    );
  }

  Widget _buildLogItem(String time, String level, String msg, Color levelColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('[$time] ', style: const TextStyle(color: Colors.white38, fontSize: 10, fontFamily: 'monospace')),
          Text('$level ', style: TextStyle(color: levelColor, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          Expanded(child: Text(msg, style: const TextStyle(color: Colors.white70, fontSize: 10, fontFamily: 'monospace'))),
        ],
      ),
    );
  }
}

extension ColorExt on Color {
  static const Color orangeOpacity10 = Color(0x1AEC5B13);
}
