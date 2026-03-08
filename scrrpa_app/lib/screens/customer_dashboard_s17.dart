import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class CustomerDashboardS17Screen extends StatelessWidget {
  const CustomerDashboardS17Screen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1E3A5F); // Navy blue
    const secondaryColor = Color(0xFF2E7D32); // Green
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 4,
        leading: const Icon(Icons.menu, color: Colors.white),
        title: const Text('N-SCRRA | Stop B', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.notifications_outlined, color: Colors.white),
              Positioned(
                top: 12,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                  child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alerts
            const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red),
                SizedBox(width: 8),
                Text('Critical Disruption Alerts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            _buildAlertItem('Severe Weather - Route A4', 'Port of Singapore delayed by 48 hours', Icons.thunderstorm_outlined, Colors.red, 'CRITICAL'),
            const SizedBox(height: 8),
            _buildAlertItem('Labor Strike Risk - Supplier Stop A', 'Expected negotiations in 3 days', Icons.local_shipping_outlined, Colors.orange, 'HIGH'),
            const SizedBox(height: 24),

            // Health & Shipments Row
            Row(
              children: [
                Expanded(flex: 1, child: _buildHealthGauge(secondaryColor)),
              ],
            ),
            const SizedBox(height: 16),
            _buildActiveShipments(secondaryColor),
            const SizedBox(height: 24),

            // Risk Monitoring
            const Text('Supplier Risk Monitoring', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildRiskCard('Supplier: Stop A', '12', 'Geopolitical', Colors.green),
                  _buildRiskCard('Global Logistics Corp', '45', 'Financial', Colors.orange),
                  _buildRiskCard('Prime Parts Inc.', '08', 'Operational', Colors.green),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Upcoming Deliveries
            const Text('Upcoming Deliveries (Next 7 Days)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            _buildTimeline(primaryColor, secondaryColor),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/place_order_s20'),
        backgroundColor: secondaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: const CustomerBottomNav(currentIndex: 0),
    );
  }

  Widget _buildAlertItem(String title, String desc, IconData icon, Color color, String tag) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8), border: Border(left: BorderSide(color: color, width: 4))),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color.withValues(alpha: 0.9), fontSize: 13)),
                Text(desc, style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
            child: Text(tag, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthGauge(Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        children: [
          const Text('Overall Supply Health', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12)),
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(width: 120, height: 120, child: CircularProgressIndicator(value: 0.88, strokeWidth: 10, backgroundColor: Colors.grey.shade100, color: color)),
              const Column(
                children: [
                  Text('88', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  Text('/100', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.trending_up, size: 16, color: color),
              const SizedBox(width: 4),
              Text('+2.4% from last month', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveShipments(Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Active In-Transit Shipments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('View All', style: TextStyle(color: Color(0xFF1E3A5F), fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          _buildShipmentRow('SHIP-9842 (Electronics)', 'ETA: 4h 20m', 'Arriving at Dock 12', 0.85, color),
          const SizedBox(height: 16),
          _buildShipmentRow('SHIP-9845 (Raw Metals)', 'ETA: 1d 14h', 'In Transit - Mid-Atlantic', 0.45, color),
          const SizedBox(height: 16),
          _buildShipmentRow('SHIP-9850 (Components)', 'ETA: Delayed (+12h)', 'Customs Clearance', 0.92, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildShipmentRow(String name, String eta, String location, double progress, Color barColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                Text(eta, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: barColor == Colors.orange ? Colors.orange.shade700 : Colors.black)),
              ],
            ),
            Text(location, style: const TextStyle(color: Colors.grey, fontSize: 10)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.shade100, color: barColor, minHeight: 6, borderRadius: BorderRadius.circular(3)),
      ],
    );
  }

  Widget _buildRiskCard(String supplier, String score, String type, Color color) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.factory_outlined, size: 16, color: Color(0xFF1E3A5F))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('RISK SCORE', style: TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
                  Text(score, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const Spacer(),
          Text(supplier, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)), child: Text(type, style: const TextStyle(color: Colors.grey, fontSize: 9))),
              const SizedBox(width: 8),
              Icon(Icons.trending_down, size: 14, color: color),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(Color primary, Color secondary) {
    return Column(
      children: [
        _buildTimelineItem('Today', 'SHIP-9842 Arriving', 'Expected: 14:00 (Today)', secondary, true),
        _buildTimelineItem('OCT 24', 'SHIP-9845 - Mid-Route', 'ETA: Thursday Morning', primary, false),
        _buildTimelineItem('OCT 26', 'SHIP-9860 - Bulk Order', 'ETA: Saturday Afternoon', Colors.grey, false, isLast: true),
      ],
    );
  }

  Widget _buildTimelineItem(String date, String title, String meta, Color color, bool isCurrent, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
              child: Center(child: Text(date.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
            ),
            if (!isLast) Container(width: 2, height: 50, color: Colors.black12),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              Opacity(
                opacity: isLast ? 0.6 : 1.0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(meta, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
