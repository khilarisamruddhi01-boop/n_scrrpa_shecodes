import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class AuditLogsS42Screen extends StatefulWidget {
  const AuditLogsS42Screen({super.key});

  @override
  State<AuditLogsS42Screen> createState() => _AuditLogsS42ScreenState();
}

class _AuditLogsS42ScreenState extends State<AuditLogsS42Screen> {
  String actionType = 'All Actions';
  String dateRange = 'Last 24 Hours';
  String severity = 'All';

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        leading: const Icon(Icons.shield_outlined, color: primaryColor),
        title: RichText(text: const TextSpan(style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), children: [TextSpan(text: 'Audit Logs '), TextSpan(text: 'S42', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal))])),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.download, size: 16), label: const Text('Export'), style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Filter Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SEARCH ACTIONS', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 8),
                  TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search, size: 18), hintText: 'User ID, Action, or IP...', hintStyle: const TextStyle(fontSize: 13), fillColor: bgColor, filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none))),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('ACTION TYPE', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
                            DropdownButton<String>(value: actionType, isExpanded: true, items: ['All Actions', 'Login/Logout', 'Security Config'].map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(fontSize: 12)))).toList(), onChanged: (v) => setState(() => actionType = v!)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('DATE RANGE', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
                            DropdownButton<String>(value: dateRange, isExpanded: true, items: ['Last 24 Hours', 'Last 7 Days', 'Last 30 Days'].map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(fontSize: 12)))).toList(), onChanged: (v) => setState(() => dateRange = v!)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('SEVERITY', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSevBtn('All', severity == 'All'),
                      const SizedBox(width: 8),
                      _buildSevBtn('High', severity == 'High'),
                      const SizedBox(width: 8),
                      _buildSevBtn('Med', severity == 'Med'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Logs List (Optimized for Mobile)
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
              child: Column(
                children: [
                  _buildAuditRow('2023-10-24 14:22:01', 'admin_jane', 'Security Update', '192.168.1.142', 'Success', Colors.green),
                  _buildAuditRow('2023-10-24 13:45:12', 'sys_robot_04', 'Failed Login', '45.22.190.11', 'Blocked', Colors.red, isAlert: true),
                  _buildAuditRow('2023-10-24 12:10:55', 'mark_admin_99', 'User Delete', '10.0.4.52', 'Success', Colors.green),
                  _buildAuditRow('2023-10-24 10:05:30', 'sarah_ops', 'Export Logs', '172.16.254.1', 'Success', Colors.green),
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey.shade50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('1 to 4 of 1,248 entries', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        Row(
                          children: [
                            Icon(Icons.chevron_left, color: Colors.grey.shade400, size: 18),
                            const SizedBox(width: 8),
                            Container(width: 24, height: 24, decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(4)), child: const Center(child: Text('1', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)))),
                            const SizedBox(width: 8),
                            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 18),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Entry Details
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), color: primaryColor.withValues(alpha: 0.05), child: const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Entry Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), Text('#LOG-88421', style: TextStyle(color: Colors.grey, fontSize: 10, fontFamily: 'monospace'))])),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('FULL ACTION METADATA', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)), child: const Text('{\n  "action": "SECURITY_CONFIG_UPDATE",\n  "resource": "/api/v1/auth/settings",\n  "old_value": "mfa_required: false",\n  "new_value": "mfa_required: true"\n}', style: TextStyle(fontFamily: 'monospace', fontSize: 10, height: 1.5))),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('LOCATION', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)), SizedBox(height: 4), Row(children: [Icon(Icons.location_on, size: 12, color: primaryColor), SizedBox(width: 4), Text('San Francisco, US', style: TextStyle(fontSize: 12))])])),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('ORG UNIT', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)), SizedBox(height: 4), Row(children: [Icon(Icons.corporate_fare_outlined, size: 12, color: primaryColor), SizedBox(width: 4), Text('IT Security', style: TextStyle(fontSize: 12))])])),
                          ],
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(foregroundColor: Colors.black87, minimumSize: const Size(double.infinity, 44), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), side: const BorderSide(color: Colors.black12)), child: const Text('Flag for Review')),
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
      bottomNavigationBar: const AdminBottomNav(currentIndex: 3),
    );
  }

  Widget _buildSevBtn(String label, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => severity = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(color: isSelected ? const Color(0xFFEC5B13).withValues(alpha: 0.1) : Colors.grey.shade100, borderRadius: BorderRadius.circular(8), border: Border.all(color: isSelected ? const Color(0xFFEC5B13).withValues(alpha: 0.2) : Colors.transparent)),
          child: Center(child: Text(label, style: TextStyle(color: isSelected ? const Color(0xFFEC5B13) : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }

  Widget _buildAuditRow(String time, String user, String action, String ip, String status, Color statusColor, {bool isAlert = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: isAlert ? Colors.red.withValues(alpha: 0.05) : Colors.transparent, border: Border(bottom: BorderSide(color: Colors.black.withValues(alpha: 0.05)))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(time, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)), child: Text(action.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 8, fontWeight: FontWeight.w900))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(user, style: const TextStyle(fontSize: 13, color: Colors.black87)), Text(ip, style: const TextStyle(fontSize: 10, color: Colors.grey, fontFamily: 'monospace'))]),
              Row(
                children: [
                  Container(width: 6, height: 6, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text(status, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                  const Text('View', style: TextStyle(color: Color(0xFFEC5B13), fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
