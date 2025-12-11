import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Deep organic background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Abstract "Avatar" placeholder - Organic Circle
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.fingerprint, 
                size: 40, 
                color: Colors.white38,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Identity',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w200, // Thin, elegant
                    letterSpacing: 4.0,
                    fontFamily: 'Roboto', // Fallback, assume system font is decent
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Curate your sonic aura',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white30,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}