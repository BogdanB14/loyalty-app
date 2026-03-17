import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color backgroundPrimary   = Color(0xFF0F0F0F);
  static const Color backgroundSecondary = Color(0xFF1A1A1A);
  static const Color backgroundTertiary  = Color(0xFF242424);

  // Accent
  static const Color accentGold          = Color(0xFFC9A96E);
  static const Color accentGoldLight     = Color(0xFFE8C98A);
  static const Color accentGoldMuted     = Color(0xFF3D2F1A);

  // Text
  static const Color textPrimary         = Color(0xFFF5F0E8);
  static const Color textSecondary       = Color(0xFF8A8580);
  static const Color textTertiary        = Color(0xFF4A4845);

  // Semantic
  static const Color success             = Color(0xFF4CAF7D);
  static const Color error               = Color(0xFFE05252);
  static const Color divider             = Color(0xFF2A2A2A);

  // Legacy aliases — keep existing screens compiling
  static const Color primary        = accentGold;
  static const Color secondary      = accentGoldLight;
  static const Color surface        = backgroundSecondary;
  static const Color surfaceVariant = backgroundTertiary;
  static const Color background     = backgroundPrimary;
  static const Color onPrimary      = Color(0xFF0F0F0F);
  static const Color onSurface      = textPrimary;
}
