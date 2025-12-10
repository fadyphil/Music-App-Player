import 'package:flutter/material.dart';

class AppPallete {
  // The Base Colors
  static const Color backgroundColor = Color(
    0xFF121212,
  ); // Deep Dark Grey/Black
  static const Color gradientTop = Color.fromARGB(
    255,
    49,
    55,
    173,
  ); // The Blue top fade
  static const Color gradientBottom = backgroundColor;

  // The Accents
  static const Color primaryGreen = Color(0xFF1ED760); // "Spotify" Green
  static const Color cardColor = Color(
    0xFF242424,
  ); // Slightly lighter for cards

  // New Analytics Accents (Neon/Cyberpunk)
  static const Color neonPurple = Color(0xFFBB86FC);
  static const Color hotPink = Color(0xFFFF4081);
  static const Color electricBlue = Color(0xFF2979FF);
  static const Color warmOrange = Color(0xFFFF9100);
  
  // Surface Variants
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceLight = Color(0xFF2C2C2C);

  // Text & Icons
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static const Color transparent = Colors.transparent;
}
