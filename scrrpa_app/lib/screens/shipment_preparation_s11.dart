import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class ShipmentPreparationS11Screen extends StatefulWidget {
  const ShipmentPreparationS11Screen({super.key});

  @override
  State<ShipmentPreparationS11Screen> createState() => _ShipmentPreparationS11ScreenState();
}

class _ShipmentPreparationS11ScreenState extends State<ShipmentPreparationS11Screen> {
  String _selectedOrder = 'ord-88294';
  String _selectedWarehouse = 'east-coast';
  String _transportMode = 'Road';

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Prepare Shipment', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Select Order & Warehouse
            _buildSectionLabel('Select Order'),
            _buildDropdown(
              value: _selectedOrder,
              items: {
                'ord-88294': '#ORD-88294 from Stop B',
                'ord-88295': '#ORD-88295 from Stop C',
              },
              onChanged: (val) => setState(() => _selectedOrder = val!),
              icon: Icons.assignment_outlined,
            ),
            const SizedBox(height: 16),
            _buildSectionLabel('Origin Warehouse'),
            _buildDropdown(
              value: _selectedWarehouse,
              items: {
                'east-coast': 'East Coast Facility',
                'west-coast': 'West Coast Logistics Hub',
                'central': 'Central Distribution Center',
              },
              onChanged: (val) => setState(() => _selectedWarehouse = val!),
              icon: Icons.warehouse_outlined,
            ),
            const SizedBox(height: 24),

            // Transport Mode
            _buildSectionLabel('Transport Mode'),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _buildTransportBtn('Road', Icons.local_shipping_outlined),
                _buildTransportBtn('Rail', Icons.train_outlined),
                _buildTransportBtn('Sea', Icons.directions_boat_outlined),
                _buildTransportBtn('Air', Icons.flight_outlined),
              ],
            ),
            const SizedBox(height: 24),

            // Dates
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel('Dispatch Date'),
                      _buildDateField('2023-10-24'),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel('Estimated Arrival'),
                      _buildStaticValue('Oct 28, 2023'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Packaging Details
            _buildSectionLabel('Packaging Details'),
            _buildTextArea('Specify pallets, containers, hazardous materials handling...'),
            const SizedBox(height: 24),

            // Route Preview
            _buildSectionLabel('Route Preview'),
            _buildRoutePreview(primaryColor),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: bgColor, border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.1)))),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.assignment_turned_in_outlined, size: 20),
              label: const Text('Generate Shipment ID & Dispatch'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                shadowColor: primaryColor.withValues(alpha: 0.3),
              ),
            ),
          ),
          const SupplierBottomNav(currentIndex: 2),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54)),
    );
  }

  Widget _buildDropdown({required String value, required Map<String, String> items, required Function(String?) onChanged, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(icon, color: Colors.grey, size: 20),
          items: items.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value, style: const TextStyle(fontSize: 14)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTransportBtn(String label, IconData icon) {
    bool isSelected = _transportMode == label;
    const primaryColor = Color(0xFFEC5B13);

    return GestureDetector(
      onTap: () => setState(() => _transportMode = label),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? primaryColor : Colors.black12, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? primaryColor : Colors.grey, size: 20),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isSelected ? primaryColor : Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(String val) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(val, style: const TextStyle(fontSize: 14)),
          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildStaticValue(String val) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
      child: Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
    );
  }

  Widget _buildTextArea(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black12)),
      child: TextField(
        maxLines: 3,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none, hintStyle: const TextStyle(fontSize: 13, color: Colors.grey)),
      ),
    );
  }

  Widget _buildRoutePreview(Color primaryColor) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: const Icon(Icons.map_outlined, color: Colors.grey, size: 40),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      const Text('LOW RISK', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.route_outlined, color: primaryColor, size: 16),
                    const SizedBox(width: 8),
                    const Text('I-95 North Corridor (420 miles)', style: TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.bold)),
                  ],
                ),
                Text('DETAILS', style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
