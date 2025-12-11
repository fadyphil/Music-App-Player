import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Tech-Noir Aesthetic
    return Scaffold(
      backgroundColor: Colors.transparent, // Let the background gradient shine
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Schematic Circle
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white24,
                  width: 1,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Spinning Ring (Static for now, implies motion)
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.fingerprint,
                    size: 60,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            
            // Monospace Typography
            const Text(
              "SUBJECT: USER_01",
              style: TextStyle(
                fontFamily: 'monospace',
                letterSpacing: 3.0,
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "AUDITORY PROFILE",
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.0,
                    color: Colors.white,
                  ),
            ),
            
            const SizedBox(height: 24),
            // Decorative Data Lines
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DataPoint(label: "FREQ", value: "44.1kHz"),
                const SizedBox(width: 32),
                _DataPoint(label: "BITRATE", value: "320kbps"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DataPoint extends StatelessWidget {
  final String label;
  final String value;

  const _DataPoint({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white30,
            fontSize: 10,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
