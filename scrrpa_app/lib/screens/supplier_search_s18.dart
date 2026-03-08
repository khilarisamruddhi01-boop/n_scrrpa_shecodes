import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class SupplierSearchS18Screen extends StatefulWidget {
  const SupplierSearchS18Screen({super.key});

  @override
  State<SupplierSearchS18Screen> createState() => _SupplierSearchS18ScreenState();
}

class _SupplierSearchS18ScreenState extends State<SupplierSearchS18Screen> {
  bool _isListView = true;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Supplier Search', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined, color: primaryColor), onPressed: () {}),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: primaryColor.withValues(alpha: 0.1),
              child: const Text('JD', style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by name, industry, or ID...',
                          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.tune, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Sector', true, primaryColor),
                      _buildFilterChip('Country', false, primaryColor),
                      _buildFilterChip('Risk Level', false, primaryColor),
                      _buildFilterChip('Rating', false, primaryColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: bgColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('142 Suppliers found', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        _buildToggleBtn(Icons.list, 'List', _isListView, primaryColor),
                        _buildToggleBtn(Icons.map, 'Map', !_isListView, primaryColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                crossAxisCount: 1,
                childAspectRatio: 2.2,
                mainAxisSpacing: 12,
                children: [
                  _buildSupplierCard('Aether Bio-Pharma', 'Pharmaceuticals', 'Germany', 'LOW RISK', 4.5, Colors.green),
                  _buildSupplierCard('VoltDrive Systems', 'Automotive', 'South Korea', 'MED RISK', 5.0, Colors.orange),
                  _buildSupplierCard('Titan Logistics Co.', 'Transportation', 'USA', 'HIGH RISK', 3.0, Colors.red),
                  _buildSupplierCard('EcoNexus Energy', 'Renewables', 'Denmark', 'LOW RISK', 5.0, Colors.green),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.topRight,
        children: [
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: const Color(0xFF0F172A),
            child: const Icon(Icons.compare_arrows, color: Colors.white),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
            child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      bottomNavigationBar: const CustomerBottomNav(currentIndex: 3),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: isSelected ? primaryColor : Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade700, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Icon(Icons.expand_more, size: 14, color: isSelected ? Colors.white : Colors.grey.shade700),
        ],
      ),
    );
  }

  Widget _buildToggleBtn(IconData icon, String label, bool isActive, Color primaryColor) {
    return GestureDetector(
      onTap: () => setState(() => _isListView = label == 'List'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: isActive ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(6), boxShadow: [if (isActive) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]),
        child: Row(
          children: [
            Icon(icon, size: 14, color: isActive ? primaryColor : Colors.grey),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: isActive ? primaryColor : Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplierCard(String name, String sector, String country, String risk, double rating, Color riskColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.business_outlined, color: Colors.grey)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Row(
                      children: [
                        const Icon(Icons.category_outlined, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(sector, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(country, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: riskColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4), border: Border.all(color: riskColor.withValues(alpha: 0.2))),
                    child: Text(risk, style: TextStyle(color: riskColor, fontSize: 8, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(index < rating.floor() ? Icons.star : (index < rating ? Icons.star_half : Icons.star_border), color: Colors.amber, size: 14);
                    }),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEC5B13), foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text('Connect', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Icon(Icons.add, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
