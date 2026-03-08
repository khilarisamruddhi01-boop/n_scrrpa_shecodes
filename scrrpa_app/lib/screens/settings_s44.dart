import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class SettingsS44Screen extends StatefulWidget {
  const SettingsS44Screen({super.key});

  @override
  State<SettingsS44Screen> createState() => _SettingsS44ScreenState();
}

class _SettingsS44ScreenState extends State<SettingsS44Screen> {
  String theme = 'System';
  String language = 'English (US)';
  bool pushAlerts = true;
  bool emailSummaries = false;
  double refreshRate = 5;
  String mapProvider = 'Vector Map';

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () {}),
        title: const Text('System Settings', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [IconButton(icon: const Icon(Icons.done_all, color: primaryColor), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Appearance
            _buildSectionHeader('Appearance'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: primaryColor.withValues(alpha: 0.1))),
                child: Row(
                  children: [
                    _buildThemeBtn('Light'),
                    _buildThemeBtn('Dark'),
                    _buildThemeBtn('System'),
                  ],
                ),
              ),
            ),

            // Localization
            const SizedBox(height: 24),
            _buildSectionHeader('Localization'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: primaryColor.withValues(alpha: 0.1))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(children: [Icon(Icons.language, color: Colors.black45, size: 20), SizedBox(width: 12), Text('App Language', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))]),
                    DropdownButton<String>(
                      value: language,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.expand_more, size: 18, color: primaryColor),
                      style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
                      items: ['English (US)', 'Español', 'Français', 'Deutsch'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                      onChanged: (v) => setState(() => language = v!),
                    ),
                  ],
                ),
              ),
            ),

            // Notifications
            const SizedBox(height: 24),
            _buildSectionHeader('Notifications'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildToggleTile(Icons.notifications_active_outlined, 'Push Alerts', 'Critical system updates', pushAlerts, (v) => setState(() => pushAlerts = v), primaryColor),
                  const SizedBox(height: 12),
                  _buildToggleTile(Icons.mail_outline, 'Email Summaries', 'Weekly usage reports', emailSummaries, (v) => setState(() => emailSummaries = v), primaryColor),
                ],
              ),
            ),

            // Data & Connectivity
            const SizedBox(height: 24),
            _buildSectionHeader('Data & Connectivity'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: primaryColor.withValues(alpha: 0.1))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Data Refresh Rate', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), Text('Every ${refreshRate.toInt()} mins', style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12))]),
                    SliderTheme(
                      data: SliderThemeData(trackHeight: 2, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8), activeTrackColor: primaryColor, inactiveTrackColor: primaryColor.withValues(alpha: 0.1), thumbColor: primaryColor),
                      child: Slider(value: refreshRate, min: 1, max: 60, onChanged: (v) => setState(() => refreshRate = v)),
                    ),
                    const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('1 min', style: TextStyle(color: Colors.grey, fontSize: 10)), Text('30 mins', style: TextStyle(color: Colors.grey, fontSize: 10)), Text('1 hour', style: TextStyle(color: Colors.grey, fontSize: 10))]),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider()),
                    const Text('Map Provider', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildMapProviderBtn('Vector Map', 'assets/map_vector.png', primaryColor),
                        const SizedBox(width: 12),
                        _buildMapProviderBtn('Satellite', 'assets/map_satellite.png', primaryColor),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const CustomerBottomNav(currentIndex: 4),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(alignment: Alignment.centerLeft, child: Padding(padding: const EdgeInsets.only(left: 20, bottom: 12, top: 4), child: Text(title.toUpperCase(), style: const TextStyle(color: Color(0xFFEC5B13), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2))));
  }

  Widget _buildThemeBtn(String label) {
    bool isSelected = theme == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => theme = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: isSelected ? const Color(0xFFEC5B13) : Colors.transparent, borderRadius: BorderRadius.circular(8)),
          child: Center(child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 13))),
        ),
      ),
    );
  }

  Widget _buildToggleTile(IconData icon, String title, String sub, bool val, Function(bool) onChanged, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: primaryColor.withValues(alpha: 0.1))),
      child: Row(
        children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), shape: BoxShape.circle), child: Icon(icon, color: primaryColor, size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 11))])),
          Switch(value: val, onChanged: onChanged, activeThumbColor: primaryColor),
        ],
      ),
    );
  }

  Widget _buildMapProviderBtn(String label, String asset, Color primaryColor) {
    bool isSelected = mapProvider == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => mapProvider = label),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: isSelected ? primaryColor.withValues(alpha: 0.05) : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isSelected ? primaryColor : Colors.black12, width: isSelected ? 2 : 1)),
          child: Column(
            children: [
              Container(height: 48, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}
