import 'package:flutter/material.dart';

class AlertCenterS33Screen extends StatefulWidget {
  const AlertCenterS33Screen({super.key});

  @override
  State<AlertCenterS33Screen> createState() => _AlertCenterS33ScreenState();
}

class _AlertCenterS33ScreenState extends State<AlertCenterS33Screen> {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text('Alert Center', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {})],
      ),
      body: Column(
        children: [
          // Nav Tabs
          Container(
            color: Colors.white,
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildNavItem('All', true, primaryColor),
                _buildNavItem('Critical', false, primaryColor),
                _buildNavItem('High', false, primaryColor),
                _buildNavItem('Medium', false, primaryColor),
                _buildNavItem('Low', false, primaryColor),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Critical Alert Card
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.red.withValues(alpha: 0.2)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.red, primaryColor])),
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.bottomLeft,
                        child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)), child: const Text('SEVERITY: CRITICAL', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Database Latency Spikes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 8),
                            const Text('Primary database instance (DB-Cluster-01) is experiencing sustained latency over 500ms, affecting user authentication services.', style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4)),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                children: [
                                  _buildInfoRow(Icons.account_tree, 'Affected Entities', 'DB-Cluster-01, API-Gateway-North, Auth-Service-v2', primaryColor),
                                  const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1)),
                                  _buildInfoRow(Icons.verified_user, 'Recommended Action', 'Initiate failover to standby replica in Region US-East-2 and scale up API instances.', primaryColor),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), minimumSize: const Size(0, 48)), child: const Text('Acknowledge', style: TextStyle(fontWeight: FontWeight.bold)))),
                                const SizedBox(width: 8),
                                Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: primaryColor.withValues(alpha: 0.1), foregroundColor: primaryColor, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), minimumSize: const Size(0, 48)), child: const Text('Snooze', style: TextStyle(fontWeight: FontWeight.bold)))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // High Severity Card
                _buildAlertCard('Unauthorized API Access Pattern', 'Detected 500+ failed login attempts from IP 192.168.1.45 targeting the Admin portal.', 'High Severity', '14m ago', Colors.orange, primaryColor),
                const SizedBox(height: 12),
                // Medium Severity Card
                _buildAlertCard('S3 Bucket Storage Threshold', "Storage bucket 'user-backups-01' has reached 85% of allocated capacity.", 'Medium Severity', '1h ago', Colors.yellow.shade700, primaryColor),
                const SizedBox(height: 80),
              ],
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
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.storage_outlined), label: 'Assets'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, bool isActive, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isActive ? primaryColor : Colors.grey)),
          if (isActive) const SizedBox(height: 4),
          if (isActive) Container(height: 3, width: 30, decoration: BoxDecoration(color: primaryColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(3)))),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String desc, Color primaryColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: primaryColor, size: 16),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)), const SizedBox(height: 2), Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 11, height: 1.4))])),
      ],
    );
  }

  Widget _buildAlertCard(String title, String desc, String severity, String time, Color severityColor, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: severityColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)), child: Text(severity.toUpperCase(), style: TextStyle(color: severityColor, fontSize: 8, fontWeight: FontWeight.w900))),
              Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.4)),
          const SizedBox(height: 16),
          Row(
            children: [
              OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(side: BorderSide(color: primaryColor.withValues(alpha: 0.3)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), minimumSize: const Size(0, 32)), child: const Text('Acknowledge', style: TextStyle(color: Color(0xFFEC5B13), fontSize: 11, fontWeight: FontWeight.bold))),
              const SizedBox(width: 8),
              TextButton(onPressed: () {}, child: const Text('View Details', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold))),
            ],
          ),
        ],
      ),
    );
  }
}
