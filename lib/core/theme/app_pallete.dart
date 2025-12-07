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

  // Text & Icons
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static const Color transparent = Colors.transparent;
}
