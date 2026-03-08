import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class SupplierFeedbackS24Screen extends StatefulWidget {
  const SupplierFeedbackS24Screen({super.key});

  @override
  State<SupplierFeedbackS24Screen> createState() => _SupplierFeedbackS24ScreenState();
}

class _SupplierFeedbackS24ScreenState extends State<SupplierFeedbackS24Screen> {
  final double _overallRating = 4.0;
  final Map<String, double> _categoryRatings = {
    'Delivery Speed': 5.0,
    'Packaging Quality': 3.0,
    'Communication': 4.0,
    'Product Quality': 5.0,
  };
  bool _isAnonymous = false;

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
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Supplier Feedback', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shipment Selector
            const Text('SELECT SHIPMENT', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text('Choose a completed shipment', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  items: [
                    'SHP-98322 - Industrial Parts (Delivered Oct 24)',
                    'SHP-98401 - Raw Steel Coils (Delivered Oct 22)',
                  ].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13)))).toList(),
                  onChanged: (v) {},
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Overall Rating
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black.withValues(alpha: 0.05)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Overall Performance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ...List.generate(5, (index) => Icon(index < _overallRating ? Icons.star : Icons.star_border, color: primaryColor, size: 40)),
                      const SizedBox(width: 16),
                      Text('$_overallRating', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Tap a star to rate the overall experience with Stop A.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Categories
            const Text('SPECIFIC CATEGORIES', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            const SizedBox(height: 12),
            ..._categoryRatings.entries.map((e) => _buildCategoryRating(e.key, e.value, primaryColor)),
            const SizedBox(height: 24),

            // Comments
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('COMMENTS & OBSERVATIONS', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                const Text('124 / 500', style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Share your experience...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.black12)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.black12)),
              ),
              controller: TextEditingController(text: 'The delivery arrived 2 hours ahead of schedule. Packaging was intact, though one of the outer pallets had some moisture on the shrink wrap. Overall very satisfied with the communication.'),
            ),
            const SizedBox(height: 24),

            // Photos
            const Text('ATTACH PHOTOS', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildPhotoPlaceholder(Icons.inventory_2_outlined),
                  const SizedBox(width: 12),
                  _buildPhotoPlaceholder(Icons.local_shipping_outlined),
                  const SizedBox(width: 12),
                  _buildAddPhotoBtn(primaryColor),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Anonymous
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
              child: Row(
                children: [
                  Container(width: 40, height: 40, decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), shape: BoxShape.circle), child: const Icon(Icons.visibility_off_outlined, color: primaryColor, size: 18)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Submit Anonymously', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text('Your company name will be hidden.', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                  ),
                  Switch(value: _isAnonymous, activeThumbColor: primaryColor, onChanged: (v) => setState(() => _isAnonymous = v)),
                ],
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), border: const Border(top: BorderSide(color: Colors.black12))),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.send),
          label: const Text('Submit Feedback', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        ),
      ),
      bottomNavigationBar: const SupplierBottomNav(currentIndex: 4),
    );
  }

  Widget _buildCategoryRating(String label, double rating, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Row(children: List.generate(5, (index) => Icon(index < rating ? Icons.star : Icons.star_border, color: primaryColor, size: 20))),
        ],
      ),
    );
  }

  Widget _buildPhotoPlaceholder(IconData icon) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, color: Colors.grey.shade400, size: 40),
          Positioned(top: 4, right: 4, child: Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle), child: const Icon(Icons.close, size: 12, color: Colors.white))),
        ],
      ),
    );
  }

  Widget _buildAddPhotoBtn(Color primaryColor) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid, width: 2)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_a_photo_outlined, color: Colors.grey, size: 30),
          const SizedBox(height: 4),
          const Text('ADD PHOTO', style: TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
