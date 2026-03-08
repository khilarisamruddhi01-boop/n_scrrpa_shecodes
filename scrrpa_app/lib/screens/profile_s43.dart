import 'package:flutter/material.dart';

class ProfileS43Screen extends StatefulWidget {
  const ProfileS43Screen({super.key});

  @override
  State<ProfileS43Screen> createState() => _ProfileS43ScreenState();
}

class _ProfileS43ScreenState extends State<ProfileS43Screen> {
  bool biometricEnabled = true;

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
        title: const Text('Profile Settings', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [IconButton(icon: const Icon(Icons.check, color: primaryColor), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Avatar Section
            Container(
              padding: const EdgeInsets.all(32),
              width: double.infinity,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)]),
                        child: CircleAvatar(radius: 56, backgroundColor: const Color(0x1AEC5B13), child: const Icon(Icons.person, size: 60, color: primaryColor)),
                      ),
                      Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: const Icon(Icons.photo_camera, color: Colors.white, size: 16))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Alex Harrison', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text('Product Designer at Acme Corp', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: primaryColor.withValues(alpha: 0.1), foregroundColor: primaryColor, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text('Change Avatar', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ),

            // Form Section
            _buildSectionHeader('PERSONAL INFORMATION'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildInput('Full Name', 'Alex Harrison'),
                  const SizedBox(height: 12),
                  _buildInput('Email Address', 'alex.h@example.com'),
                ],
              ),
            ),

            const SizedBox(height: 32),
            _buildSectionHeader('ORGANIZATION'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
                child: Row(
                  children: [
                    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0x1AEC5B13), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.corporate_fare, color: primaryColor, size: 20)),
                    const SizedBox(width: 12),
                    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Acme Corp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), Text('Admin Role • Engineering Team', style: TextStyle(color: Colors.grey, fontSize: 11))])),
                    const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
            _buildSectionHeader('SECURITY & PRIVACY'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    _buildSettingsRow(Icons.lock_outline, 'Change Password', hasArrow: true),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.fingerprint, color: Colors.grey, size: 20),
                          const SizedBox(width: 12),
                          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Biometric Login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), Text('Face ID or Fingerprint', style: TextStyle(color: Colors.grey, fontSize: 11))])),
                          Switch(value: biometricEnabled, onChanged: (v) => setState(() => biometricEnabled = v), activeThumbColor: primaryColor),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.phonelink_lock, color: Colors.grey, size: 20),
                          const SizedBox(width: 12),
                          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Two-Factor Auth', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), Text('Active via SMS', style: TextStyle(color: Colors.grey, fontSize: 11))])),
                          TextButton(onPressed: () {}, child: const Text('MANAGE', style: TextStyle(color: primaryColor, fontSize: 11, fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
            _buildSectionHeader('CONNECTED ACCOUNTS'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildAccountRow('Google', 'CONNECTED', isConnected: true),
                  const SizedBox(height: 8),
                  _buildAccountRow('GitHub', 'CONNECT', isConnected: false),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(24),
              child: Divider(),
            ),

            // Logout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.logout), label: const Text('Logout'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red.withValues(alpha: 0.05), foregroundColor: Colors.red, minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: BorderSide(color: Colors.red.withValues(alpha: 0.1)), elevation: 0)),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(alignment: Alignment.centerLeft, child: Padding(padding: const EdgeInsets.only(left: 16, bottom: 8), child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2))));
  }

  Widget _buildInput(String label, String initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(left: 4, bottom: 4), child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
        TextField(controller: TextEditingController(text: initialValue), decoration: InputDecoration(fillColor: Colors.white, filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14))),
      ],
    );
  }

  Widget _buildSettingsRow(IconData icon, String title, {bool hasArrow = false}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const Spacer(),
          if (hasArrow) const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  Widget _buildAccountRow(String name, String actionText, {required bool isConnected}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Row(
        children: [
          Container(width: 32, height: 32, decoration: const BoxDecoration(color: Color(0xFFF8F6F6), shape: BoxShape.circle), child: Center(child: Icon(name == 'Google' ? Icons.g_mobiledata : Icons.code, color: Colors.black54))),
          const SizedBox(width: 12),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const Spacer(),
          Text(actionText, style: TextStyle(color: isConnected ? Colors.grey : const Color(0xFFEC5B13), fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class ColorExt {
  static const Color orangeOpacity10 = Color(0x1AEC5B13);
}
