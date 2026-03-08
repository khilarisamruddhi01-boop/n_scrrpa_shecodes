import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class SupplierProfileS19Screen extends StatefulWidget {
  const SupplierProfileS19Screen({super.key});

  @override
  State<SupplierProfileS19Screen> createState() => _SupplierProfileS19ScreenState();
}

class _SupplierProfileS19ScreenState extends State<SupplierProfileS19Screen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Supplier Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16), border: Border.all(color: primaryColor.withValues(alpha: 0.2), width: 2)),
                        child: const Icon(Icons.factory_outlined, size: 48, color: primaryColor),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                        child: const Text('🇨🇭', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Stop A Factory', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                        child: const Text('PHARMACEUTICALS', style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      const Text('Basel, Switzerland', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                          label: const Text('Place Order', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.handshake_outlined, size: 18),
                          label: const Text('Partner', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 16), side: const BorderSide(color: Colors.black12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tabs
            Container(
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12))),
              child: TabBar(
                controller: _tabController,
                labelColor: primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: primaryColor,
                isScrollable: true,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Risk'),
                  Tab(text: 'Dependencies'),
                  Tab(text: 'AI Insights'),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats
                  Row(
                    children: [
                      Expanded(child: _buildSmallStat('Tier Status', 'Tier 1 Strategic')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildSmallStat('Capacity', '84% Utilized')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildSmallStat('Score', '92' , icon: Icons.verified, iconColor: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Facility Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      TextButton(onPressed: () {}, child: const Text('View Full Map', style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold))),
                    ],
                  ),
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(width: 32, height: 32, decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.2), shape: BoxShape.circle)),
                          Container(width: 12, height: 12, decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Certifications
                  const Text('Certifications & Compliance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildChip('ISO 9001', Icons.workspace_premium_outlined, Colors.green),
                      _buildChip('GMP Validated', Icons.workspace_premium_outlined, Colors.green),
                      _buildChip('REACH', Icons.eco_outlined, Colors.green),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Supply Chain Depth
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: primaryColor.withValues(alpha: 0.1))),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Supply Chain Depth', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(12)), child: const Text('3 Upstream Levels', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold))),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _buildGraphNode('Stop B', primaryColor, true),
                            Expanded(child: Container(height: 2, color: primaryColor)),
                            _buildGraphNode('Stop A Factory', Colors.white, false, borderColor: primaryColor, textColor: primaryColor),
                            Expanded(child: Container(height: 2, color: Colors.grey.shade300)),
                            Column(
                              children: [
                                _buildSmallNode('T2'),
                                const SizedBox(height: 4),
                                _buildSmallNode('T2'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text('Stop A relies on 14 Tier-2 suppliers globally.', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Risk Overview
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Risk Profile', style: TextStyle(fontWeight: FontWeight.bold)),
                            const Text('Last updated: 2 hours ago', style: TextStyle(color: Colors.grey, fontSize: 10)),
                            const SizedBox(height: 16),
                            Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.green, width: 4),
                                    color: Colors.green.withValues(alpha: 0.1)
                                ),
                                child: const Center(child: Text('94%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green)))
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('LOW RISK', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                            Text('18.4', style: TextStyle(color: Colors.green, fontSize: 32, fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tip
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: const Border(left: BorderSide(color: Colors.amber, width: 4))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 20),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('AI Recommendation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber)),
                              SizedBox(height: 4),
                              Text("Consider dual-sourcing 'Reagent X' to mitigate current 15% surge in Swiss logistics congestion.", style: TextStyle(fontSize: 11, color: Colors.black87)),
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
          ],
        ),
      ),
      bottomNavigationBar: const SupplierBottomNav(currentIndex: 4),
    );
  }

  Widget _buildSmallStat(String label, String value, {IconData? icon, Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: const TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              if (icon != null) ...[
                const SizedBox(width: 4),
                Icon(icon, size: 12, color: iconColor),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withValues(alpha: 0.1))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildGraphNode(String label, Color color, bool isFull, {Color? borderColor, Color? textColor}) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: borderColor != null ? Border.all(color: borderColor, width: 2) : null),
      child: Center(child: Text(label, style: TextStyle(color: textColor ?? Colors.white, fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
    );
  }

  Widget _buildSmallNode(String label) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
      child: Center(child: Text(label, style: const TextStyle(fontSize: 6, fontWeight: FontWeight.bold))),
    );
  }
}
