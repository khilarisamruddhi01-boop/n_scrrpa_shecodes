import 'package:flutter/material.dart';

class ReportGeneratorS34Screen extends StatefulWidget {
  const ReportGeneratorS34Screen({super.key});

  @override
  State<ReportGeneratorS34Screen> createState() => _ReportGeneratorS34ScreenState();
}

class _ReportGeneratorS34ScreenState extends State<ReportGeneratorS34Screen> {
  String selectedType = 'Disruption Analysis';
  String selectedFormat = 'PDF';

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
        title: const Text('Report Generator', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Configuration Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [Icon(Icons.settings_suggest, color: primaryColor, size: 20), SizedBox(width: 8), Text('Report Configuration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
                  const SizedBox(height: 24),
                  const Text('Report Type', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: selectedType,
                    decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 16), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12))),
                    items: ['Disruption Analysis', 'Risk Assessment', 'Supplier Performance', 'Sector Insights'].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 14)))).toList(),
                    onChanged: (v) => setState(() => selectedType = v!),
                  ),
                  const SizedBox(height: 24),
                  const Text('Export Format', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildFormatBtn('PDF', Icons.picture_as_pdf, Colors.red, selectedFormat == 'PDF', primaryColor),
                      const SizedBox(width: 12),
                      _buildFormatBtn('Excel', Icons.table_chart, Colors.green, selectedFormat == 'Excel', primaryColor),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Date Range', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 8),
                  _buildCalendar(primaryColor),
                  const SizedBox(height: 24),
                  const Text('Entity Scope', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildScopeChip('All Suppliers', primaryColor),
                      _buildScopeChip('Tech Sector', primaryColor),
                      ActionChip(onPressed: () {}, label: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.add, size: 14), const Text(' Add Scope', style: TextStyle(fontSize: 12))]), backgroundColor: Colors.grey.shade100, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.analytics_outlined),
                    label: const Text('Generate Report', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 4, shadowColor: primaryColor.withValues(alpha: 0.4)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // History Section
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Generation History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)))]),
            const SizedBox(height: 12),
            _buildHistoryItem('Risk_Assessment_Q3_2023.pdf', 'Generated 2 hours ago • 4.2 MB', Icons.picture_as_pdf, Colors.red, primaryColor),
            _buildHistoryItem('Disruption_Trends_Global.xlsx', 'Generated yesterday • 1.8 MB', Icons.table_chart, Colors.green, primaryColor),
            _buildHistoryItem('Supplier_Audit_August.pdf', 'Generated Oct 12, 2023 • 3.5 MB', Icons.picture_as_pdf, Colors.red, primaryColor, isOld: true),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildFormatBtn(String label, IconData icon, Color color, bool isSelected, Color primaryColor) {
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => selectedFormat = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: isSelected ? primaryColor.withValues(alpha: 0.05) : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isSelected ? primaryColor : Colors.black.withValues(alpha: 0.1))),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: color, size: 20), const SizedBox(width: 8), Text(label, style: const TextStyle(fontWeight: FontWeight.bold))]),
        ),
      ),
    );
  }

  Widget _buildCalendar(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_left)), const Text('October 2023', style: TextStyle(fontWeight: FontWeight.bold)), IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_right))]),
          const SizedBox(height: 16),
          _buildCalendarGrid(primaryColor),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(Color primaryColor) {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: days.map((d) => Text(d, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold))).toList()),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1),
          itemCount: 35,
          itemBuilder: (context, index) {
            int day = index - 3;
            if (day < 1 || day > 31) return const SizedBox();
            bool isStart = day == 5;
            bool isEnd = day == 16;
            bool inRange = day > 5 && day < 16;
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: inRange ? primaryColor.withValues(alpha: 0.2) : (isStart || isEnd ? primaryColor : null),
                borderRadius: isStart ? const BorderRadius.horizontal(left: Radius.circular(20)) : (isEnd ? const BorderRadius.horizontal(right: Radius.circular(20)) : null),
              ),
              child: Center(child: Text('$day', style: TextStyle(fontSize: 12, color: (isStart || isEnd) ? Colors.white : (inRange ? Colors.black : (day < 5 ? Colors.grey.shade300 : Colors.black))))),
            );
          },
        ),
      ],
    );
  }

  Widget _buildScopeChip(String label, Color primaryColor) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      backgroundColor: primaryColor.withValues(alpha: 0.1),
      labelStyle: TextStyle(color: primaryColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: primaryColor.withValues(alpha: 0.2))),
      deleteIcon: Icon(Icons.close, size: 14, color: primaryColor),
      onDeleted: () {},
    );
  }

  Widget _buildHistoryItem(String name, String meta, IconData icon, Color iconColor, Color primaryColor, {bool isOld = false}) {
    return Opacity(
      opacity: isOld ? 0.7 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
        child: Row(
          children: [
            Container(width: 48, height: 48, decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: iconColor)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis), Text(meta, style: const TextStyle(color: Colors.grey, fontSize: 11))])),
            const SizedBox(width: 8),
            IconButton(onPressed: () {}, icon: const Icon(Icons.download, size: 20, color: Colors.grey)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.share, size: 20, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
