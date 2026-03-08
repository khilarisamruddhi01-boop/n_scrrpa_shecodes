import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/auth_service.dart';

class AdminLoginS03Screen extends ConsumerStatefulWidget {
  const AdminLoginS03Screen({super.key});

  @override
  ConsumerState<AdminLoginS03Screen> createState() => _AdminLoginS03ScreenState();
}

class _AdminLoginS03ScreenState extends ConsumerState<AdminLoginS03Screen> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    
    if (email.isEmpty || !_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid email address')));
      return;
    }
    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password must be at least 8 characters')));
      return;
    }
    
    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithEmailPassword(email, password);
      
      final role = await authService.getUserRole();
      if (!mounted) return;
      
      if (role != 'admin') {
        await authService.signOut(); // Kick out if not admin
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Access Denied. Administrator role required.')),
        );
        return;
      }
      
      Navigator.pushReplacementNamed(context, '/admin_dashboard_s36');
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Authentication failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _googleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      // We pass the role so the backend can automatically create it in PostgreSQL as an admin
      final credential = await authService.signInWithGoogle(role: 'admin');
      
      if (credential == null) {
        if (mounted) setState(() => _isLoading = false);
        return; 
      }
      
      final role = await authService.getUserRole();
      if (!mounted) return;
      
      if (role != 'admin') {
        await authService.signOut(); // Kick out if not admin
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Access Denied. Administrator role required.')),
        );
        return;
      }
      
      Navigator.pushReplacementNamed(context, '/admin_dashboard_s36');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Sign In failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _appleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      final credential = await authService.signInWithApple(role: 'admin');
      
      if (credential == null) {
        if (mounted) setState(() => _isLoading = false);
        return; 
      }
      
      final role = await authService.getUserRole();
      if (!mounted) return;
      
      if (role != 'admin') {
        await authService.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Access Denied. Administrator role required.')),
        );
        return;
      }
      
      Navigator.pushReplacementNamed(context, '/admin_dashboard_s36');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Apple Sign In failed: $e')),
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
    const accentColor = Color(0xFFEC5B13);
    const bgColor = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Admin Header
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: accentColor.withValues(alpha: 0.2), width: 2),
                  ),
                  child: const Icon(Icons.admin_panel_settings_outlined, color: accentColor, size: 48),
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'ADMIN PORTAL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'N-SCRRA CORE INFRASTRUCTURE',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 60),

              const Text(
                'Identity Verification',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your administrator credentials to access system management tools.',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
              ),
              const SizedBox(height: 40),

              _buildAdminLabel('ADMINISTRATOR EMAIL'),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: _adminInputDecoration(icon: Icons.badge_outlined, hintText: 'admin@n-scrra.gov'),
              ),
              const SizedBox(height: 24),

              _buildAdminLabel('SECURE PASSCODE'),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white),
                decoration: _adminInputDecoration(
                  icon: Icons.vpn_key_outlined,
                  hintText: '••••••••',
                  suffix: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.white38),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 8,
                    shadowColor: accentColor.withValues(alpha: 0.4),
                  ),
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading 
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('AUTHORIZE ACCESS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Google Sign In
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white38),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.g_mobiledata, size: 32),
                  label: const Text('SIGN IN WITH GOOGLE', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  onPressed: _isLoading ? null : _googleSignIn,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Apple Sign In
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white38),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.apple, size: 28),
                  label: const Text('SIGN IN WITH APPLE', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  onPressed: _isLoading ? null : _appleSignIn,
                ),
              ),
              
              const SizedBox(height: 32),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'GO BACK TO ROLE SELECTION',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
    );
  }

  InputDecoration _adminInputDecoration({IconData? icon, String? hintText, Widget? suffix}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white24),
      prefixIcon: icon != null ? Icon(icon, color: const Color(0xFFEC5B13)) : null,
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFF1E293B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white10)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFEC5B13), width: 1.5)),
    );
  }
}
