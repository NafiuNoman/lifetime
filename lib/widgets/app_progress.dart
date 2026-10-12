import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Thin progress line: bg.highest track, white fill.
class AppProgress extends StatelessWidget {
  final double value;
  final double height;

  const AppProgress({super.key, required this.value, this.height = 4});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: LinearProgressIndicator(
        value: value,
        minHeight: height,
        backgroundColor: AppColors.bgHighest,
        color: AppColors.accent,
      ),
    );
  }
}
