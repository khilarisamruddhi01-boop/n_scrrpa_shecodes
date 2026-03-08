import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);
    const navyCustom = Color(0xFF0F172A);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF334155)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('Verify Email', style: TextStyle(color: navyCustom, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const Icon(Icons.mark_email_unread_outlined, color: primaryColor, size: 48),
            ),
            const SizedBox(height: 32),
            const Text('Enter Verification Code', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: navyCustom), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(color: Colors.black54, fontSize: 16, height: 1.5),
                children: [
                  TextSpan(text: "We've sent a 6-digit code to "),
                  TextSpan(text: 'user@example.com', style: TextStyle(color: navyCustom, fontWeight: FontWeight.bold)),
                  TextSpan(text: '. Please enter it below to continue.'),
                ],
              ),
            ),
            const SizedBox(height: 48),
            
            // OTP Inputs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) => _buildOtpField()),
            ),
            
            const SizedBox(height: 48),
            
            // Timer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimerBox('05', 'Min'),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(':', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: navyCustom)),
                  ),
                ),
                _buildTimerBox('00', 'Sec'),
              ],
            ),
            
            const SizedBox(height: 24),
            TextButton(
              onPressed: null,
              child: const Text("Didn't receive the code? Resend OTP", style: TextStyle(color: Colors.black26, fontWeight: FontWeight.w500)),
            ),
            
            const SizedBox(height: 40),
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
                onPressed: () => Navigator.pushNamed(context, '/main_dashboard_s25'),
                child: const Text('Verify & Continue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Need help? ', style: TextStyle(color: Colors.black54)),
                TextButton(onPressed: () {}, child: const Text('Contact Support', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold))),
              ],
            ),
            
            const SizedBox(height: 48),
            // Branding
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(color: navyCustom, borderRadius: BorderRadius.circular(4)),
                  child: const Center(child: Text('N', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                ),
                const SizedBox(width: 8),
                const Text('N-SCRRA', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: navyCustom, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpField() {
    return Container(
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: TextField(
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          decoration: InputDecoration(counterText: '', border: InputBorder.none),
        ),
      ),
    );
  }

  Widget _buildTimerBox(String value, String label) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 48,
          decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
          child: Center(child: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)))),
        ),
        const SizedBox(height: 4),
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.black38, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
