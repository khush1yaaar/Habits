import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Colors.grey.shade600,         // Dark grey for primary color
    secondary: Colors.grey.shade700,       // Slightly lighter grey for secondary color
    surface: Colors.grey.shade900,      // Background color for the app
    onSurface: Colors.white,           // White text on surface
    tertiary: Colors.grey.shade500,
    inversePrimary: Colors.grey.shade300
  ),
);
