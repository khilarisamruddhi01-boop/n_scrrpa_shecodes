import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class SupplierAnalyticsS23Screen extends StatefulWidget {
  const SupplierAnalyticsS23Screen({super.key});

  @override
  State<SupplierAnalyticsS23Screen> createState() => _SupplierAnalyticsS23ScreenState();
}

class _SupplierAnalyticsS23ScreenState extends State<SupplierAnalyticsS23Screen> {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1E3A5F);
    const secondaryColor = Color(0xFF2E7D32);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Supplier Analytics', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
            child: const Row(
              children: [
                Text('Global Logistics Inc.', style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
                Icon(Icons.expand_more, color: Colors.black54, size: 18),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.notifications_none, color: primaryColor), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Context
            const Text('Performance Analysis for Stop A', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const Text('Supplier: Global Logistics Inc.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildFilterBtn('Last 12 Months', Icons.calendar_today_outlined),
                const SizedBox(width: 8),
                _buildActionBtn('Export Report', Icons.download_outlined, primaryColor),
              ],
            ),
            const SizedBox(height: 24),

            // Metrics Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _buildMetricCard('Avg Lead Time', '4.2 Days', '-0.5d', Colors.red, 'Target: 3.5 Days'),
                _buildMetricCard('On-Time Rate %', '92.5%', '+2.1%', secondaryColor, 'Benchmark: 88.0%'),
                _buildMetricCard('Total Orders', '1,240', '+12%', secondaryColor, 'Year to Date'),
                _buildMetricCard('Risk Score', 'Low', 'Stable', Colors.amber, 'Current events'),
              ],
            ),
            const SizedBox(height: 24),

            // Charts
            _buildChartCard('Reliability Score Trend', '88/100', const ReliabilityTrendPainter(), primaryColor),
            const SizedBox(height: 16),
            _buildDelayDistributionCard(secondaryColor),
            const SizedBox(height: 16),
            _buildComparisonCard(primaryColor, secondaryColor),
            const SizedBox(height: 16),
            _buildRiskTimeline(),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const SupplierBottomNav(currentIndex: 3),
    );
  }

  Widget _buildFilterBtn(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black12)),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.black54),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActionBtn(String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, String change, Color changeColor, String footer) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
              Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), decoration: BoxDecoration(color: changeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)), child: Text(change, style: TextStyle(color: changeColor, fontSize: 8, fontWeight: FontWeight.bold))),
            ],
          ),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(footer, style: const TextStyle(color: Colors.grey, fontSize: 9)),
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, String value, CustomPainter painter, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              RichText(text: TextSpan(children: [TextSpan(text: value.split('/')[0], style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)), TextSpan(text: '/${value.split('/')[1]}', style: const TextStyle(color: Colors.grey, fontSize: 12))])),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(height: 120, width: double.infinity, child: CustomPaint(painter: painter)),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('JAN', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
              Text('MAR', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
              Text('MAY', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
              Text('JUL', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
              Text('SEP', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
              Text('NOV', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDelayDistributionCard(Color secondaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Delivery Delay Distribution', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBar('On-Time', 0.85, secondaryColor),
              _buildBar('1 Day', 0.12, Colors.amber),
              _buildBar('2 Days', 0.08, Colors.orange),
              _buildBar('3+ Days', 0.04, Colors.red),
            ],
          ),
          const Divider(height: 32),
          const Center(child: Text('Most delays occur on Wednesdays due to customs backlog.', style: TextStyle(color: Colors.grey, fontSize: 10, fontStyle: FontStyle.italic))),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double heightFactor, Color color) {
    return Column(
      children: [
        Container(width: 40, height: 120 * heightFactor, decoration: BoxDecoration(color: color.withValues(alpha: 0.8), borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildComparisonCard(Color primaryColor, Color secondaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('On-Time Delivery: Top Supplier Comparison', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          _buildProgressRow('Global Logistics', 0.925, primaryColor),
          const SizedBox(height: 16),
          _buildProgressRow('SwiftShip Partners', 0.891, Colors.grey.shade300),
          const SizedBox(height: 16),
          _buildProgressRow('Oceanic Freight Ltd.', 0.845, Colors.grey.shade300),
          const SizedBox(height: 16),
          _buildProgressRow('Prime Express', 0.948, secondaryColor.withValues(alpha: 0.6)),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String label, double progress, Color color) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(fontSize: 12)), Text('${(progress * 100).toStringAsFixed(1)}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))]),
        const SizedBox(height: 6),
        LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.shade100, valueColor: AlwaysStoppedAnimation(color), minHeight: 8, borderRadius: BorderRadius.circular(4)),
      ],
    );
  }

  Widget _buildRiskTimeline() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Risk Events Timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 24),
          _buildTimelineItem('Oct 14, 2023', 'Port Strike - East Coast', 'Major delays across 12 shipments. Resolved after 4 days.', Colors.red),
          _buildTimelineItem('Aug 22, 2023', 'Severe Weather (Typhoon)', 'Vessel re-routing required. 2 shipments delayed by 48h.', Colors.amber),
          _buildTimelineItem('Jun 05, 2023', 'Customs Regulatory Update', 'Administrative delays due to new documentation requirements.', Colors.blue),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String date, String title, String desc, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: color.withValues(alpha: 0.2), width: 4))),
              Container(width: 2, height: 40, color: Colors.grey.shade100),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReliabilityTrendPainter extends CustomPainter {
  const ReliabilityTrendPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF1E3A5F)..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.cubicTo(size.width * 0.2, size.height * 0.6, size.width * 0.3, size.height * 0.8, size.width * 0.5, size.height * 0.5);
    path.cubicTo(size.width * 0.7, size.height * 0.2, size.width * 0.8, size.height * 0.4, size.width, size.height * 0.3);
    canvas.drawPath(path, paint);

    final fillPaint = Paint()..color = const Color(0xFF1E3A5F).withValues(alpha: 0.05)..style = PaintingStyle.fill;
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
