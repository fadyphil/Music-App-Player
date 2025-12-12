import 'package:flutter/material.dart';
import 'package:music_player/core/theme/app_pallete.dart';

class OnboardingContent extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon; // Using IconData as placeholder for images

  const OnboardingContent({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: AppPallete.surfaceLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 100,
              color: AppPallete.primaryGreen,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppPallete.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppPallete.grey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
