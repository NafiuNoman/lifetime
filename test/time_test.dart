import 'package:flutter_test/flutter_test.dart';
import 'package:lifetime/core/formatters.dart';
import 'package:lifetime/core/life_weeks.dart';
import 'package:lifetime/core/time_span.dart';
import 'package:lifetime/core/tracker_metrics.dart';
import 'package:lifetime/data/model/tracker.dart';

Tracker _t({
  required DateTime start,
  DateTime? deadline,
  TrackerType type = TrackerType.event,
  List<StreakReset> resets = const [],
}) => Tracker(
  id: '1',
  title: 't',
  type: type,
  startAt: start,
  deadlineAt: deadline,
  createdAt: start,
  resets: resets,
);

void main() {
  group('TimeSpan.between', () {
    test('simple years / months / days', () {
      final s = TimeSpan.between(DateTime(2020, 1, 15), DateTime(2022, 4, 20));
      expect([s.years, s.months, s.days], [2, 3, 5]);
    });

    test('borrows a month when day-of-month is earlier', () {
      final s = TimeSpan.between(DateTime(2024, 1, 20), DateTime(2024, 3, 5));
      expect([s.years, s.months, s.days], [0, 1, 14]); // Feb 20 → Mar 5
    });

    test('month-end clamping: Jan 31 → Feb 29 is one month', () {
      final s = TimeSpan.between(DateTime(2024, 1, 31), DateTime(2024, 2, 29));
      expect([s.months, s.days], [1, 0]);
      final t = TimeSpan.between(DateTime(2024, 1, 31), DateTime(2024, 3, 1));
      expect([t.months, t.days], [1, 1]);
    });

    test('hours / minutes / seconds', () {
      final s = TimeSpan.between(
        DateTime(2024, 5, 1, 8, 0, 0),
        DateTime(2024, 5, 2, 10, 30, 15),
      );
      expect([s.days, s.hours, s.minutes, s.seconds], [1, 2, 30, 15]);
      expect(clockSpan(s), '02:30:15');
    });

    test('reversed range is zero', () {
      expect(TimeSpan.between(DateTime(2025), DateTime(2024)).isZero, isTrue);
    });
  });

  group('nextAnniversary', () {
    test('later this year', () {
      expect(
        nextAnniversary(DateTime(1995, 12, 1), DateTime(2026, 10, 12)),
        DateTime(2026, 12, 1),
      );
    });

    test('already passed → next year', () {
      expect(
        nextAnniversary(DateTime(1995, 3, 1), DateTime(2026, 10, 12)),
        DateTime(2027, 3, 1),
      );
    });

    test('Feb 29 falls on Feb 28 in non-leap years', () {
      expect(
        nextAnniversary(DateTime(2000, 2, 29), DateTime(2026, 1, 1)),
        DateTime(2026, 2, 28),
      );
    });
  });

  group('TrackerMetrics', () {
    test('deadline ahead: remaining + progress', () {
      final m = TrackerMetrics.of(
        _t(start: DateTime(2026, 1, 1), deadline: DateTime(2026, 1, 11)),
        DateTime(2026, 1, 6),
      );
      expect(m.overdue, isFalse);
      expect(m.remaining!.days, 5);
      expect(m.progress, closeTo(0.5, 0.001));
    });

    test('deadline passed: overdue', () {
      final m = TrackerMetrics.of(
        _t(start: DateTime(2026, 1, 1), deadline: DateTime(2026, 1, 11)),
        DateTime(2026, 1, 14),
      );
      expect(m.overdue, isTrue);
      expect(m.overdueBy!.days, 3);
      expect(m.progress, 1.0);
    });

    test('future start counts down to the start', () {
      final m = TrackerMetrics.of(
        _t(start: DateTime(2026, 2, 1)),
        DateTime(2026, 1, 1),
      );
      expect(m.started, isFalse);
      expect(m.elapsed.months, 1);
    });

    test('best streak considers history', () {
      final m = TrackerMetrics.of(
        _t(
          start: DateTime(2026, 1, 10),
          type: TrackerType.habit,
          resets: [
            StreakReset(
              startedAt: DateTime(2025, 11, 1),
              resetAt: DateTime(2026, 1, 10),
            ),
          ],
        ),
        DateTime(2026, 1, 20),
      );
      expect(m.isBestStreak, isFalse);
      expect(m.bestStreak.inDays, 70);
    });
  });

  group('formatters', () {
    test('formatTime 12h / 24h', () {
      final d = DateTime(2026, 1, 1, 21, 5);
      expect(formatTime(d), '9:05 PM');
      expect(formatTime(d, use24h: true), '21:05');
      expect(formatTime(DateTime(2026), use24h: true), '00:00');
      expect(formatTime(DateTime(2026)), '12:00 AM');
    });

    test('formatNumber', () {
      expect(formatNumber(1234567), '1,234,567');
      expect(formatNumber(999), '999');
    });

    test('formatSpan in each format', () {
      final s = TimeSpan.between(DateTime(2024, 1, 1), DateTime(2026, 4, 15));
      expect(formatSpan(s, DisplayFormat.calendar), '2y 3m 14d');
      expect(formatSpan(s, DisplayFormat.days), '835 days');
      expect(formatSpan(s, DisplayFormat.hours), '20,040 hours');
    });
  });

  group('LifeWeeks', () {
    test('counts age-years and weeks since last birthday', () {
      // 30th birthday was 2026-03-14; 2026-04-01 is 18 days later → week 2.
      final w = LifeWeeks.of(DateTime(1996, 3, 14), DateTime(2026, 4, 1), 60);
      expect(w.ageYears, 30);
      expect(w.weekOfYear, 2);
      expect(w.lived, 30 * 52 + 2);
      expect(w.total, 3120);
      expect(w.rows, 60);
      expect(w.left, 3120 - w.lived - 1);
    });

    test('last days of a year stay in box 52', () {
      final w = LifeWeeks.of(DateTime(2000, 1, 1), DateTime(2000, 12, 31), 60);
      expect([w.ageYears, w.weekOfYear], [0, 51]);
    });

    test('on a birthday the new row starts at box 1', () {
      final w = LifeWeeks.of(DateTime(2000, 5, 5), DateTime(2010, 5, 5), 60);
      expect([w.ageYears, w.weekOfYear], [10, 0]);
    });

    test('outliving the expectancy adds rows', () {
      final w = LifeWeeks.of(DateTime(1950, 1, 1), DateTime(2026, 6, 1), 60);
      expect(w.beyondExpectancy, isTrue);
      expect(w.rows, 77);
      expect(w.progress, 1.0);
      expect(w.left, 0);
    });
  });

  test('Tracker JSON round-trip', () {
    final t = _t(
      start: DateTime(2026, 1, 1, 9, 30),
      deadline: DateTime(2026, 6, 1),
      type: TrackerType.habit,
      resets: [
        StreakReset(
          startedAt: DateTime(2025, 1, 1),
          resetAt: DateTime(2025, 12, 31),
          note: 'slipped',
        ),
      ],
    );
    final back = Tracker.fromJson(t.toJson());
    expect(back.startAt, t.startAt);
    expect(back.deadlineAt, t.deadlineAt);
    expect(back.type, TrackerType.habit);
    expect(back.resets.single.note, 'slipped');
    expect(back.lifeYears, Tracker.defaultLifeYears);
    expect(Tracker.fromJson(t.copyWith(lifeYears: 85).toJson()).lifeYears, 85);
  });

  group('DeadlineOffset.addTo', () {
    test('age limit: 32 years after 2 May 1996', () {
      const o = DeadlineOffset(years: 32);
      expect(o.addTo(DateTime(1996, 5, 2)), DateTime(2028, 5, 2));
      expect(o.label, '32 years');
    });

    test('mixed period rolls over months and years', () {
      const o = DeadlineOffset(years: 1, months: 11, days: 5);
      expect(o.addTo(DateTime(2020, 3, 28)), DateTime(2022, 3, 5));
      expect(o.label, '1 year 11 months 5 days');
    });

    test('29 Feb clamps to 28 Feb in a non-leap year', () {
      const o = DeadlineOffset(years: 1);
      expect(o.addTo(DateTime(2024, 2, 29)), DateTime(2025, 2, 28));
    });

    test('round-trips through JSON on the tracker', () {
      final t = _t(
        start: DateTime(1996, 5, 2),
        deadline: DateTime(2028, 5, 2),
      ).copyWith(deadlineOffset: () => const DeadlineOffset(years: 32));
      final back = Tracker.fromJson(t.toJson());
      expect(back.deadlineOffset?.years, 32);
      expect(back.deadlineAt, DateTime(2028, 5, 2));
    });
  });
}
