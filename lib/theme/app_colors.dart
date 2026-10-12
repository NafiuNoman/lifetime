import 'package:flutter/material.dart';

/// Monochrome palette. Do not add any color with a hue.
abstract final class AppColors {
  // Surfaces
  static const bgBase = Color(0xFF0A0A0A);
  static const bgSurface = Color(0xFF141414);
  static const bgRaised = Color(0xFF1C1C1C);
  static const bgOverlay = Color(0xFF242424);
  static const bgHighest = Color(0xFF2E2E2E);

  // Borders
  static const borderSubtle = Color(0xFF1F1F1F);
  static const borderDefault = Color(0xFF2A2A2A);
  static const borderStrong = Color(0xFF3D3D3D);
  static const borderFocus = Color(0xFFFFFFFF);

  // Text & icons
  static const textPrimary = Color(0xFFF2F2F2);
  static const textSecondary = Color(0xFFA3A3A3);
  static const textTertiary = Color(0xFF6B6B6B);
  static const textDisabled = Color(0xFF474747);
  static const textInverse = Color(0xFF0A0A0A);

  // Accent (white is the accent)
  static const accent = Color(0xFFFFFFFF);
  static const accentPressed = Color(0xFFD9D9D9);
  static const accentMuted = Color(0xFF8A8A8A);

  // Overlay
  static const scrim = Color(0x99000000); // 60% black

  // Chart shades (use with patterns + labels)
  static const chart = [
    Color(0xFFF2F2F2),
    Color(0xFFA3A3A3),
    Color(0xFF6B6B6B),
    Color(0xFF3D3D3D),
  ];
}
