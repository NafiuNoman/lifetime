/// What kind of date a tracker counts from. Changes labels and extra sections.
enum TrackerType {
  event('Event', 'Time since (or until) any moment.'),
  age('Age', 'Your exact age and the next birthday.'),
  habit('Habit', 'A streak you can reset. Best streak is kept.');

  final String label;
  final String hint;
  const TrackerType(this.label, this.hint);

  static TrackerType parse(String? v) =>
      values.firstWhere((t) => t.name == v, orElse: () => event);
}

/// One finished habit streak, saved when the user taps "Reset streak".
class StreakReset {
  final DateTime startedAt;
  final DateTime resetAt;
  final String? note;

  const StreakReset({
    required this.startedAt,
    required this.resetAt,
    this.note,
  });

  Duration get length => resetAt.difference(startedAt);

  Map<String, dynamic> toJson() => {
    'startedAt': startedAt.toIso8601String(),
    'resetAt': resetAt.toIso8601String(),
    if (note != null) 'note': note,
  };

  factory StreakReset.fromJson(Map<String, dynamic> j) => StreakReset(
    startedAt: DateTime.parse(j['startedAt'] as String),
    resetAt: DateTime.parse(j['resetAt'] as String),
    note: j['note'] as String?,
  );
}

/// A deadline given as a period after the start, e.g. "32 years" for an
/// age limit. Stored so the deadline follows the start date when edited.
class DeadlineOffset {
  final int years;
  final int months;
  final int days;

  const DeadlineOffset({this.years = 0, this.months = 0, this.days = 0});

  bool get isEmpty => years == 0 && months == 0 && days == 0;

  /// Calendar addition. A day past the month's end clamps to its last day
  /// (29 Feb + 1 year → 28 Feb).
  DateTime addTo(DateTime d) {
    final totalMonths = d.month - 1 + months + years * 12;
    final y = d.year + totalMonths ~/ 12;
    final m = totalMonths % 12 + 1;
    final lastDay = DateTime(y, m + 1, 0).day;
    final day = (d.day > lastDay ? lastDay : d.day) + days;
    return DateTime(y, m, day, d.hour, d.minute);
  }

  /// "32 years", "1 year 6 months", "10 days"
  String get label {
    String part(int n, String unit) => '$n $unit${n == 1 ? '' : 's'}';
    return [
      if (years > 0) part(years, 'year'),
      if (months > 0) part(months, 'month'),
      if (days > 0) part(days, 'day'),
    ].join(' ');
  }

  Map<String, dynamic> toJson() => {
    'years': years,
    'months': months,
    'days': days,
  };

  factory DeadlineOffset.fromJson(Map<String, dynamic> j) => DeadlineOffset(
    years: j['years'] as int? ?? 0,
    months: j['months'] as int? ?? 0,
    days: j['days'] as int? ?? 0,
  );
}

/// A single tracked date: elapsed since [startAt], optionally counting down
/// to [deadlineAt] (and showing "overdue" once it passes).
class Tracker {
  final String id;
  final String title;
  final TrackerType type;
  final DateTime startAt;
  final DateTime? deadlineAt;

  /// Set when the deadline was entered as a period after [startAt].
  final DeadlineOffset? deadlineOffset;

  /// Whether the user picked times, or just dates (shown as dates only).
  final bool withTime;
  final bool pinned;
  final String? note;
  final DateTime createdAt;
  final List<StreakReset> resets;

  /// Age only: life expectancy for the "life in weeks" grid.
  final int lifeYears;

  static const defaultLifeYears = 60;
  static const minLifeYears = 30;
  static const maxLifeYears = 100;

  const Tracker({
    required this.id,
    required this.title,
    required this.type,
    required this.startAt,
    this.deadlineAt,
    this.deadlineOffset,
    this.withTime = false,
    this.pinned = false,
    this.note,
    required this.createdAt,
    this.resets = const [],
    this.lifeYears = defaultLifeYears,
  });

  Tracker copyWith({
    String? title,
    TrackerType? type,
    DateTime? startAt,
    DateTime? Function()? deadlineAt,
    DeadlineOffset? Function()? deadlineOffset,
    bool? withTime,
    bool? pinned,
    String? Function()? note,
    List<StreakReset>? resets,
    int? lifeYears,
  }) => Tracker(
    id: id,
    title: title ?? this.title,
    type: type ?? this.type,
    startAt: startAt ?? this.startAt,
    deadlineAt: deadlineAt != null ? deadlineAt() : this.deadlineAt,
    deadlineOffset: deadlineOffset != null
        ? deadlineOffset()
        : this.deadlineOffset,
    withTime: withTime ?? this.withTime,
    pinned: pinned ?? this.pinned,
    note: note != null ? note() : this.note,
    createdAt: createdAt,
    resets: resets ?? this.resets,
    lifeYears: lifeYears ?? this.lifeYears,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'type': type.name,
    'startAt': startAt.toIso8601String(),
    if (deadlineAt != null) 'deadlineAt': deadlineAt!.toIso8601String(),
    if (deadlineOffset != null) 'deadlineOffset': deadlineOffset!.toJson(),
    'withTime': withTime,
    'pinned': pinned,
    if (note != null) 'note': note,
    'createdAt': createdAt.toIso8601String(),
    'resets': resets.map((r) => r.toJson()).toList(),
    'lifeYears': lifeYears,
  };

  factory Tracker.fromJson(Map<String, dynamic> j) => Tracker(
    id: j['id'] as String,
    title: j['title'] as String,
    type: TrackerType.parse(j['type'] as String?),
    startAt: DateTime.parse(j['startAt'] as String),
    deadlineAt: j['deadlineAt'] == null
        ? null
        : DateTime.parse(j['deadlineAt'] as String),
    deadlineOffset: j['deadlineOffset'] == null
        ? null
        : DeadlineOffset.fromJson(
            Map<String, dynamic>.from(j['deadlineOffset'] as Map),
          ),
    withTime: j['withTime'] as bool? ?? false,
    pinned: j['pinned'] as bool? ?? false,
    note: j['note'] as String?,
    createdAt: DateTime.parse(j['createdAt'] as String),
    resets: (j['resets'] as List? ?? const [])
        .map((r) => StreakReset.fromJson(Map<String, dynamic>.from(r)))
        .toList(),
    lifeYears: j['lifeYears'] as int? ?? defaultLifeYears,
  );
}
