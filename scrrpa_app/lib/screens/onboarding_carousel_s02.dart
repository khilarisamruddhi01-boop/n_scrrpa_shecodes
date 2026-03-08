import 'package:flutter/material.dart';

class OnboardingCarouselScreen extends StatefulWidget {
  const OnboardingCarouselScreen({super.key});

  @override
  State<OnboardingCarouselScreen> createState() => _OnboardingCarouselScreenState();
}

class _OnboardingCarouselScreenState extends State<OnboardingCarouselScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Supply Visibility',
      description: 'Gain total oversight with real-time supply network maps and comprehensive logistics tracking across all tiers.',
      icon: Icons.hub,
    ),
    OnboardingData(
      title: 'AI Prediction',
      description: 'Leverage ML-powered forecasting to anticipate demand shifts and supply disruptions before they impact your operations.',
      icon: Icons.psychology,
    ),
    OnboardingData(
      title: 'Simulation Engine',
      description: 'Run complex stress tests to simulate cascade failures and identify critical vulnerabilities in your supply chain network.',
      icon: Icons.analytics,
    ),
    OnboardingData(
      title: 'Smart Recommendations',
      description: 'Receive actionable alternatives and real-time optimizations to maintain resilience and business continuity.',
      icon: Icons.recommend,
    ),
  ];


  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const navyCustom = Color(0xFF1E3A5F);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Top right gradient decoration
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [navyCustom.withValues(alpha: 0.1), Colors.transparent],
                    center: Alignment.topRight,
                    radius: 1.0,
                  ),
                ),
              ),
            ),
            
            Column(
              children: [
                // Top Nav
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/role_selection'),
                      child: const Text('Skip', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      final item = _pages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 280,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Abstract background pattern using CustomPaint for high-end feel
                                  CustomPaint(
                                    size: const Size(double.infinity, 280),
                                    painter: AbstractNetworkPainter(item.icon),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(item.icon, size: 100, color: primaryColor),
                                      const SizedBox(height: 16),
                                      Container(height: 4, width: 96, decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 48),
                            Text(
                              item.title,
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: navyCustom),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              item.description,
                              style: TextStyle(fontSize: 16, color: Colors.grey.shade500, height: 1.5),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                
                // Footer
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      // Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_pages.length, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: _currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index ? navyCustom : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 48),
                      // Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 4,
                            shadowColor: primaryColor.withValues(alpha: 0.4),
                          ),
                          onPressed: () {
                            if (_currentPage < _pages.length - 1) {
                              _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                            } else {
                              Navigator.pushReplacementNamed(context, '/role_selection');
                            }
                          },
                          child: const Text('Next', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;

  OnboardingData({required this.title, required this.description, required this.icon});
}

class AbstractNetworkPainter extends CustomPainter {
  final IconData icon;
  AbstractNetworkPainter(this.icon);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFEC5B13).withValues(alpha: 0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    for (var i = 1; i <= 5; i++) {
        canvas.drawCircle(center, i * 40.0, paint);
    }
    
    // Draw some random nodes and lines to simulate connectivity
    final nodePaint = Paint()..color = const Color(0xFFEC5B13).withValues(alpha: 0.1)..style = PaintingStyle.fill;
    final linePaint = Paint()..color = const Color(0xFFEC5B13).withValues(alpha: 0.05)..strokeWidth = 1;

    final nodes = [
      const Offset(50, 50),
      Offset(size.width - 50, 80),
      Offset(80, size.height - 60),
      Offset(size.width - 100, size.height - 40),
    ];

    for (var node in nodes) {
      canvas.drawCircle(node, 4, nodePaint);
      canvas.drawLine(center, node, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
