import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class MainDashboardS25Screen extends StatefulWidget {
  const MainDashboardS25Screen({super.key});

  @override
  State<MainDashboardS25Screen> createState() => _MainDashboardS25ScreenState();
}

class _MainDashboardS25ScreenState extends State<MainDashboardS25Screen> {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const darkBgColor = Color(0xFF0F172A);
    const lightBgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: lightBgColor,
      appBar: AppBar(
        backgroundColor: darkBgColor,
        elevation: 4,
        leadingWidth: 40,
        leading: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Icon(Icons.analytics_outlined, color: primaryColor, size: 28),
        ),
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(text: 'N-SCRRA ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(text: 'v2.5', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.normal)),
            ],
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {}),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                  child: const Text('14', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CircleAvatar(radius: 16, backgroundColor: Colors.grey.shade700, child: const Icon(Icons.person, size: 20, color: Colors.white70)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Risk Index Gauge
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('NATIONAL RISK INDEX', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                        child: const Row(
                          children: [
                            Icon(Icons.trending_up, color: Colors.red, size: 12),
                            SizedBox(width: 4),
                            Text('+5.2%', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: CircularProgressIndicator(value: 0.68, strokeWidth: 12, backgroundColor: Colors.grey.shade100, color: primaryColor),
                      ),
                      Column(
                        children: [
                          RichText(text: const TextSpan(children: [TextSpan(text: '68', style: TextStyle(color: Colors.black, fontSize: 36, fontWeight: FontWeight.w900)), TextSpan(text: '/100', style: TextStyle(color: Colors.grey, fontSize: 16))])),
                          const Text('ELEVATED RISK', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _GaugeStat('Geopolitical', '42'),
                      _GaugeStat('Logistics', '84'),
                      _GaugeStat('Resource', '51'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Sectors
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sector Risk Analysis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSectorCard('Pharma', '74', '+12%', Icons.medication, Colors.blue.shade400, isDark: true),
                  _buildSectorCard('Automotive', '45', '-2%', Icons.directions_car, primaryColor),
                  _buildSectorCard('Electronics', '59', '+1%', Icons.memory, primaryColor),
                  _buildSectorCard('FMCG', '32', '-5%', Icons.shopping_basket, primaryColor),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Heatmap
            const Text('Geographic Risk Intensity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(color: darkBgColor, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]),
              child: Stack(
                children: [
                  const Center(child: Opacity(opacity: 0.2, child: Icon(Icons.public, color: Colors.white10, size: 200))),
                  Positioned(left: 60, top: 40, child: _buildHotspot()),
                  Positioned(right: 80, bottom: 60, child: _buildHotspot()),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Row(
                      children: [
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                        SizedBox(width: 8),
                        Text('Live Data: East Coast Port Congestion', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const Positioned(top: 12, right: 12, child: Icon(Icons.fullscreen, color: Colors.white70, size: 20)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Disruptions
            const Text('Active Disruptions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildDisruptionItem('Major Port Strike', 'East Coast Hubs • 48h duration', 'CRITICAL', Colors.red, Icons.anchor),
            _buildDisruptionItem('Severe Weather', 'Midwest Logistics Route • Expected 12h', 'MODERATE', Colors.amber, Icons.thunderstorm),
            _buildDisruptionItem('Tier 2 Supplier Delay', 'Semiconductor Shortage • Ongoing', 'MINOR', Colors.blue, Icons.factory),

            const SizedBox(height: 24),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildStatusLabel('API ONLINE', Colors.green),
                      const SizedBox(width: 12),
                      _buildStatusLabel('REFRESHED 2M AGO', Colors.green),
                    ],
                  ),
                  const Text('SECURE ENCRYPTED', style: TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 0),
    );
  }

  Widget _buildSectorCard(String label, String value, String change, IconData icon, Color iconColor, {bool isDark = false}) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF0F172A) : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05)), boxShadow: [if (isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 20),
              Text(change, style: TextStyle(color: change.startsWith('+') ? Colors.red : Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),
          Text(label, style: TextStyle(color: isDark ? Colors.white54 : Colors.grey, fontSize: 11)),
          Text(value, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDisruptionItem(String title, String subtitle, String tag, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border(left: BorderSide(color: color, width: 4))),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 28)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)), child: Text(tag, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildStatusLabel(String text, Color color) {
    return Row(
      children: [
        Icon(Icons.check_circle, color: color, size: 10),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildHotspot() {
    const primaryColor = Color(0xFFEC5B13); // Define primaryColor here as it's used
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.3), shape: BoxShape.circle),
      child: Center(child: Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
    );
  }
}

class _GaugeStat extends StatelessWidget {
  final String label;
  final String value;
  const _GaugeStat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
