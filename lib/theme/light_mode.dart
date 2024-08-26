import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.grey.shade300,         // Light grey for primary color
    secondary: Colors.grey.shade400,       // Slightly darker grey for secondary color
    surface: Colors.grey.shade100,         // Background color for the app
    onSurface: Colors.black,               // Black text on surface
    tertiary: Colors.grey.shade400,
    inversePrimary: Colors.grey.shade600,
  ),
);
