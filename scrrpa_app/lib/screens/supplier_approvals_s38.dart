import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class SupplierApprovalsS38Screen extends StatefulWidget {
  const SupplierApprovalsS38Screen({super.key});

  @override
  State<SupplierApprovalsS38Screen> createState() => _SupplierApprovalsS38ScreenState();
}

class _SupplierApprovalsS38ScreenState extends State<SupplierApprovalsS38Screen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Supplier Approvals', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: primaryColor), onPressed: () {}),
          IconButton(icon: const Icon(Icons.filter_list, color: primaryColor), onPressed: () {}),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: primaryColor,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'Pending (12)'),
            Tab(text: 'Approved'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildApprovalList(context, 'PENDING'),
          _buildApprovalList(context, 'APPROVED'),
          _buildApprovalList(context, 'REJECTED'),
        ],
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 2),
    );
  }

  Widget _buildApprovalList(BuildContext context, String filter) {
    const primaryColor = Color(0xFFEC5B13);
    
    // Simulate empty states for Approved/Rejected
    if (filter != 'PENDING') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fact_check_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('No $filter applications found', style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Risk assessment card
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: primaryColor.withValues(alpha: 0.1)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    width: 120,
                    padding: const EdgeInsets.all(20),
                    color: primaryColor.withValues(alpha: 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 60, height: 60, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: primaryColor, width: 3)), child: const Center(child: Text('85', style: TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold)))),
                        const SizedBox(height: 8),
                        const Text('LOW RISK', style: TextStyle(color: primaryColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Aggregate Risk Pre-assessment', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 4),
                          const Text('Based on global financial stability indices...', style: TextStyle(color: Colors.grey, fontSize: 10)),
                          const SizedBox(height: 12),
                          const Wrap(spacing: 4, runSpacing: 4, children: [_Badge(text: 'Financial: Stable', color: Colors.green), _Badge(text: 'ESG: Verified', color: Colors.green), _Badge(text: 'Logistics: Regional', color: Colors.orange)]),
                          const Spacer(),
                          Align(alignment: Alignment.centerRight, child: TextButton.icon(onPressed: () {}, icon: const Icon(Icons.open_in_new, size: 14, color: primaryColor), label: const Text('View Detailed Audit', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryColor)))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Supplier application details
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.factory_outlined, color: primaryColor)),
                        const SizedBox(width: 12),
                        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Global Logistics Corp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text('Applied: Oct 24, 2023 • ID: SUP-9921', style: TextStyle(color: Colors.grey, fontSize: 10))]),
                      ],
                    ),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)), child: const Text('PRIORITY', style: TextStyle(color: primaryColor, fontSize: 8, fontWeight: FontWeight.bold))),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider()),
                const Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('LOCATION', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)), Text('Rotterdam, Netherlands', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))])), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('CATEGORY', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)), Text('Sea Freight & Storage', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))]))]),
                const SizedBox(height: 16),
                const Text('SUMMARY', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Seeking approval for Tier-2 international logistics services. Includes temperature-controlled storage and hazardous material handling certifications.', style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.5)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.check_circle_outline, size: 18), label: const Text('Approve'), style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, minimumSize: const Size(0, 44), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))))),
                    const SizedBox(width: 8),
                    Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.info_outline, size: 18), label: const Text('Req Info'), style: OutlinedButton.styleFrom(foregroundColor: Colors.black87, side: const BorderSide(color: Colors.black12), minimumSize: const Size(0, 44), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))))),
                    const SizedBox(width: 8),
                    Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.cancel_outlined, size: 18), label: const Text('Reject'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade50, foregroundColor: Colors.red, minimumSize: const Size(0, 44), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Certifications
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [Icon(Icons.description_outlined, color: primaryColor, size: 20), SizedBox(width: 8), Text('Submitted Certifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))]),
                const SizedBox(height: 16),
                _buildCertItem('ISO 9001:2015 Certification', 'PDF • 2.4 MB • Updated Oct 2023', Icons.picture_as_pdf, primaryColor, isSelected: true),
                _buildCertItem('Hazardous Materials Permit', 'PDF • 1.1 MB • Valid until 2025', Icons.verified_user_outlined, Colors.grey),
                _buildCertItem('Financial Stability Audit', 'PDF • 4.8 MB • Q3 2023 Report', Icons.article_outlined, Colors.grey),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Doc Preview (Simplified for Mobile view)
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), color: Colors.grey.shade50, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Row(children: [Icon(Icons.preview_outlined, color: primaryColor, size: 18), SizedBox(width: 8), Text('ISO 9001:2015 - Preview', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))]), Row(children: [IconButton(onPressed: () {}, icon: const Icon(Icons.zoom_in, size: 18, color: Colors.grey)), IconButton(onPressed: () {}, icon: const Icon(Icons.download, size: 18, color: Colors.grey))])])),
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Container(width: 40, height: 4, color: Colors.grey.shade100), Container(width: 32, height: 32, decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), shape: BoxShape.circle), child: const Icon(Icons.shield, color: primaryColor, size: 16))]),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),
                        Container(width: double.infinity, height: 2, color: Colors.grey.shade100),
                        const SizedBox(height: 4),
                        Align(alignment: Alignment.centerLeft, child: FractionallySizedBox(widthFactor: 0.8, child: Container(height: 2, color: Colors.grey.shade100))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // More applications
          const Align(alignment: Alignment.centerLeft, child: Text('Other Pending Applications (11)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          const SizedBox(height: 12),
          _buildSmallApp('Rapid Delivery Hub', 'Tier 3 • Express Cargo', Icons.local_shipping_outlined, primaryColor),
          _buildSmallApp('TechComponents Inc', 'Tier 1 • Hardware Parts', Icons.precision_manufacturing_outlined, primaryColor),
          const SizedBox(height: 100),
        ],
      ),
    );
  }


  Widget _buildCertItem(String title, String meta, IconData icon, Color iconColor, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: isSelected ? const Color(0xFFEC5B13).withValues(alpha: 0.05) : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isSelected ? const Color(0xFFEC5B13).withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.05))),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), Text(meta, style: const TextStyle(color: Colors.grey, fontSize: 10))])),
          const Icon(Icons.visibility_outlined, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSmallApp(String name, String sub, IconData icon, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Row(
        children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: primaryColor, size: 18)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 10))])),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge({required this.text, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)), child: Text(text, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)));
  }
}
