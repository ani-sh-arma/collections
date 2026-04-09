import 'package:flutter/material.dart';

abstract final class AppColors {
  // === Deep backgrounds ===
  static const bgDeep = Color(0xFF080D1A);
  static const bgSurface = Color(0xFF0E1525);
  static const bgCard = Color(0xFF172035);
  static const bgElevated = Color(0xFF1F2D44);

  // === Accent colours ===
  static const gold = Color(0xFFF0A500);       // primary amber-gold
  static const goldLight = Color(0xFFFFCB47);
  static const goldDim = Color(0xFF7A5200);

  static const sky = Color(0xFF38BDF8);         // online / info
  static const skyDim = Color(0xFF0A3855);

  static const emerald = Color(0xFF10B981);     // offline / success
  static const emeraldDim = Color(0xFF064E3B);

  static const rose = Color(0xFFEF4444);        // error / delete
  static const roseDim = Color(0xFF7F1D1D);

  // === Text ===
  static const textPrimary = Color(0xFFE8EFF7);
  static const textSecondary = Color(0xFF8A9BB0);
  static const textMuted = Color(0xFF4E5F74);

  // === Text on gold (dark brown – used for button labels on gold backgrounds) ===
  static const onGold = Color(0xFF150900);

  // === Borders ===
  static const border = Color(0xFF1E2F45);
  static const borderFocused = Color(0xFFF0A500);

  // === Grand total card gradient stops ===
  static const grandTotalGradientStart = Color(0xFF2A1900);
  static const grandTotalGradientEnd = Color(0xFF1A1200);

  // === Misc ===
  static const white = Color(0xFFFFFFFF);
  static const transparent = Color(0x00000000);
}
