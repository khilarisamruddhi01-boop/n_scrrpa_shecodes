import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class CustomerOrdersS21Screen extends StatefulWidget {
  const CustomerOrdersS21Screen({super.key});

  @override
  State<CustomerOrdersS21Screen> createState() => _CustomerOrdersS21ScreenState();
}

class _CustomerOrdersS21ScreenState extends State<CustomerOrdersS21Screen> with SingleTickerProviderStateMixin {
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
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {},
        ),
        title: const Column(
          children: [
            Text('Orders', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Customer: Stop B Organization', style: TextStyle(color: Colors.grey, fontSize: 10)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.black87), onPressed: () {}),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: primaryColor,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(child: Text('Active', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
            Tab(child: Text('Completed', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
            Tab(child: Text('Cancelled', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveOrders(primaryColor),
          const Center(child: Text('Completed Orders')),
          const Center(child: Text('Cancelled Orders')),
        ],
      ),
      bottomNavigationBar: const CustomerBottomNav(currentIndex: 2),
    );
  }

  Widget _buildActiveOrders(Color primaryColor) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildProductionOrderCard(primaryColor),
        const SizedBox(height: 16),
        _buildPendingOrderCard(primaryColor),
        const SizedBox(height: 16),
        _buildDeliveredOrderCard(primaryColor),
      ],
    );
  }

  Widget _buildProductionOrderCard(Color primaryColor) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Stop A Factory', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Order #ORD-8829 • 5 Products', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                  child: Text('PRODUCTION', style: TextStyle(color: primaryColor, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildRow('Total Quantity', '1,200 units'),
                const SizedBox(height: 8),
                _buildRow('Estimated Arrival', 'Oct 24, 2023'),
                const SizedBox(height: 20),
                const Align(alignment: Alignment.centerLeft, child: Text('ORDER TIMELINE', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold))),
                const SizedBox(height: 16),
                _buildTimeline(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16))),
            child: SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade200, foregroundColor: Colors.black87, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text('View Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingOrderCard(Color primaryColor) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Stop A Factory', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Order #ORD-9104 • 2 Products', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
                  child: const Text('PENDING', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildRow('Total Quantity', '450 units'),
                const SizedBox(height: 8),
                _buildRow('Estimated Arrival', 'Nov 02, 2023'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16))),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text('View Details', style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade50, foregroundColor: Colors.red, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text('Cancel Order', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveredOrderCard(Color primaryColor) {
    return Opacity(
      opacity: 0.9,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Stop A Factory', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Order #ORD-7712 • 12 Products', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                    child: const Text('DELIVERED', style: TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildRow('Delivered On', 'Sep 15, 2023'),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16))),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text('Reorder', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  Widget _buildTimeline() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(left: 20, right: 20, top: 12, child: Container(height: 2, color: Colors.grey.shade200)),
        Positioned(left: 20, width: 90, top: 12, child: Container(height: 2, color: const Color(0xFFEC5B13))),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTimelineStep('Pending', true, true),
            _buildTimelineStep('Accepted', true, true),
            _buildTimelineStep('Production', true, false, isCurrent: true),
            _buildTimelineStep('Dispatched', false, false),
            _buildTimelineStep('Delivered', false, false),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineStep(String label, bool isDone, bool showCheck, {bool isCurrent = false}) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(color: isDone ? const Color(0xFFEC5B13) : Colors.grey.shade300, shape: BoxShape.circle, border: isCurrent ? Border.all(color: Colors.white, width: 4) : null, boxShadow: [if (isCurrent) BoxShadow(color: const Color(0xFFEC5B13).withValues(alpha: 0.3), blurRadius: 4)]),
            child: showCheck ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: isDone ? const Color(0xFFEC5B13) : Colors.grey, fontSize: 8, fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
