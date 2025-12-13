import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:music_player/core/theme/app_pallete.dart';
import 'package:music_player/features/home/presentation/pages/home_page.dart';
import 'package:music_player/features/onboarding/presentation/pages/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  final bool isFirstRun;
  const SplashPage({super.key, required this.isFirstRun});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Remove the native splash screen immediately when this widget mounts
    FlutterNativeSplash.remove();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for animation or minimum delay
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    if (widget.isFirstRun) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingPage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/images/app_logo.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            )
                .animate()
                .fade(duration: 600.ms)
                .scale(duration: 600.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 24),
            // App Name
            const Text(
              'Spotify el 8alaba',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppPallete.primaryGreen,
                letterSpacing: 1.2,
              ),
            ).animate().fade(delay: 300.ms, duration: 600.ms).moveY(
                  begin: 20,
                  end: 0,
                  delay: 300.ms,
                  duration: 600.ms,
                  curve: Curves.easeOut,
                ),
            const SizedBox(height: 8),
            // Slogan
            const Text(
              'Music for Everyone',
              style: TextStyle(
                fontSize: 16,
                color: AppPallete.grey,
                fontWeight: FontWeight.w500,
              ),
            ).animate().fade(delay: 500.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }
}
