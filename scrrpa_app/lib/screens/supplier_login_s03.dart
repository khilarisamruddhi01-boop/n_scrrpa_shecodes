import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/auth_service.dart';

class SupplierLoginS03Screen extends ConsumerStatefulWidget {
  const SupplierLoginS03Screen({super.key});

  @override
  ConsumerState<SupplierLoginS03Screen> createState() => _SupplierLoginS03ScreenState();
}

class _SupplierLoginS03ScreenState extends ConsumerState<SupplierLoginS03Screen> {
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
      
      if (role != 'supplier') {
        await authService.signOut(); // Kick out if not supplier
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Access Denied. Supplier role required.')),
        );
        return;
      }
      
      Navigator.pushReplacementNamed(context, '/supplier_dashboard_s08');
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
      final credential = await authService.signInWithGoogle(role: 'supplier');
      
      if (credential == null) {
        if (mounted) setState(() => _isLoading = false);
        return; 
      }
      
      final role = await authService.getUserRole();
      if (!mounted) return;
      
      if (role != 'supplier') {
        await authService.signOut(); // Kick out if not appropriate role
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Access Denied. Supplier role required.')),
        );
        return;
      }
      
      Navigator.pushReplacementNamed(context, '/supplier_dashboard_s08');
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
      final credential = await authService.signInWithApple(role: 'supplier');
      
      if (credential == null) {
        if (mounted) setState(() => _isLoading = false);
        return; 
      }
      
      final role = await authService.getUserRole();
      if (!mounted) return;
      
      if (role != 'supplier') {
        await authService.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Access Denied. Supplier role required.')),
        );
        return;
      }
      
      Navigator.pushReplacementNamed(context, '/supplier_dashboard_s08');
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
    const primaryColor = Color(0xFFEC5B13);
    const navyDeep = Color(0xFF1E3A5F);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: navyDeep),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                   const Icon(Icons.factory_outlined, color: primaryColor, size: 40),
                  const SizedBox(width: 12),
                  const Text(
                    'Supplier Portal',
                    style: TextStyle(
                      color: navyDeep,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Manage your shipments, track orders, and complete risk assessments.',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
              const SizedBox(height: 48),

              _buildLabel('VENDOR ID'),
              TextField(
                decoration: _inputDecoration(icon: Icons.tag, hintText: 'VND-2024-XXXX'),
              ),
              const SizedBox(height: 24),

              _buildLabel('EMAIL ADDRESS'),
              TextField(
                controller: _emailController,
                decoration: _inputDecoration(icon: Icons.mail_outline, hintText: 'logistics@vendor-name.com'),
              ),
              const SizedBox(height: 24),

              _buildLabel('PASSWORD'),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: _inputDecoration(
                  icon: Icons.lock_outline,
                  hintText: '••••••••',
                  suffix: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.black26),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
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
                  ),
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading 
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Access Dashboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
              
              // Google Sign In
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFEC5B13),
                    side: const BorderSide(color: Color(0xFFEC5B13)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.g_mobiledata, size: 32),
                  label: const Text('Sign In with Google', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    foregroundColor: const Color(0xFFEC5B13),
                    side: const BorderSide(color: Color(0xFFEC5B13)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.apple, size: 28),
                  label: const Text('Sign In with Apple', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: _isLoading ? null : _appleSignIn,
                ),
              ),
              const SizedBox(height: 32),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Need an account? ", style: TextStyle(color: Colors.black54)),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register_screen_s04'),
                    child: const Text('Partner with us', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(color: Color(0xFF1E3A5F), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
    );
  }

  InputDecoration _inputDecoration({IconData? icon, String? hintText, Widget? suffix}) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: icon != null ? Icon(icon, color: Colors.black26) : null,
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEC5B13), width: 2)),
    );
  }
}
