import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Filled pie for deadline progress: white slice = elapsed, grey = remaining.
/// Starts at 12 o'clock and fills clockwise.
class AppPie extends StatelessWidget {
  final double value;
  final double size;

  const AppPie({super.key, required this.value, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _PiePainter(value.clamp(0.0, 1.0))),
    );
  }
}

class _PiePainter extends CustomPainter {
  final double value;
  _PiePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawOval(rect, Paint()..color = AppColors.textDisabled);
    if (value <= 0) return;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      value * 2 * math.pi,
      true,
      Paint()..color = AppColors.accent,
    );
  }

  @override
  bool shouldRepaint(_PiePainter old) => old.value != value;
}
