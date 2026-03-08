import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class SupplierReportsS16Screen extends StatefulWidget {
  const SupplierReportsS16Screen({super.key});

  @override
  State<SupplierReportsS16Screen> createState() => _SupplierReportsS16ScreenState();
}

class _SupplierReportsS16ScreenState extends State<SupplierReportsS16Screen> {
  String _selectedFormat = 'PDF';
  String _selectedType = 'Shipment';

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Supplier Reports', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create New Report', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            // Report Type Cards
            _buildReportTypeCard('Shipment Report', 'Track logistics performance and delivery timelines.', Icons.local_shipping_outlined, 'Shipment', primaryColor),
            const SizedBox(height: 12),
            _buildReportTypeCard('Customer Report', 'Analyze client orders and engagement metrics.', Icons.group_outlined, 'Customer', primaryColor),
            const SizedBox(height: 12),
            _buildReportTypeCard('Risk Analysis', 'Evaluate supply chain vulnerabilities and health.', Icons.warning_amber_outlined, 'Risk', primaryColor),
            const SizedBox(height: 24),

            const Text('Export Format', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildFormatBtn('PDF', 'PDF Document', Icons.picture_as_pdf_outlined, primaryColor)),
                const SizedBox(width: 12),
                Expanded(child: _buildFormatBtn('Excel', 'Excel Sheet', Icons.table_view_outlined, primaryColor)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Generate Selected Report', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Reports', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 12),
            _buildHistoryItem('Q3_Shipment_Logistics.pdf', 'Generated Oct 24, 2023 • 2.4 MB', Icons.description_outlined, primaryColor),
            const SizedBox(height: 12),
            _buildHistoryItem('Annual_Risk_Audit_2023.xlsx', 'Generated Oct 21, 2023 • 1.1 MB', Icons.table_chart_outlined, primaryColor),
            const SizedBox(height: 12),
            _buildHistoryItem('Top_Customers_Summary.pdf', 'Generated Oct 18, 2023 • 850 KB', Icons.description_outlined, primaryColor),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const SupplierBottomNav(currentIndex: 0),
    );
  }

  Widget _buildReportTypeCard(String title, String desc, IconData icon, String type, Color primaryColor) {
    bool isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? primaryColor : Colors.black.withValues(alpha: 0.05), width: isSelected ? 2 : 1),
          boxShadow: [if (isSelected) BoxShadow(color: primaryColor.withValues(alpha: 0.1), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: isSelected ? primaryColor : primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: isSelected ? Colors.white : primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatBtn(String format, String label, IconData icon, Color primaryColor) {
    bool isSelected = _selectedFormat == format;
    return GestureDetector(
      onTap: () => setState(() => _selectedFormat = format),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? primaryColor : Colors.black12, width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? primaryColor : Colors.grey),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: isSelected ? primaryColor : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String name, String meta, IconData icon, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Row(
        children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle), child: Icon(icon, color: Colors.grey, size: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(meta, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(Icons.download, color: primaryColor, size: 18),
          ),
        ],
      ),
    );
  }
}
