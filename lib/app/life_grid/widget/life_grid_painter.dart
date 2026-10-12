import 'package:flutter/material.dart';

import '../../../core/life_weeks.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text.dart';

/// Draws the 52-column life grid. One path per state keeps ~5,000 boxes cheap.
///
/// - lived weeks: text.primary (filled)
/// - this week:   white outline
/// - weeks ahead: bg.highest
/// - rows past the life expectancy (if outlived): drawn as lived, no future
class LifeGridPainter extends CustomPainter {
  final LifeWeeks weeks;

  LifeGridPainter(this.weeks);

  /// Left gutter for the decade labels (10, 20, 30…).
  static const gutter = 20.0;
  static const gap = 1.5;

  /// Extra space after every 10th row so decades read at a glance.
  static const decadeGap = 4.0;

  static double cellFor(double width) =>
      (width - gutter - gap * (LifeWeeks.weeksPerYear - 1)) /
      LifeWeeks.weeksPerYear;

  static double heightFor(double width, int rows) {
    final cell = cellFor(width);
    final decades = (rows - 1) ~/ 10;
    return rows * cell + (rows - 1) * gap + decades * decadeGap;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cell = cellFor(size.width);
    final radius = Radius.circular(cell * 0.2);

    final lived = Path();
    final ahead = Path();
    Rect? currentRect;

    for (var row = 0; row < weeks.rows; row++) {
      final y = row * (cell + gap) + (row ~/ 10) * decadeGap;

      if (row % 10 == 0 && row > 0) {
        final tp = TextPainter(
          text: TextSpan(text: '$row', style: AppText.caption),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(0, y + (cell - tp.height) / 2));
      }

      for (var col = 0; col < LifeWeeks.weeksPerYear; col++) {
        final index = row * LifeWeeks.weeksPerYear + col;
        final rect = Rect.fromLTWH(gutter + col * (cell + gap), y, cell, cell);
        if (index < weeks.lived) {
          lived.addRRect(RRect.fromRectAndRadius(rect, radius));
        } else if (index == weeks.current) {
          currentRect = rect;
        } else {
          ahead.addRRect(RRect.fromRectAndRadius(rect, radius));
        }
      }
    }

    canvas.drawPath(ahead, Paint()..color = AppColors.bgHighest);
    canvas.drawPath(lived, Paint()..color = AppColors.textPrimary);
    if (currentRect != null) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(currentRect.deflate(0.5), radius),
        Paint()
          ..color = AppColors.accent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(LifeGridPainter old) =>
      old.weeks.lived != weeks.lived ||
      old.weeks.rows != weeks.rows ||
      old.weeks.lifeYears != weeks.lifeYears;
}
