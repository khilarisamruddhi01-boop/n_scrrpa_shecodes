import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class RiskModelTuningS40Screen extends StatefulWidget {
  const RiskModelTuningS40Screen({super.key});

  @override
  State<RiskModelTuningS40Screen> createState() => _RiskModelTuningS40ScreenState();
}

class _RiskModelTuningS40ScreenState extends State<RiskModelTuningS40Screen> {
  final Map<String, double> weights = {
    'Supply Chain': 45,
    'Logistics': 20,
    'Geopolitical': 15,
    'Financial': 10,
    'Weather': 5,
    'Regulatory': 5,
  };

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Risk Model Tuning (S40)', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
            const Text('Adjust sensitivity parameters', style: TextStyle(color: Colors.grey, fontSize: 10)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.save, color: primaryColor), onPressed: () {}),
          IconButton(icon: const Icon(Icons.history, color: Colors.grey), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stats Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildStatCard('Current Version', 'v2.4.1', 'LATEST', Colors.green),
                  const SizedBox(width: 12),
                  _buildStatCard('Model Accuracy', '94.2%', '+0.5%', primaryColor),
                ],
              ),
            ),

            // Tuning Sliders
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Risk Factor Weights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Text('TOTAL: 100%', style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: weights.keys.map((key) => _buildTuningSlider(key, weights[key]!, primaryColor)).toList(),
              ),
            ),

            // Simulation Preview
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, primaryColor.withValues(alpha: 0.5)],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12), border: Border.all(color: primaryColor.withValues(alpha: 0.2))),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('IMPACT PROJECTION', style: TextStyle(color: primaryColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                        SizedBox(height: 4),
                        Text('Tuning suggests a 12% decrease in supply chain volatility based on current weights.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 0),
    );
  }

  Widget _buildStatCard(String label, String value, String badge, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(width: 6),
                Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)), child: Text(badge, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTuningSlider(String name, double value, Color primaryColor) {
    IconData icon;
    switch (name) {
      case 'Supply Chain': icon = Icons.inventory_2_outlined; break;
      case 'Logistics': icon = Icons.local_shipping_outlined; break;
      case 'Geopolitical': icon = Icons.public; break;
      case 'Financial': icon = Icons.payments_outlined; break;
      case 'Weather': icon = Icons.thermostat; break;
      case 'Regulatory': icon = Icons.gavel; break;
      default: icon = Icons.settings;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [Icon(icon, color: primaryColor, size: 18), const SizedBox(width: 8), Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))]),
              Text('${value.toInt()}%', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(trackHeight: 2, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8), activeTrackColor: primaryColor, inactiveTrackColor: Colors.grey.shade100, thumbColor: primaryColor),
            child: Slider(value: value, min: 0, max: 100, onChanged: (v) => setState(() => weights[name] = v)),
          ),
          if (name == 'Supply Chain') const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('LOW IMPACT', style: TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold)), Text('HIGH IMPACT', style: TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold))]),
        ],
      ),
    );
  }
}
