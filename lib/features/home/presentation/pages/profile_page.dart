import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_outline, size: 80, color: Colors.white24),
            const SizedBox(height: 16),
            Text(
              'User Profile',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white54,
                    letterSpacing: 2.0,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Module Under Construction',
              style: TextStyle(
                fontFamily: 'monospace',
                color: Colors.white24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
