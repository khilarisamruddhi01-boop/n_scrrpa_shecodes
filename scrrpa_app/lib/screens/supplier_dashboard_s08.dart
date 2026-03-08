import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class SupplierDashboardS08Screen extends StatelessWidget {
  const SupplierDashboardS08Screen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const navyDeep = Color(0xFF1E3A5F);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: navyDeep,
        elevation: 4,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.storefront, color: Colors.white, size: 20),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            Text('N-SCRRA Supplier Portal', style: TextStyle(color: Colors.white70, fontSize: 10)),
          ],
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_none, color: Colors.white),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: navyDeep, width: 1.5)),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alerts Banner
            SizedBox(
              height: 32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildAlertChip(Icons.error_outline, 'Stock Critical: SKU-902', Colors.red),
                  const SizedBox(width: 8),
                  _buildAlertChip(Icons.warning_amber_rounded, 'Port Congestion: Lagos', Colors.amber),
                  const SizedBox(width: 8),
                  _buildAlertChip(Icons.info_outline, 'Policy Update 2024', Colors.blue),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Stats Cards
            Row(
              children: [
                Expanded(child: _buildStatCard('TOTAL ORDERS', '1,284', Icons.shopping_cart_outlined, badges: ['8 PENDING', '42 ACCEPTED'])),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildStatCard('ACTIVE SHIPMENTS', '42', Icons.local_shipping_outlined, subtext: 'Avg ETA: 2.4 days')),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('MONTHLY REVENUE', '₦4.2M', Icons.payments_outlined, trend: '+5.8%')),
              ],
            ),
            const SizedBox(height: 24),

            // Risk Exposure Gauges
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: navyDeep,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: navyDeep.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('RISK EXPOSURE INDEX', style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                        const SizedBox(height: 16),
                        const Text('MEDIUM', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                        const Text('54/100', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/supplier_analytics_s23'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.1),
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white24),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          child: const Text('VIEW ANALYSIS'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(value: 0.54, strokeWidth: 8, backgroundColor: Colors.white10, color: Colors.amber.shade600),
                        const Icon(Icons.shield_outlined, color: Colors.amber, size: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Performance Chart Area
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('DELIVERY PERFORMANCE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      Icon(Icons.more_horiz, color: Colors.grey, size: 18),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBar(0.8, 'JAN'),
                        _buildBar(0.9, 'FEB'),
                        _buildBar(0.7, 'MAR'),
                        _buildBar(0.85, 'APR'),
                        _buildBar(0.95, 'MAY'),
                        _buildBar(0.88, 'JUN'),
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
      bottomNavigationBar: const SupplierBottomNav(currentIndex: 0),
    );
  }

  Widget _buildAlertChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, {String? subtext, List<String>? badges, String? trend}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
              Icon(icon, color: const Color(0xFFEC5B13), size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          if (subtext != null) Text(subtext, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          if (trend != null) Text(trend, style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
          if (badges != null) ...[
            const SizedBox(height: 8),
            Row(
              children: badges.map((b) => Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                  child: Text(b, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey)),
                ),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBar(double factor, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 20,
          height: 100 * factor,
          decoration: const BoxDecoration(color: Color(0xFFEC5B13), borderRadius: BorderRadius.vertical(top: Radius.circular(4))),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold)),
      ],
    );
  }

}
