import '../data/model/tracker.dart';
import 'time_span.dart';

/// Everything the UI shows about a tracker at a given moment.
/// Pure and cheap: recomputed every tick from (tracker, now).
class TrackerMetrics {
  final Tracker tracker;
  final DateTime now;

  /// True once [Tracker.startAt] is in the past.
  final bool started;

  /// Time since start, or time until start when [started] is false.
  final TimeSpan elapsed;

  /// Countdown to the deadline (zero once overdue). Null without a deadline.
  final TimeSpan? remaining;

  /// How long the deadline has passed. Null unless [overdue].
  final TimeSpan? overdueBy;

  /// 0..1 share of start→deadline already passed. Null without a deadline.
  final double? progress;

  const TrackerMetrics._({
    required this.tracker,
    required this.now,
    required this.started,
    required this.elapsed,
    this.remaining,
    this.overdueBy,
    this.progress,
  });

  factory TrackerMetrics.of(Tracker t, DateTime now) {
    final started = !now.isBefore(t.startAt);
    final elapsed = started
        ? TimeSpan.between(t.startAt, now)
        : TimeSpan.between(now, t.startAt);

    final deadline = t.deadlineAt;
    if (deadline == null) {
      return TrackerMetrics._(
        tracker: t,
        now: now,
        started: started,
        elapsed: elapsed,
      );
    }

    final isOverdue = now.isAfter(deadline);
    final window = deadline.difference(t.startAt).inSeconds;
    final passed = now.difference(t.startAt).inSeconds;
    final progress = window <= 0
        ? 1.0
        : (passed / window).clamp(0.0, 1.0).toDouble();

    return TrackerMetrics._(
      tracker: t,
      now: now,
      started: started,
      elapsed: elapsed,
      remaining: isOverdue ? TimeSpan.zero : TimeSpan.between(now, deadline),
      overdueBy: isOverdue ? TimeSpan.between(deadline, now) : null,
      progress: progress,
    );
  }

  bool get hasDeadline => tracker.deadlineAt != null;
  bool get overdue => overdueBy != null;

  // ── Age ──
  DateTime get nextBirthday => nextAnniversary(tracker.startAt, now);
  TimeSpan get untilBirthday => TimeSpan.between(now, nextBirthday);
  int get turning => nextBirthday.year - tracker.startAt.year;

  // ── Habit ──
  /// Longest streak including the current one.
  Duration get bestStreak {
    var best = started ? now.difference(tracker.startAt) : Duration.zero;
    for (final r in tracker.resets) {
      if (r.length > best) best = r.length;
    }
    return best;
  }

  bool get isBestStreak =>
      started &&
      tracker.resets.every((r) => now.difference(tracker.startAt) >= r.length);
}
