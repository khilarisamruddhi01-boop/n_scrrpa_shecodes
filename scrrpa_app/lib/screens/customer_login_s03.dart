import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/auth_service.dart';

class CustomerLoginS03Screen extends ConsumerStatefulWidget {
  const CustomerLoginS03Screen({super.key});

  @override
  ConsumerState<CustomerLoginS03Screen> createState() => _CustomerLoginS03ScreenState();
}

class _CustomerLoginS03ScreenState extends ConsumerState<CustomerLoginS03Screen> {
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
      
      if (role != 'customer') {
        await authService.signOut(); // Kick out if not customer
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Access Denied. Customer role required.')),
        );
        return;
      }
      
      Navigator.pushReplacementNamed(context, '/customer_dashboard_s17');
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
      final credential = await authService.signInWithGoogle(role: 'customer');
      
      if (credential == null) {
        if (mounted) setState(() => _isLoading = false);
        return; 
      }
      
      final role = await authService.getUserRole();
      if (!mounted) return;
      
      if (role != 'customer') {
        await authService.signOut(); // Kick out if not appropriate role
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Access Denied. Customer role required.')),
        );
        return;
      }
      
      Navigator.pushReplacementNamed(context, '/customer_dashboard_s17');
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
      final credential = await authService.signInWithApple(role: 'customer');
      
      if (credential == null) {
        if (mounted) setState(() => _isLoading = false);
        return; 
      }
      
      final role = await authService.getUserRole();
      if (!mounted) return;
      
      if (role != 'customer') {
        await authService.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Access Denied. Customer role required.')),
        );
        return;
      }
      
      Navigator.pushReplacementNamed(context, '/customer_dashboard_s17');
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
    const primaryColor = Color(0xFF1E3A5F);
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
                icon: const Icon(Icons.arrow_back, color: primaryColor),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.corporate_fare, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Organization Login',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Enter your professional credentials to monitor your supply chain networks.',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
              const SizedBox(height: 48),

              _buildLabel('ORGANIZATION TENANT'),
              DropdownButtonFormField<String>(
                decoration: _inputDecoration(icon: Icons.domain, hintText: 'Select Organization'),
                items: const [
                  DropdownMenuItem(value: 'global', child: Text('Global Logistics Alpha')),
                  DropdownMenuItem(value: 'strategic', child: Text('Strategic Manufacturing B')),
                  DropdownMenuItem(value: 'enterprise', child: Text('Enterprise Solutions Inc.')),
                ],
                onChanged: (val) {},
              ),
              const SizedBox(height: 24),

              _buildLabel('BUSINESS EMAIL'),
              TextField(
                controller: _emailController,
                decoration: _inputDecoration(icon: Icons.email_outlined, hintText: 'john.doe@org-name.com'),
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
                    backgroundColor: const Color(0xFF1E3A5F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading 
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Sign In to Dashboard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
              
              // Google Sign In
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1E3A5F),
                    side: const BorderSide(color: Color(0xFF1E3A5F)),
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
                    foregroundColor: const Color(0xFF1E3A5F),
                    side: const BorderSide(color: Color(0xFF1E3A5F)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.apple, size: 28),
                  label: const Text('Sign In with Apple', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: _isLoading ? null : _appleSignIn,
                ),
              ),
              const SizedBox(height: 24),
              
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register_screen_s04'),
                  child: const Text(
                    'New Organization? Register Enterprise Account',
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
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
      prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF1E3A5F).withValues(alpha: 0.5)) : null,
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1E3A5F), width: 2)),
    );
  }
}
