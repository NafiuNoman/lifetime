import 'dart:math' as math;

/// A calendar-aware difference between two moments:
/// "2 years, 3 months, 14 days, 5:12:09".
///
/// All arithmetic is done on wall-clock values (converted to UTC fields) so
/// daylight-saving shifts never produce "23-hour days".
class TimeSpan {
  final int years;
  final int months;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  /// Exact total length, for "823 days" / "19,752 hours" style totals.
  final Duration total;

  const TimeSpan({
    required this.years,
    required this.months,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.total,
  });

  static const zero = TimeSpan(
    years: 0,
    months: 0,
    days: 0,
    hours: 0,
    minutes: 0,
    seconds: 0,
    total: Duration.zero,
  );

  /// Span from [from] to [to]. If [to] is before [from] the result is [zero];
  /// callers decide direction (elapsed vs. remaining) themselves.
  factory TimeSpan.between(DateTime from, DateTime to) {
    final a = wallClock(from);
    final b = wallClock(to);
    if (!b.isAfter(a)) return zero;

    var monthsTotal = (b.year - a.year) * 12 + (b.month - a.month);
    var anchor = addMonths(a, monthsTotal);
    while (anchor.isAfter(b)) {
      monthsTotal--;
      anchor = addMonths(a, monthsTotal);
    }

    final rest = b.difference(anchor);
    return TimeSpan(
      years: monthsTotal ~/ 12,
      months: monthsTotal % 12,
      days: rest.inDays,
      hours: rest.inHours % 24,
      minutes: rest.inMinutes % 60,
      seconds: rest.inSeconds % 60,
      total: b.difference(a),
    );
  }

  int get totalDays => total.inDays;
  int get totalWeeks => total.inDays ~/ 7;
  int get totalHours => total.inHours;
  int get totalMinutes => total.inMinutes;
  int get totalSeconds => total.inSeconds;
  int get totalMonths => years * 12 + months;

  bool get isZero => total == Duration.zero;
}

/// Same wall-clock fields, expressed in UTC (no DST).
DateTime wallClock(DateTime d) =>
    DateTime.utc(d.year, d.month, d.day, d.hour, d.minute, d.second);

/// Adds [n] calendar months, clamping the day (Jan 31 + 1 month = Feb 28/29).
DateTime addMonths(DateTime d, int n) {
  final index = d.year * 12 + (d.month - 1) + n;
  final year = index ~/ 12;
  final month = index % 12 + 1;
  final lastDay = DateTime.utc(year, month + 1, 0).day;
  return DateTime.utc(
    year,
    month,
    math.min(d.day, lastDay),
    d.hour,
    d.minute,
    d.second,
  );
}

/// The next anniversary of [date] strictly after [now] (birthdays).
/// A Feb 29 date falls on Feb 28 in non-leap years.
DateTime nextAnniversary(DateTime date, DateTime now) {
  final birth = wallClock(DateTime(date.year, date.month, date.day));
  final today = wallClock(now);
  var years = today.year - birth.year;
  var next = addMonths(birth, years * 12);
  if (!next.isAfter(today)) next = addMonths(birth, ++years * 12);
  return DateTime(next.year, next.month, next.day);
}
