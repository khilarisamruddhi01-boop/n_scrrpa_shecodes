import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class SupplierOrdersS09Screen extends StatefulWidget {
  const SupplierOrdersS09Screen({super.key});

  @override
  State<SupplierOrdersS09Screen> createState() => _SupplierOrdersS09ScreenState();
}

class _SupplierOrdersS09ScreenState extends State<SupplierOrdersS09Screen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
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
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        toolbarHeight: 0, // Hidden appbar, hand-crafted header
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(180),
          child: Column(
            children: [
              // Custom Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.factory_outlined, color: primaryColor),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('N-SCRRA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                        Text('STOP A: SUPPLY FLOW', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Spacer(),
                    _buildCircButton(Icons.notifications_outlined),
                    const SizedBox(width: 8),
                    _buildCircButton(Icons.person_outline),
                  ],
                ),
              ),
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                  child: const TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: Colors.grey, size: 20),
                      hintText: 'Search orders, customers...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
              // Tab Bar
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: primaryColor,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Pending'),
                  Tab(text: 'Accepted'),
                  Tab(text: 'In-Production'),
                  Tab(text: 'Dispatched'),
                  Tab(text: 'Completed'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Sorting Chips
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildSortChip('Newest First', true),
                const SizedBox(width: 8),
                _buildSortChip('Priority: High', false),
                const SizedBox(width: 8),
                _buildSortChip('Order Type', false),
              ],
            ),
          ),
          // Order List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/order_detail_s10'),
                  child: _buildOrderCard(
                    'Altra Global Logistics',
                    'ORD-88291',
                    'Oct 24, 2023',
                    'Steel Rods (Batch A)',
                    '250 units',
                    'PENDING',
                    '\$12,450.00',
                    Colors.amber,
                    hasActions: true,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/order_detail_s10'),
                  child: _buildOrderCard(
                    'Metro Infrastructure',
                    'ORD-88285',
                    'Oct 23, 2023',
                    'Composite Panels',
                    '1,200 units',
                    'IN-PRODUCTION',
                    '\$45,200.00',
                    Colors.blue,
                    progress: 0.65,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/order_detail_s10'),
                  child: _buildOrderCard(
                    'Apex Energy Solutions',
                    'ORD-88270',
                    'Oct 22, 2023',
                    'Copper Wiring Kit',
                    '50 units',
                    'ACCEPTED',
                    '\$3,890.00',
                    Colors.green,
                    isSimpleAction: true,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/order_detail_s10'),
                  child: _buildOrderCard(
                    'Oceanic Refineries',
                    'ORD-88255',
                    'Oct 20, 2023',
                    'Valves & Fittings',
                    '450 units',
                    'DISPATCHED',
                    '\$8,120.00',
                    Colors.indigo,
                    opacity: 0.7,
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SupplierBottomNav(currentIndex: 1),
    );
  }

  Widget _buildCircButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.black54, size: 20),
    );
  }

  Widget _buildSortChip(String label, bool isSelected) {
    const primaryColor = Color(0xFFEC5B13);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor.withValues(alpha: 0.1) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: isSelected ? Border.all(color: primaryColor.withValues(alpha: 0.2)) : null,
      ),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? primaryColor : Colors.black54)),
          const SizedBox(width: 4),
          Icon(isSelected ? Icons.keyboard_arrow_down : Icons.filter_list, size: 14, color: isSelected ? primaryColor : Colors.black54),
        ],
      ),
    );
  }

  Widget _buildOrderCard(
    String client,
    String id,
    String date,
    String product,
    String qty,
    String status,
    String price,
    Color statusColor, {
    bool hasActions = false,
    double? progress,
    bool isSimpleAction = false,
    double opacity = 1.0,
  }) {
    return Opacity(
      opacity: opacity,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.inventory_2_outlined, color: Colors.black26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(client, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Order #$id • $date', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: product, style: const TextStyle(color: Color(0xFFEC5B13), fontSize: 14, fontWeight: FontWeight.bold)),
                              TextSpan(text: ' • $qty', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                        child: Text(status, style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            if (progress != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.shade100, color: Colors.blue, minHeight: 6, borderRadius: BorderRadius.circular(3)),
                    const SizedBox(height: 4),
                    Text('Manufacturing phase: ${(progress * 100).toInt()}% complete', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              ),
            if (hasActions)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: const BoxDecoration(color: Color(0xFFEC5B13), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16))),
                      child: const Center(child: Text('Accept', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16))),
                      child: const Center(child: Text('Reject', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold))),
                    ),
                  ),
                ],
              ),
            if (isSimpleAction)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    _buildMiniBtn('View Details', const Color(0xFFEC5B13), true),
                    const SizedBox(width: 8),
                    _buildMiniBtn('Update Logistics', Colors.black54, false),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniBtn(String label, Color color, bool isPrimary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isPrimary ? color.withValues(alpha: 0.05) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

}
