import 'package:flutter/material.dart';

class HelpCenterS45Screen extends StatefulWidget {
  const HelpCenterS45Screen({super.key});

  @override
  State<HelpCenterS45Screen> createState() => _HelpCenterS45ScreenState();
}

class _HelpCenterS45ScreenState extends State<HelpCenterS45Screen> {
  int expandedIndex = 1;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: primaryColor), onPressed: () {}),
        title: const Text('Help Center', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [IconButton(icon: const Icon(Icons.info_outline, color: primaryColor), onPressed: () {})],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Section
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('How can we help?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                  const SizedBox(height: 16),
                  TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search, color: primaryColor), hintText: 'Search documentation, guides, and more...', hintStyle: const TextStyle(fontSize: 14), fillColor: bgColor, filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(vertical: 20))),
                ],
              ),
            ),

            // Video Tutorials
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Video Tutorials', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), TextButton(onPressed: () {}, child: const Text('View all', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)))]),
                  const SizedBox(height: 12),
                  _buildVideoCard('Quick Start Guide: Setting Up Your Workspace', '4:25 • Tutorial', primaryColor),
                  const SizedBox(height: 12),
                  _buildVideoCard('Advanced Analytics & Data Export', '8:12 • Masterclass', primaryColor),
                ],
              ),
            ),

            // FAQ
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Frequently Asked Questions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildFaqItem(0, 'How do I reset my password?', '', primaryColor),
                  _buildFaqItem(1, 'Can I share my account with others?', 'Our standard plans are for individual use. However, you can upgrade to a Team Plan to invite colleagues and collaborate within a shared workspace.', primaryColor),
                  _buildFaqItem(2, 'What payment methods do you accept?', '', primaryColor),
                  _buildFaqItem(3, 'How do I cancel my subscription?', '', primaryColor),
                ],
              ),
            ),

            // Contact Support
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: primaryColor.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Still need help?', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          const Text('Our support team is available 24/7 to assist you.', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.mail_outline), label: const Text('Contact Support'), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: primaryColor, elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
                        ],
                      ),
                    ),
                    const Opacity(opacity: 0.2, child: Icon(Icons.support_agent, size: 80, color: Colors.white)),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
              child: Column(
                children: [
                  const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.language, color: Colors.grey, size: 20), SizedBox(width: 24), Icon(Icons.share_outlined, color: Colors.grey, size: 20), SizedBox(width: 24), Icon(Icons.policy_outlined, color: Colors.grey, size: 20)]),
                  const SizedBox(height: 24),
                  const Text('APP VERSION', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 4),
                  const Text('S45-PRO • Build 2024.08.15', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 24),
                  const Text('© 2024 Your Product Name. All rights reserved.', style: TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard(String title, String meta, Color primaryColor) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryColor.withValues(alpha: 0.8), Colors.black87],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Center(child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle), child: const Icon(Icons.play_arrow, color: Colors.white, size: 32))),
          Positioned(bottom: 16, left: 16, right: 16, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)), Text(meta, style: const TextStyle(color: Colors.white70, fontSize: 11))])),
        ],
      ),
    );
  }

  Widget _buildFaqItem(int index, String question, String answer, Color primaryColor) {
    bool isExpanded = expandedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => expandedIndex = isExpanded ? -1 : index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: isExpanded ? primaryColor.withValues(alpha: 0.05) : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: isExpanded ? primaryColor.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.05))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(question, style: TextStyle(fontWeight: isExpanded ? FontWeight.bold : FontWeight.w500, color: isExpanded ? primaryColor : Colors.black87, fontSize: 14)), Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: isExpanded ? primaryColor : Colors.grey, size: 20)]),
            if (isExpanded && answer.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 12), child: Text(answer, style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.5))),
          ],
        ),
      ),
    );
  }
}
