import 'package:flutter/material.dart';

abstract final class AppTheme {
  // Light mode theme
  static ThemeData light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blueGrey,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    visualDensity: VisualDensity.comfortable,
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      filled: true,
    ),
  );

  // Dark mode theme
  static ThemeData dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blueGrey,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    visualDensity: VisualDensity.comfortable,
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      filled: true,
    ),
  );
}
