import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/remote_config_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class S01SplashScreen extends ConsumerStatefulWidget {
  const S01SplashScreen({super.key});

  @override
  ConsumerState<S01SplashScreen> createState() => _S01SplashScreenState();
}

class _S01SplashScreenState extends ConsumerState<S01SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // 1. Minimum check delay
    final startTime = DateTime.now();

    // 2. Check Remote Config for Maintenance Mode and Version
    final rcService = ref.read(remoteConfigServiceProvider);
    await rcService.initialize();

    if (rcService.maintenanceMode) {
      // Show Maintenance screen (should be created)
      return;
    }

    // 3. Version Check (Section 8.3)
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final minVersion = rcService.minVersion;
      
      // Simple version comparison logic
      if (_isVersionBelow(currentVersion, minVersion)) {
        _showUpdateDialog();
        return;
      }
    } catch (e) {
      debugPrint("Version check failed: $e");
    }

    // 4. Auth State Check (Section 2.3)
    final user = FirebaseAuth.instance.currentUser;
    final remainingTime = const Duration(seconds: 3) - DateTime.now().difference(startTime);
    if (remainingTime > Duration.zero) {
      await Future.delayed(remainingTime);
    }

    if (mounted) {
      if (user != null) {
        // User is logged in, navigate based on role (Section 2.3)
        // For now, redirect to main dashboard
        Navigator.pushReplacementNamed(context, '/main_dashboard_s25');
      } else {
        Navigator.pushReplacementNamed(context, '/onboarding_carousel_s02');
      }
    }
  }

  bool _isVersionBelow(String current, String minimum) {
    try {
      final v1 = current.split('.').map(int.parse).toList();
      final v2 = minimum.split('.').map(int.parse).toList();
      for (var i = 0; i < v1.length && i < v2.length; i++) {
        if (v1[i] < v2[i]) return true;
        if (v1[i] > v2[i]) return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('New Version Available'),
        content: const Text('Please update your app to continue using N-SCRRA.'),
        actions: [
          TextButton(
            onPressed: () {
              // Redirect to store
            },
            child: const Text('Update Now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A5F),
              Color(0xFF0D1B2A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              
              // Logo
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF2E9CCA).withValues(alpha: 0.2), width: 2),
                    ),
                  ),
                  Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF2E9CCA).withValues(alpha: 0.4), width: 1),
                    ),
                  ),
                  const Icon(Icons.hub_outlined, color: Color(0xFF2E9CCA), size: 80),
                  const Positioned(
                    bottom: 30,
                    right: 30,
                    child: Icon(Icons.security, color: Color(0xFF2E9CCA), size: 32),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              const Text(
                'N-SCRRA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'National Supply Chain Analyzer',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                ),
              ),
              
              const Spacer(),
              
              // Loader
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  color: Color(0xFF2E9CCA),
                  strokeWidth: 3,
                ),
              ),
              
              const SizedBox(height: 32),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SECURE ENVIRONMENT',
                          style: TextStyle(
                            color: const Color(0xFF2E9CCA).withValues(alpha: 0.6),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 2,
                          width: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E9CCA).withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.66,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E9CCA),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'v1.0.0',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
