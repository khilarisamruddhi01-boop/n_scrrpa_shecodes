import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class RiskModelSettingsS40Screen extends StatefulWidget {
  const RiskModelSettingsS40Screen({super.key});

  @override
  State<RiskModelSettingsS40Screen> createState() => _RiskModelSettingsS40ScreenState();
}

class _RiskModelSettingsS40ScreenState extends State<RiskModelSettingsS40Screen> {
  double supplyRisk = 0.30;
  double logisticsRisk = 0.25;
  double geopoliticalRisk = 0.20;
  double financialRisk = 0.15;
  double esgRisk = 0.10;

  double get totalWeight => supplyRisk + logisticsRisk + geopoliticalRisk + financialRisk + esgRisk;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: primaryColor), onPressed: () {}),
        title: const Text('Risk Model Settings (S40)', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
        actions: [IconButton(icon: const Icon(Icons.help_outline, color: Colors.grey), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tune Risk Factor Weights', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            const Text('Adjust the relative importance of each factor. The total model weight must sum to 1.00 to ensure statistical validity.', style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5)),
            const SizedBox(height: 24),

            // Total Weight Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: primaryColor.withValues(alpha: 0.2))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('TOTAL WEIGHT STATUS', style: TextStyle(color: primaryColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(totalWeight.toStringAsFixed(2), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          if ((totalWeight - 1.0).abs() < 0.001) const Icon(Icons.check_circle, color: Colors.green, size: 24) else const Icon(Icons.warning, color: Colors.red, size: 24),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Distribution', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildDistBar(32, primaryColor),
                          _buildDistBar(24, primaryColor.withValues(alpha: 0.6)),
                          _buildDistBar(48, primaryColor.withValues(alpha: 0.4)),
                          _buildDistBar(16, primaryColor.withValues(alpha: 0.2)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Sliders
            _buildFactorSlider('Supply Chain Risk', 'Vendor reliability, inventory volatility...', supplyRisk, (v) => setState(() => supplyRisk = v), primaryColor),
            _buildFactorSlider('Logistics & Freight', 'Port congestion, fuel price fluctuations...', logisticsRisk, (v) => setState(() => logisticsRisk = v), primaryColor),
            _buildFactorSlider('Geopolitical Stability', 'Trade tariffs, regional conflicts...', geopoliticalRisk, (v) => setState(() => geopoliticalRisk = v), primaryColor),
            _buildFactorSlider('Economic & Financial', 'Currency fluctuations, interest rates...', financialRisk, (v) => setState(() => financialRisk = v), primaryColor),
            _buildFactorSlider('Environmental (ESG)', 'Climate events, sustainability compliance...', esgRisk, (v) => setState(() => esgRisk = v), primaryColor),

            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.visibility_outlined), label: const Text('Preview Impact'), style: OutlinedButton.styleFrom(foregroundColor: primaryColor, side: const BorderSide(color: primaryColor, width: 2), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.psychology_outlined), label: const Text('Retrain Model'), style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 4, shadowColor: primaryColor.withValues(alpha: 0.3)))),
              ],
            ),

            const SizedBox(height: 48),
            const Text('LAST MODIFIED', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
              child: Row(
                children: [
                  Container(width: 40, height: 40, decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), shape: BoxShape.circle), child: const Icon(Icons.history, color: primaryColor)),
                  const SizedBox(width: 16),
                  const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Model v4.2.1 Active', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), Text('Updated by Sarah Jenkins • Oct 24, 2023', style: TextStyle(color: Colors.grey, fontSize: 11))]),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 0),
    );
  }

  Widget _buildDistBar(double width, Color color) {
    return Container(width: width, height: 8, margin: const EdgeInsets.only(left: 4), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)));
  }

  Widget _buildFactorSlider(String label, String desc, double val, Function(double) onChanged, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black.withValues(alpha: 0.05))), child: Text(val.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, fontFeatures: [FontFeature.tabularFigures()]))),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(trackHeight: 2, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8), overlayShape: const RoundSliderOverlayShape(overlayRadius: 16), activeTrackColor: primaryColor, inactiveTrackColor: Colors.black.withValues(alpha: 0.1), thumbColor: primaryColor),
            child: Slider(value: val, min: 0, max: 1, onChanged: onChanged),
          ),
          Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }
}
