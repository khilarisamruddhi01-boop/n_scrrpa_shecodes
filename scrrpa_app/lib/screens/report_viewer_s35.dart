import 'package:flutter/material.dart';
import '../widgets/role_bottom_nav.dart';

class ReportViewerS35Screen extends StatefulWidget {
  const ReportViewerS35Screen({super.key});

  @override
  State<ReportViewerS35Screen> createState() => _ReportViewerS35ScreenState();
}

class _ReportViewerS35ScreenState extends State<ReportViewerS35Screen> {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () {}),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quarterly Growth Report', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
            Text('REPORT ID: #S35-2024', style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined, color: primaryColor), onPressed: () {}),
          IconButton(icon: const Icon(Icons.download_outlined, color: primaryColor), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Doc Controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.zoom_out, size: 20, color: Colors.grey)),
                      const Text('125%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.zoom_in, size: 20, color: Colors.grey)),
                    ],
                  ),
                  Container(width: 1, height: 20, color: Colors.grey.shade200),
                  Row(
                    children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_left, size: 20, color: Colors.grey)),
                      const Text('Page 1 of 12', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_right, size: 20, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // PDF Page
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20)]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(padding: const EdgeInsets.only(bottom: 16), decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: primaryColor, width: 2))), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Annual Strategic Analysis', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text('Published: October 24, 2024', style: TextStyle(color: Colors.grey, fontSize: 12))])),
                    const SizedBox(height: 24),
                    RichText(text: const TextSpan(style: TextStyle(color: Colors.black87, fontSize: 13, height: 1.6), children: [TextSpan(text: 'Based on the current fiscal trajectory, the organization has demonstrated a resilient growth pattern of '), TextSpan(text: '12.4%', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)), TextSpan(text: ' across all core sectors. This report details the specific performance indicators that led to this result, focusing on operational efficiencies and market expansion.')])),
                    const SizedBox(height: 32),
                    // Revenue Dist Chart
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('REVENUE DISTRIBUTION', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)), Row(children: [CircleAvatar(radius: 3, backgroundColor: primaryColor), SizedBox(width: 4), CircleAvatar(radius: 3, backgroundColor: Color(0x66EC5B13))])]),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 120,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _buildBar(0.5, primaryColor.withValues(alpha: 0.2)),
                                _buildBar(0.75, primaryColor.withValues(alpha: 0.4)),
                                _buildBar(1.0, primaryColor),
                                _buildBar(0.85, primaryColor.withValues(alpha: 0.6)),
                                _buildBar(0.6, primaryColor.withValues(alpha: 0.3)),
                                _buildBar(0.3, primaryColor.withValues(alpha: 0.1)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('MAY', style: TextStyle(fontSize: 9, color: Colors.grey)), Text('JUN', style: TextStyle(fontSize: 9, color: Colors.grey)), Text('JUL', style: TextStyle(fontSize: 9, color: Colors.grey)), Text('AUG', style: TextStyle(fontSize: 9, color: Colors.grey)), Text('SEP', style: TextStyle(fontSize: 9, color: Colors.grey)), Text('OCT', style: TextStyle(fontSize: 9, color: Colors.grey))]),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Abstract Chart
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Stack(
                          children: [
                            Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [primaryColor.withValues(alpha: 0.1), Colors.transparent, primaryColor.withValues(alpha: 0.05)]))),
                            const Center(child: Icon(Icons.show_chart, size: 60, color: primaryColor)),
                            Positioned(
                              bottom: 12,
                              left: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  children: [
                                    Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.analytics, color: primaryColor, size: 20)),
                                    const SizedBox(width: 12),
                                    const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Predictive Market Shift', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), Text('Confidence Score: 94.2%', style: TextStyle(color: Colors.grey, fontSize: 10))]),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    const Divider(),
                    const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('© 2024 InsightFlow Analytics Corp.', style: TextStyle(color: Colors.grey, fontSize: 8)), Text('Internal Use Only • Confidential', style: TextStyle(color: Colors.grey, fontSize: 8))]),
                  ],
                ),
              ),
            ),
          ),

          // Thumbnails
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('PAGE OVERVIEW', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.2))),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildThumb(true, primaryColor),
                      _buildThumb(false, primaryColor),
                      _buildThumb(false, primaryColor),
                      _buildThumb(false, primaryColor),
                      _buildThumb(false, primaryColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomerBottomNav(currentIndex: 1),
    );
  }

  Widget _buildBar(double heightFactor, Color color) {
    return Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: FractionallySizedBox(heightFactor: heightFactor, child: Container(decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))))));
  }

  Widget _buildThumb(bool isActive, Color primaryColor) {
    return Container(
      width: 64,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), border: Border.all(color: isActive ? primaryColor : Colors.black.withValues(alpha: 0.1), width: isActive ? 2 : 1), boxShadow: isActive ? [BoxShadow(color: primaryColor.withValues(alpha: 0.2), blurRadius: 4, spreadRadius: 2)] : null),
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Container(height: 2, width: double.infinity, color: Colors.grey.shade200),
          const SizedBox(height: 2),
          Align(alignment: Alignment.centerLeft, child: FractionallySizedBox(widthFactor: 0.7, child: Container(height: 2, color: Colors.grey.shade200))),
          const SizedBox(height: 4),
          Expanded(child: Container(decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(2)))),
        ],
      ),
    );
  }
}

extension ColorExt on Color {
  static const Color orangeOpacity40 = Color(0x66EC5B13);
}
