import 'dart:math';
import 'package:flutter/material.dart';

class GradientGenerator {
  static final Random _random = Random();

  // Predefined beautiful gradient combinations
  static final List<List<Color>> _gradientPairs = [
    [const Color(0xFF667eea), const Color(0xFF764ba2)], // Purple Blue
    [const Color(0xFFf093fb), const Color(0xFFf5576c)], // Pink Red
    [const Color(0xFF4facfe), const Color(0xFF00f2fe)], // Blue Cyan
    [const Color(0xFF43e97b), const Color(0xFF38f9d7)], // Green Cyan
    [const Color(0xFFfa709a), const Color(0xFFfee140)], // Pink Yellow
    [const Color(0xFFa8edea), const Color(0xFFfed6e3)], // Mint Pink
    [const Color(0xFFffecd2), const Color(0xFFfcb69f)], // Peach Orange
    [const Color(0xFFd299c2), const Color(0xFFfef9d7)], // Purple Cream
    [const Color(0xFF89f7fe), const Color(0xFF66a6ff)], // Light Blue
    [const Color(0xFFfdbb2d), const Color(0xFF22c1c3)], // Yellow Teal
    [const Color(0xFFff9a9e), const Color(0xFFfecfef)], // Coral Pink
    [const Color(0xFFa18cd1), const Color(0xFFfbc2eb)], // Lavender Pink
    [const Color(0xFFfad0c4), const Color(0xFFffd1ff)], // Peach Lavender
    [const Color(0xFFffeaa7), const Color(0xFFfab1a0)], // Yellow Peach
    [const Color(0xFF74b9ff), const Color(0xFF0984e3)], // Light Blue Dark Blue
    [const Color(0xFF00b894), const Color(0xFF00cec9)], // Green Teal
    [const Color(0xFFe17055), const Color(0xFFfdcb6e)], // Orange Yellow
    [const Color(0xFF6c5ce7), const Color(0xFFa29bfe)], // Purple Light Purple
    [const Color(0xFFfd79a8), const Color(0xFFfdcb6e)], // Pink Yellow
    [const Color(0xFF00cec9), const Color(0xFF55a3ff)], // Teal Blue
  ];

  /// Generates a random gradient from predefined beautiful combinations
  static LinearGradient generateRandomGradient() {
    final pair = _gradientPairs[_random.nextInt(_gradientPairs.length)];
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: pair,
    );
  }

  /// Generates a gradient from hex color strings
  static LinearGradient gradientFromHex(String colorA, String colorB) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(int.parse(colorA.replaceFirst('#', '0xFF'))),
        Color(int.parse(colorB.replaceFirst('#', '0xFF'))),
      ],
    );
  }

  /// Converts a Color to hex string
  static String colorToHex(Color color) {
    // ignore: deprecated_member_use
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  /// Gets a random gradient pair as hex strings
  static Map<String, String> getRandomGradientHex() {
    final gradient = generateRandomGradient();
    return {
      'colorA': colorToHex(gradient.colors[0]),
      'colorB': colorToHex(gradient.colors[1]),
    };
  }

  /// Creates a gradient with custom begin and end alignments
  static LinearGradient createCustomGradient({
    required String colorA,
    required String colorB,
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [
        Color(int.parse(colorA.replaceFirst('#', '0xFF'))),
        Color(int.parse(colorB.replaceFirst('#', '0xFF'))),
      ],
    );
  }

  /// Gets a gradient that works well with text (ensures good contrast)
  static LinearGradient getTextFriendlyGradient() {
    // These gradients are specifically chosen to work well with white text
    final textFriendlyPairs = [
      [const Color(0xFF667eea), const Color(0xFF764ba2)], // Purple Blue
      [const Color(0xFF4facfe), const Color(0xFF00f2fe)], // Blue Cyan
      [const Color(0xFF43e97b), const Color(0xFF38f9d7)], // Green Cyan
      [const Color(0xFF22c1c3), const Color(0xFFfdbb2d)], // Teal Yellow
      [const Color(0xFF74b9ff), const Color(0xFF0984e3)], // Light Blue Dark Blue
      [const Color(0xFF00b894), const Color(0xFF00cec9)], // Green Teal
      [const Color(0xFF6c5ce7), const Color(0xFFa29bfe)], // Purple Light Purple
      [const Color(0xFF00cec9), const Color(0xFF55a3ff)], // Teal Blue
    ];

    final pair = textFriendlyPairs[_random.nextInt(textFriendlyPairs.length)];
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: pair,
    );
  }

  /// Gets the text color that would work best with a given gradient
  static Color getTextColorForGradient(String colorA, String colorB) {
    final color1 = Color(int.parse(colorA.replaceFirst('#', '0xFF')));
    final color2 = Color(int.parse(colorB.replaceFirst('#', '0xFF')));

    // Calculate average luminance
    final luminance1 = color1.computeLuminance();
    final luminance2 = color2.computeLuminance();
    final avgLuminance = (luminance1 + luminance2) / 2;

    // Return white for dark gradients, black for light gradients
    return avgLuminance > 0.5 ? Colors.black : Colors.white;
  }
}
