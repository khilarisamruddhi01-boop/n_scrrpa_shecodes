import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/auth_service.dart';

class S03LoginScreen extends ConsumerStatefulWidget {
  const S03LoginScreen({super.key});

  @override
  ConsumerState<S03LoginScreen> createState() => _S03LoginScreenState();
}

class _S03LoginScreenState extends ConsumerState<S03LoginScreen> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      
      final role = await authService.getUserRole();
      
      if (!mounted) return;
      
      if (role == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin_dashboard_s36');
      } else if (role == 'supplier') {
        Navigator.pushReplacementNamed(context, '/supplier_dashboard_s08');
      } else if (role == 'customer') {
        Navigator.pushReplacementNamed(context, '/customer_dashboard_s17');
      } else {
        Navigator.pushReplacementNamed(context, '/main_dashboard_s25');
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Login failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2E9CCA);
    const navyDeep = Color(0xFF1E3A5F);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(height: 8, color: navyDeep),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
                child: Column(
                  children: [
                    // App Logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: navyDeep,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.analytics_outlined, color: Colors.white, size: 32),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'N-SCRRA',
                          style: TextStyle(
                            color: navyDeep,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    
                    // Welcome Header
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        color: navyDeep,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Access your supply chain resilience insights',
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    const SizedBox(height: 48),

                    // Form
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Organization', style: TextStyle(color: navyDeep, fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          decoration: _inputDecoration(context, icon: Icons.corporate_fare_outlined),
                          items: const [
                            DropdownMenuItem(value: 'federal', child: Text('Federal Agency')),
                            DropdownMenuItem(value: 'logistics', child: Text('Global Logistics Alpha')),
                            DropdownMenuItem(value: 'mfg', child: Text('Strategic Manufacturing B')),
                          ],
                          onChanged: (val) {},
                          hint: const Text('Select your tenant/org'),
                        ),
                        const SizedBox(height: 20),

                        const Text('Email Address', style: TextStyle(color: navyDeep, fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          decoration: _inputDecoration(context, icon: Icons.mail_outline, hintText: 'name@organization.gov'),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Password', style: TextStyle(color: navyDeep, fontWeight: FontWeight.bold, fontSize: 14)),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/forgot_password_screen_s06'),
                              child: const Text('Forgot Password?', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 14)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: _inputDecoration(
                            context, 
                            icon: Icons.lock_outline, 
                            hintText: '••••••••',
                            suffix: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.black26),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Login Button
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
                            onPressed: _isLoading ? null : _login,
                            child: _isLoading 
                                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),

                        // Divider
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32.0),
                          child: Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text('OR CONTINUE WITH', style: TextStyle(color: Colors.black26, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                        ),

                        // Social/Biometric
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.g_mobiledata, color: Colors.blue, size: 32),
                                      const SizedBox(width: 4),
                                      const Text('Google Workspace', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.fingerprint, color: navyDeep, size: 32),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 48),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black54, fontSize: 14),
                              children: [
                                const TextSpan(text: "Don't have an account? "),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () => Navigator.pushNamed(context, '/register_screen_s04'),
                                    child: const Text('Register Now', style: TextStyle(color: navyDeep, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, {IconData? icon, String? hintText, Widget? suffix}) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: icon != null ? Icon(icon, color: Colors.black26) : null,
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12, width: 1)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2E9CCA), width: 2)),
    );
  }
}
