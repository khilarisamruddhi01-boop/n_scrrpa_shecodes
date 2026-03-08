import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class DataSourcesS39Screen extends StatefulWidget {
  const DataSourcesS39Screen({super.key});

  @override
  State<DataSourcesS39Screen> createState() => _DataSourcesS39ScreenState();
}

class _DataSourcesS39ScreenState extends State<DataSourcesS39Screen> {
  bool autoSync = true;
  String syncFreq = 'Every 30 minutes';

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () {}),
        title: const Text('Data Sources (S39)', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [IconButton(icon: const Icon(Icons.settings_outlined, color: Colors.grey), onPressed: () {})],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: bgColor,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildTab('Weather', true, primaryColor),
                _buildTab('Trade', false, primaryColor),
                _buildTab('Port', false, primaryColor),
                _buildTab('Freight', false, primaryColor),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('API Integration Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)), child: Row(children: [Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)), const SizedBox(width: 8), const Text('Operational', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold))])),
              ],
            ),
            const SizedBox(height: 24),

            // Main Integration Card
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [const Text('ACTIVE INTEGRATION', style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)), const SizedBox(width: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)), child: const Text('V2.4', style: TextStyle(color: primaryColor, fontSize: 8, fontWeight: FontWeight.bold)))]),
                        const SizedBox(height: 8),
                        const Text('WeatherStack Global API', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        const Text('Real-time meteorological data for logistics route optimization.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _buildInfoTile('Last Sync', '12 mins ago'),
                            const SizedBox(width: 12),
                            _buildInfoTile('Frequency', 'Every 30m'),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.sync, size: 18), label: const Text('Sync Now'), style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), minimumSize: const Size(0, 44))),
                            const SizedBox(width: 8),
                            OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(foregroundColor: Colors.black87, side: const BorderSide(color: Colors.black12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), minimumSize: const Size(0, 44)), child: const Text('View Logs')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 16 / 5,
                    child: Stack(
                      children: [
                        Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [bgColor, primaryColor.withValues(alpha: 0.2)]))),
                        const Center(child: Icon(Icons.wb_sunny_outlined, color: primaryColor, size: 40)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Config Section
            const Text('CONFIGURATION', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [Icon(Icons.key, color: primaryColor, size: 18), SizedBox(width: 8), Text('API Key Management', style: TextStyle(fontWeight: FontWeight.bold))]),
                  const SizedBox(height: 20),
                  const Text('PRODUCTION API KEY', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(obscureText: true, readOnly: true, controller: TextEditingController(text: '************************'), decoration: InputDecoration(suffixIcon: const Icon(Icons.visibility_outlined, size: 18), fillColor: bgColor, filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none))),
                  const SizedBox(height: 16),
                  const Text('WEBHOOK SECRET', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(readOnly: true, controller: TextEditingController(text: 'whsec_839210_api_prod'), decoration: InputDecoration(suffixIcon: const Icon(Icons.content_copy, size: 18, color: primaryColor), fillColor: bgColor, filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none))),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Sync Settings
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [Icon(Icons.schedule, color: primaryColor, size: 18), SizedBox(width: 8), Text('Sync Configuration', style: TextStyle(fontWeight: FontWeight.bold))]),
                  const SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Auto-sync Data', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), Text('Pull updates automatically', style: TextStyle(color: Colors.grey, fontSize: 11))]), Switch(value: autoSync, onChanged: (v) => setState(() => autoSync = v), activeThumbColor: primaryColor)]),
                  const Divider(height: 32),
                  const Text('SYNC FREQUENCY', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: syncFreq,
                    decoration: InputDecoration(fillColor: bgColor, filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
                    items: ['Every 5 minutes', 'Every 15 minutes', 'Every 30 minutes', 'Hourly'].map((f) => DropdownMenuItem(value: f, child: Text(f, style: const TextStyle(fontSize: 13)))).toList(),
                    onChanged: (v) => setState(() => syncFreq = v!),
                  ),
                  const SizedBox(height: 16),
                  Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.05), border: Border.all(color: primaryColor.withValues(alpha: 0.1)), borderRadius: BorderRadius.circular(8)), child: const Text('Next sync scheduled for 14:30 GMT. Estimated data payload: 2.4 MB.', style: TextStyle(color: primaryColor, fontSize: 11))),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Health Status
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.2,
              children: [
                _buildHealthItem('UPTIME', '99.9%'),
                _buildHealthItem('LATENCY', '124ms'),
                _buildHealthItem('LIMITS', '12k / 50k'),
                _buildHealthItem('ERRORS', '0'),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 0),
    );
  }

  Widget _buildTab(String label, bool isActive, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(right: 24),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isActive ? primaryColor : Colors.transparent, width: 2))),
      child: Text(label, style: TextStyle(color: isActive ? primaryColor : Colors.grey, fontSize: 13, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
    );
  }

  Widget _buildInfoTile(String label, String val) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold)),
            Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthItem(String label, String val) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
          Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
