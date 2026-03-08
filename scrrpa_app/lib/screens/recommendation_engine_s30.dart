import 'package:flutter/material.dart';

class RecommendationEngineS30Screen extends StatefulWidget {
  const RecommendationEngineS30Screen({super.key});

  @override
  State<RecommendationEngineS30Screen> createState() => _RecommendationEngineS30ScreenState();
}

class _RecommendationEngineS30ScreenState extends State<RecommendationEngineS30Screen> {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.auto_mode, color: primaryColor)),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('S30 Engine', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
            const Text('Smart Supply Chain Recommendations', style: TextStyle(color: Colors.grey, fontSize: 10)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.grey), onPressed: () {}),
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(icon: const Icon(Icons.notifications_none, color: Colors.grey), onPressed: () {}),
              Positioned(top: 12, right: 12, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle))),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Nav
          Container(
            color: Colors.white,
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildNavItem('Alternatives', true, primaryColor),
                _buildNavItem('Optimization', false, primaryColor),
                _buildNavItem('Safety Stock', false, primaryColor),
                _buildNavItem('Diversification', false, primaryColor),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Engine Update
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: primaryColor.withValues(alpha: 0.1))),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: primaryColor, size: 20),
                        SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Engine Update', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13)), SizedBox(height: 2), Text('We found 3 new alternative suppliers matching your resilience criteria for the Q4 cycle.', style: TextStyle(fontSize: 12, height: 1.4))])),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Recommended Suppliers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recommended Suppliers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)), child: const Text('Sorted by Match Score', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSupplierCard('Global Logistics Corp', 'Rotterdam, NL', '98% Match', 'Primary Alternative', true, primaryColor),
                  const SizedBox(height: 12),
                  _buildSupplierCard('Apex Maritime Partners', 'Singapore', '92% Match', 'Strategic Backup', false, primaryColor),
                  const SizedBox(height: 24),

                  // Optimization
                  const Text('Route Optimization', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: primaryColor.withValues(alpha: 0.1))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.trending_down, color: primaryColor)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Potential Savings: \$12,400/mo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)), child: const Text('HIGH PRIORITY', style: TextStyle(color: primaryColor, fontSize: 8, fontWeight: FontWeight.w900)))]),
                              const SizedBox(height: 4),
                              const Text('Consolidating LTL shipments from Southeast regional hubs could reduce fuel surcharges by 14%.', style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.4)),
                              const SizedBox(height: 12),
                              const Row(children: [Text('Apply Optimized Routing', style: TextStyle(color: primaryColor, fontSize: 13, fontWeight: FontWeight.bold)), SizedBox(width: 4), Icon(Icons.arrow_forward, color: primaryColor, size: 14)]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Inventory
                  const Text('Inventory Recommendations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _buildInventoryItem('SKU-882', '+12%', 'Suggested Increase', primaryColor),
                      _buildInventoryItem('SKU-412', '-5%', 'Suggested Reduce', Colors.black),
                      _buildInventoryItem('SKU-990', '+18%', 'Critical Stock', primaryColor),
                      _buildInventoryItem('SKU-201', '0%', 'Optimized', Colors.black),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), border: const Border(top: BorderSide(color: Colors.black12))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBtmIcon(Icons.home_outlined, 'Home', false, primaryColor),
            _buildBtmIcon(Icons.bar_chart_outlined, 'Insights', false, primaryColor),
            _buildEngineBtn(primaryColor),
            _buildBtmIcon(Icons.inventory_2_outlined, 'Inventory', false, primaryColor),
            _buildBtmIcon(Icons.settings_outlined, 'Settings', false, primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String label, bool isActive, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isActive ? primaryColor : Colors.grey)),
          if (isActive) const SizedBox(height: 4),
          if (isActive) Container(height: 3, width: 40, decoration: BoxDecoration(color: primaryColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(3)))),
        ],
      ),
    );
  }

  Widget _buildSupplierCard(String name, String loc, String match, String tag, bool isSwitchable, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]),
      child: Column(
        children: [
          Row(
            children: [
              Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.warehouse_outlined, color: Colors.grey, size: 40)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(tag.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold)),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Text(match, style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Row(children: [const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey), const SizedBox(width: 4), Text(loc, style: const TextStyle(color: Colors.grey, fontSize: 11))]),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: isSwitchable ? primaryColor : Colors.grey.shade100, foregroundColor: isSwitchable ? Colors.white : Colors.black, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), minimumSize: const Size(0, 44)),
                  child: Text(isSwitchable ? 'Switch Supplier' : 'View Details', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 8),
              if (isSwitchable) Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black12)), child: const Icon(Icons.more_horiz, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryItem(String sku, String value, String sub, Color valColor) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(sku, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: valColor, fontSize: 24, fontWeight: FontWeight.w900)),
          Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildBtmIcon(IconData icon, String label, bool isActive, Color primaryColor) {
    return Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: isActive ? primaryColor : Colors.grey, size: 24), Text(label, style: TextStyle(color: isActive ? primaryColor : Colors.grey, fontSize: 10))]);
  }

  Widget _buildEngineBtn(Color primaryColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), shape: BoxShape.circle), child: Icon(Icons.bolt, color: primaryColor, size: 28)),
        Text('Engine', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 10)),
      ],
    );
  }
}
