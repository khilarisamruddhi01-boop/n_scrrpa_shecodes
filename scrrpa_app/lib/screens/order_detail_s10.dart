import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class OrderDetailS10Screen extends StatelessWidget {
  const OrderDetailS10Screen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Order #ORD-88294', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(icon: const Icon(Icons.print_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Customer Card
            _buildCustomerCard(primaryColor),
            const SizedBox(height: 16),
            
            // Fulfillment Timeline
            _buildTimelineSection(primaryColor),
            const SizedBox(height: 16),
            
            // Product Breakdown
            _buildProductBreakdown(primaryColor),
            const SizedBox(height: 16),
            
            // Scheduling & Address
            Row(
              children: [
                Expanded(child: _buildDataCard('Scheduling Data', [
                  _buildDataRow(Icons.request_quote_outlined, 'Requested Delivery', 'Oct 14, 2023'),
                  _buildDataRow(Icons.schedule, 'Scheduled Delivery', 'Oct 15, 2023', isHighlighted: true),
                ], primaryColor)),
              ],
            ),
            const SizedBox(height: 16),
            _buildDataCard('Shipping Address', [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on, color: primaryColor, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bay Area Logistics Hub', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('452 Industrial Way, Dock 12\nSouth San Francisco, CA 94080', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ], primaryColor),
            const SizedBox(height: 16),
            
            // Action Bar
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text('Accept Order', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildSecondaryBtn('Modify Schedule', Icons.edit_calendar_outlined)),
                const SizedBox(width: 12),
                Expanded(child: _buildSecondaryBtn('Notes', Icons.sticky_note_2_outlined)),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const SupplierBottomNav(currentIndex: 1),
    );
  }

  Widget _buildCustomerCard(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: primaryColor.withValues(alpha: 0.1))),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), shape: BoxShape.circle, border: Border.all(color: primaryColor.withValues(alpha: 0.2), width: 2)),
                child: Icon(Icons.business, color: primaryColor),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  child: const Icon(Icons.verified, color: Colors.white, size: 12),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Stop B Organization', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text('Customer ID: #99284 • Tier 1 Partner', style: TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                  child: Text('98% RELIABILITY SCORE', style: TextStyle(color: primaryColor, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: primaryColor.withValues(alpha: 0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('FULFILLMENT LIFECYCLE', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 20),
          _buildTimelineStep('Order Received', 'Oct 12, 10:00 AM • Auto-logged', Icons.inventory_2_outlined, true, primaryColor),
          _buildTimelineStep('Confirmed & Validated', 'Oct 12, 02:15 PM • Approved', Icons.check_circle_outline, true, primaryColor),
          _buildTimelineStep('Scheduled for Production', 'Target: Oct 15 • Awaiting Batching', Icons.calendar_today_outlined, false, primaryColor, isCurrent: true),
          _buildTimelineStep('Dispatched', 'Estimated Delivery: Oct 16', Icons.local_shipping_outlined, false, Colors.grey, isLast: true),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(String title, String subtitle, IconData icon, bool isPast, Color color, {bool isCurrent = false, bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isPast ? color : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Icon(icon, color: isPast ? Colors.white : color, size: 16),
            ),
            if (!isLast) Container(width: 2, height: 40, color: isPast ? color : Colors.black12),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isCurrent ? color : (isPast ? Colors.black : Colors.grey))),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductBreakdown(Color primaryColor) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: primaryColor.withValues(alpha: 0.1))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Product Breakdown', style: TextStyle(fontWeight: FontWeight.bold)),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)), child: const Text('3 ITEMS TOTAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const Divider(height: 1),
          _buildProductItem('Heavy Duty Turbine Blade', 'SKU: TB-X900-M', '12 units', '\$4,200.00', primaryColor),
          _buildProductItem('Control Assembly V4', 'SKU: CTRL-ASSEM-V4', '2 units', '\$1,150.00', primaryColor),
          Container(
            padding: const EdgeInsets.all(16),
            color: primaryColor,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Order Value', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('\$5,350.00', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(String title, String sku, String qty, String price, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.precision_manufacturing_outlined, color: primaryColor)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(sku, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(qty, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Text(price, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataCard(String title, List<Widget> children, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: primaryColor.withValues(alpha: 0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDataRow(IconData icon, String label, String value, {bool isHighlighted = false}) {
    const primaryColor = Color(0xFFEC5B13);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: isHighlighted ? primaryColor : Colors.grey),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(fontSize: 13, color: isHighlighted ? primaryColor : Colors.black, fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isHighlighted ? primaryColor : Colors.black)),
        ],
      ),
    );
  }

  Widget _buildSecondaryBtn(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.black54),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }
}
