import 'package:flutter/material.dart';
import 'app_pallete.dart';

class AppTheme {
  // We make it static so we can access it easily in main.dart
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,

    // Define the Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: AppPallete.primaryGreen,
      surface: AppPallete.backgroundColor,
      onSurface: AppPallete.white,
    ),

    // App Bar Defaults
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: AppPallete.white),
    ),

    // Icon Defaults
    iconTheme: const IconThemeData(color: AppPallete.grey),
  );
}
