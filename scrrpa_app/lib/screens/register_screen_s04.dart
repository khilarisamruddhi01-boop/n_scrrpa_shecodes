import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/auth_service.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedRole = 'customer'; // Default role
  
  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    
    if (email.isEmpty || !_isValidEmail(email)) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid email address')));
      return;
    }
    
    if (password.length < 8) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password must be at least 8 characters')));
      return;
    }
    
    if (password != _confirmPasswordController.text) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.registerWithEmailPassword(
        email,
        password,
        role: _selectedRole, // Pass the role to backend
      );
      if (mounted) Navigator.pushNamed(context, '/email_verification_s05');
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Registration failed')),
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
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1E3A5F);
    const bgColor = Color(0xFFF8F6F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Registration',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stepper
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 48.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(height: 2, color: primaryColor.withValues(alpha: 0.1)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStep(1, 'Account', true),
                      _buildStep(2, 'Org', false),
                      _buildStep(3, 'Role', false),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Create Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 4),
                  const Text('Step 1: Set up your secure login credentials', style: TextStyle(color: Colors.black45, fontSize: 14)),
                  const SizedBox(height: 32),

                  _buildLabel('Account Role'),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: _inputDecoration(icon: Icons.person_outline, hintText: 'Select Role'),
                    items: const [
                      DropdownMenuItem(value: 'customer', child: Text('Customer (Buyer)')),
                      DropdownMenuItem(value: 'supplier', child: Text('Supplier (Vendor)')),
                      DropdownMenuItem(value: 'admin', child: Text('System Administrator')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedRole = val);
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('Email Address'),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration(icon: Icons.mail_outline, hintText: 'name@organization.gov'),
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('Password'),
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
                  const SizedBox(height: 12),
                  
                  // Strength meter
                  Row(
                    children: [
                      _buildBar(true),
                      const SizedBox(width: 4),
                      _buildBar(true),
                      const SizedBox(width: 4),
                      _buildBar(false),
                      const SizedBox(width: 4),
                      _buildBar(false),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.info_outline, size: 12, color: primaryColor),
                      SizedBox(width: 4),
                      Text('Strength: ', style: TextStyle(fontSize: 11, color: Colors.black45)),
                      Text('Medium', style: TextStyle(fontSize: 11, color: primaryColor, fontWeight: FontWeight.bold)),
                      Text('. Use 8+ characters with symbols.', style: TextStyle(fontSize: 11, color: Colors.black45)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('Confirm Password'),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscurePassword,
                    decoration: _inputDecoration(icon: Icons.lock_reset, hintText: '••••••••'),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _isLoading ? null : _register,
                      child: _isLoading
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('Continue to Organization', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, size: 20),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                          children: [
                            TextSpan(text: "Already have an account? "),
                            TextSpan(text: 'Sign In', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Footer summary
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('REGISTRATION DETAILS OVERVIEW', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black26, letterSpacing: 1.2)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildChip(Icons.badge_outlined, 'Compliance Officer Role'),
                      const SizedBox(width: 8),
                      _buildChip(Icons.domain, 'Pending Org Details', isActive: false),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int num, String label, bool active) {
    const primaryColor = Color(0xFF1E3A5F);
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: active ? primaryColor : primaryColor.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(child: Text('$num', style: TextStyle(color: active ? Colors.white : primaryColor, fontWeight: FontWeight.bold, fontSize: 14))),
        ),
        const SizedBox(height: 4),
        Text(label.toUpperCase(), style: TextStyle(color: active ? primaryColor : Colors.black26, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14)),
    );
  }

  Widget _buildBar(bool active) {
    return Expanded(
      child: Container(
        height: 6,
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1E3A5F) : Colors.black12,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String text, {bool isActive = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1E3A5F).withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? const Color(0xFF1E3A5F).withValues(alpha: 0.2) : Colors.transparent),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: isActive ? const Color(0xFF1E3A5F) : Colors.black26),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isActive ? const Color(0xFF1E3A5F) : Colors.black45)),
        ],
      ),
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
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1E3A5F), width: 2)),
    );
  }
}
