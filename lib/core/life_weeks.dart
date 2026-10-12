import 'dart:math' as math;

import 'time_span.dart';

/// "Your life in weeks": one row per year of age, 52 boxes per row.
///
/// Rows are counted from each birthday (not calendar years), so row N is the
/// year you were N. The 52nd box absorbs the extra 1–2 days of each year.
class LifeWeeks {
  static const weeksPerYear = 52;

  /// Completed years of age.
  final int ageYears;

  /// Index (0..51) of the current week inside the current age-year.
  final int weekOfYear;

  /// Life expectancy the grid is drawn for.
  final int lifeYears;

  const LifeWeeks({
    required this.ageYears,
    required this.weekOfYear,
    required this.lifeYears,
  });

  factory LifeWeeks.of(DateTime birth, DateTime now, int lifeYears) {
    final b = wallClock(DateTime(birth.year, birth.month, birth.day));
    final n = wallClock(DateTime(now.year, now.month, now.day));
    if (n.isBefore(b)) {
      return LifeWeeks(ageYears: 0, weekOfYear: 0, lifeYears: lifeYears);
    }
    final age = TimeSpan.between(b, n).years;
    final lastBirthday = addMonths(b, age * 12);
    final week = math.min(n.difference(lastBirthday).inDays ~/ 7, 51);
    return LifeWeeks(ageYears: age, weekOfYear: week, lifeYears: lifeYears);
  }

  /// Fully lived boxes (the current week is not counted as lived yet).
  int get lived => ageYears * weeksPerYear + weekOfYear;

  /// Index of the "you are here" box.
  int get current => lived;

  int get total => lifeYears * weeksPerYear;
  int get left => math.max(0, total - lived - 1);

  /// Rows to draw: the expectancy, or more if you have already outlived it.
  int get rows => math.max(lifeYears, ageYears + 1);

  bool get beyondExpectancy => ageYears >= lifeYears;

  double get progress => total == 0 ? 1 : math.min(1, lived / total);
}
