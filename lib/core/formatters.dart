import 'time_span.dart';

/// How the main number on a card is shown. Cycled from Home → View options.
enum DisplayFormat {
  calendar('Y M D', '2y 3m 14d'),
  days('Days', '823 days'),
  hours('Hours', '19,752 hours');

  final String label;
  final String example;
  const DisplayFormat(this.label, this.example);
}

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];
const _weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

/// 1234567 → "1,234,567"
String formatNumber(int n) {
  final s = n.abs().toString();
  final buf = StringBuffer(n < 0 ? '-' : '');
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}

String _plural(int n, String unit) =>
    '${formatNumber(n)} $unit${n == 1 ? '' : 's'}';

String _two(int n) => n.toString().padLeft(2, '0');

/// "12 Oct 2026"
String formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

/// "9:05 PM", or "21:05" with [use24h].
String formatTime(DateTime d, {bool use24h = false}) {
  if (use24h) return '${_two(d.hour)}:${_two(d.minute)}';
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  return '$h:${_two(d.minute)} ${d.hour < 12 ? 'AM' : 'PM'}';
}

/// "12 Oct 2026" or "12 Oct 2026, 9:05 PM" / "12 Oct 2026, 21:05"
String formatDateTime(
  DateTime d, {
  required bool withTime,
  bool use24h = false,
}) => withTime
    ? '${formatDate(d)}, ${formatTime(d, use24h: use24h)}'
    : formatDate(d);

String weekdayName(DateTime d) => _weekdays[d.weekday - 1];

/// The headline value of a span in the chosen [format].
String formatSpan(TimeSpan s, DisplayFormat format) {
  switch (format) {
    case DisplayFormat.calendar:
      return compactSpan(s);
    case DisplayFormat.days:
      if (s.totalDays == 0) return compactSpan(s);
      return _plural(s.totalDays, 'day');
    case DisplayFormat.hours:
      if (s.totalHours == 0) return compactSpan(s);
      return _plural(s.totalHours, 'hour');
  }
}

/// "2y 3m 14d" — falls back to "5h 12m", then "42s" for short spans.
String compactSpan(TimeSpan s) {
  final parts = <String>[
    if (s.years > 0) '${s.years}y',
    if (s.months > 0) '${s.months}m',
    if (s.days > 0) '${s.days}d',
  ];
  if (parts.isNotEmpty) return parts.join(' ');
  if (s.hours > 0) return '${s.hours}h ${s.minutes}m';
  if (s.minutes > 0) return '${s.minutes}m ${s.seconds}s';
  return '${s.seconds}s';
}

/// Coarse form for secondary labels: "41 days", "3 hours", "2 years".
String roughSpan(TimeSpan s) {
  if (s.years > 0) return _plural(s.years, 'year');
  if (s.totalDays > 0) return _plural(s.totalDays, 'day');
  if (s.totalHours > 0) return _plural(s.totalHours, 'hour');
  if (s.totalMinutes > 0) return _plural(s.totalMinutes, 'minute');
  return _plural(s.totalSeconds, 'second');
}

/// The ticking part under the headline: "05:12:09".
String clockSpan(TimeSpan s) =>
    '${_two(s.hours)}:${_two(s.minutes)}:${_two(s.seconds)}';

/// Plain durations (streak lengths): "45d 3h", "5h 12m", "42s".
String compactDuration(Duration d) {
  if (d.inDays > 0) {
    final h = d.inHours % 24;
    return h > 0
        ? '${formatNumber(d.inDays)}d ${h}h'
        : '${formatNumber(d.inDays)}d';
  }
  if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes % 60}m';
  if (d.inMinutes > 0) return '${d.inMinutes}m ${d.inSeconds % 60}s';
  return '${d.inSeconds}s';
}
