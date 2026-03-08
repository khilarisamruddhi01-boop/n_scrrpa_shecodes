import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class PlaceOrderS20Screen extends StatefulWidget {
  const PlaceOrderS20Screen({super.key});

  @override
  State<PlaceOrderS20Screen> createState() => _PlaceOrderS20ScreenState();
}

class _PlaceOrderS20ScreenState extends State<PlaceOrderS20Screen> {
  int _quantity = 12;
  String _priority = 'Standard';

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
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Place Order', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(icon: const Icon(Icons.info_outline, color: Colors.black87), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Supplier Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.factory_outlined, size: 32, color: primaryColor),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Stop A Factory', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                                child: const Text('98% Reliability', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 8),
                              const Text('Priority Partner', style: TextStyle(color: Colors.grey, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Product Selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SELECT PRODUCTS', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildProductItem('Reagent X-450', 'SKU: RX-0992 | \$120.00 / Unit', 1440.00, primaryColor),
                  const SizedBox(height: 12),
                  _buildProductPlaceholder('Bio-Vials (Pack 50)', 'SKU: BV-112 | \$45.00 / Unit', primaryColor),
                ],
              ),
            ),

            // Logistics
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('LOGISTICS & DELIVERY', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 12),
                  _buildInputLabel('Expected Delivery Date'),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: '2024-05-24'),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 4, left: 4),
                    child: Text('* Earliest delivery based on 4-day lead time', style: TextStyle(color: Colors.grey, fontSize: 10, fontStyle: FontStyle.italic)),
                  ),
                  const SizedBox(height: 16),
                  _buildInputLabel('Delivery Warehouse'),
                  DropdownButtonFormField<String>(
                    initialValue: 'Plant 4 - Singapore',
                    items: ['Plant 4 - Singapore', 'Warehouse B - Johor'].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 14)))).toList(),
                    onChanged: (v) {},
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInputLabel('Order Priority'),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        _buildPriorityTab('Standard'),
                        _buildPriorityTab('Express'),
                        _buildPriorityTab('Emergency'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Map preview
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomPaint(
                painter: MinimalMapPainter(primaryColor),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(20), border: Border.all(color: primaryColor.withValues(alpha: 0.2))),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.route, size: 14, color: primaryColor),
                        SizedBox(width: 8),
                        Text('Calculate optimal route', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 180),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCostRow('Subtotal Cost', '\$1,440.00'),
            const SizedBox(height: 8),
            _buildCostRow('Estimated Tax (7%)', '\$100.80'),
            const SizedBox(height: 8),
            _buildCostRow('Shipping Fee', 'FREE', isBoldValue: true, valueColor: Colors.green),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Grand Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text('\$1,540.80', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: primaryColor)),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart_checkout),
              label: const Text('Place Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomerBottomNav(currentIndex: 2),
    );
  }

  Widget _buildProductItem(String name, String sku, double subtotal, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: primaryColor.withValues(alpha: 0.1))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(sku, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              ),
              Container(
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    IconButton(onPressed: () => setState(() => _quantity--), icon: const Icon(Icons.remove, size: 14, color: Color(0xFFEC5B13))),
                    Text('$_quantity', style: const TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(onPressed: () => setState(() => _quantity++), icon: const Icon(Icons.add, size: 14, color: Color(0xFFEC5B13))),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('SUBTOTAL', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
              Text('\$${subtotal.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFFEC5B13), fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductPlaceholder(String name, String sku, Color primaryColor) {
    return Opacity(
      opacity: 0.6,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: primaryColor.withValues(alpha: 0.1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(sku, style: const TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor.withValues(alpha: 0.1), foregroundColor: primaryColor, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text('Add to Order', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityTab(String label) {
    bool isSelected = _priority == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _priority = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(color: isSelected ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(8), boxShadow: [if (isSelected) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]),
          child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: isSelected ? const Color(0xFFEC5B13) : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String text) {
    return Padding(padding: const EdgeInsets.only(left: 4, bottom: 4), child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)));
  }

  Widget _buildCostRow(String label, String value, {bool isBoldValue = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: isBoldValue ? FontWeight.bold : FontWeight.normal, color: valueColor ?? Colors.black)),
      ],
    );
  }
}

class MinimalMapPainter extends CustomPainter {
  final Color baseColor;
  MinimalMapPainter(this.baseColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = baseColor.withValues(alpha: 0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw some abstract grid
    for (var i = 0.0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (var i = 0.0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    final routePaint = Paint()
      ..color = baseColor.withValues(alpha: 0.2)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(20, 20)
      ..lineTo(60, 40)
      ..lineTo(100, 30)
      ..lineTo(140, 80)
      ..lineTo(size.width - 20, size.height - 20);

    canvas.drawPath(path, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
