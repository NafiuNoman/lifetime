import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppText {
  static const _family = 'Inter';
  static const _fallback = ['Hind Siliguri'];

  static const display = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 34,
    height: 40 / 34,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );
  static const titleLg = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 24,
    height: 30 / 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
  );
  static const titleMd = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 20,
    height: 26 / 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );
  static const titleSm = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 17,
    height: 22 / 17,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  static const body = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  static const bodySm = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  static const label = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 13,
    height: 16 / 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    color: AppColors.textPrimary,
  );
  static const caption = TextStyle(
    fontFamily: _family,
    fontFamilyFallback: _fallback,
    fontSize: 11,
    height: 14 / 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
    color: AppColors.textTertiary,
  );

  static const textTheme = TextTheme(
    displaySmall: display,
    headlineSmall: titleLg,
    titleLarge: titleMd,
    titleMedium: titleSm,
    bodyLarge: body,
    bodyMedium: body,
    bodySmall: bodySm,
    labelLarge: label,
    labelSmall: caption,
  );
}
