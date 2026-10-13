import 'package:flutter/material.dart';

import '../../../core/formatters.dart';
import '../../../core/life_weeks.dart';
import '../../../core/time_span.dart';
import '../../../core/tracker_metrics.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_pie.dart';
import '../../../widgets/app_progress.dart';
import '../../../widgets/app_section_header.dart';

const _tabular = [FontFeature.tabularFigures()];

/// Years · Months · Days / Hours · Minutes · Seconds grid.
class BreakdownGrid extends StatelessWidget {
  final TimeSpan span;
  const BreakdownGrid({super.key, required this.span});

  @override
  Widget build(BuildContext context) {
    final cells = [
      (span.years, 'Years'),
      (span.months, 'Months'),
      (span.days, 'Days'),
      (span.hours, 'Hours'),
      (span.minutes, 'Minutes'),
      (span.seconds, 'Seconds'),
    ];
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        children: [
          for (var row = 0; row < 2; row++) ...[
            if (row == 1) const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                for (final (value, label) in cells.skip(row * 3).take(3))
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          value.toString().padLeft(2, '0'),
                          style: AppText.titleLg.copyWith(
                            fontFeatures: _tabular,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(label.toUpperCase(), style: AppText.caption),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// "In total" list: days, weeks, hours, minutes, seconds.
class TotalsList extends StatelessWidget {
  final TimeSpan span;
  const TotalsList({super.key, required this.span});

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Months', span.totalMonths),
      ('Weeks', span.totalWeeks),
      ('Days', span.totalDays),
      ('Hours', span.totalHours),
      ('Minutes', span.totalMinutes),
      ('Seconds', span.totalSeconds),
    ];
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const Divider(indent: AppSpacing.md),
            InfoRow(label: rows[i].$1, value: formatNumber(rows[i].$2)),
          ],
        ],
      ),
    );
  }
}

/// Label on the left, value on the right; 56 high.
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Text(
                label,
                style: AppText.body.copyWith(color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: AppText.body.copyWith(fontFeatures: _tabular),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Countdown / overdue + progress between start and deadline.
class DeadlineSection extends StatelessWidget {
  final TrackerMetrics m;
  const DeadlineSection({super.key, required this.m});

  @override
  Widget build(BuildContext context) {
    final t = m.tracker;
    final span = m.overdue ? m.overdueBy! : m.remaining!;
    final pct = ((m.progress ?? 0) * 100).toStringAsFixed(1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader('Deadline'),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              m.overdue ? AppIcons.warning : AppIcons.hourglass,
                              size: 20,
                              color: m.overdue
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              m.overdue ? 'Overdue by' : 'Time left',
                              style: m.overdue ? AppText.label : AppText.bodySm,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${m.overdue ? '+' : ''}${compactSpan(span)}',
                          style: AppText.titleLg,
                        ),
                        Text(
                          clockSpan(span),
                          style: AppText.bodySm.copyWith(
                            color: AppColors.textTertiary,
                            fontFeatures: _tabular,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  AppPie(value: m.progress ?? 0, size: 72),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: Text(formatDate(t.startAt), style: AppText.caption),
                  ),
                  Text('$pct%', style: AppText.label),
                  Expanded(
                    child: Text(
                      formatDate(t.deadlineAt!),
                      style: AppText.caption,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              if (t.deadlineOffset != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${t.deadlineOffset!.label} after start',
                  style: AppText.caption,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Next birthday, age turning, weekday of birth.
class AgeSection extends StatelessWidget {
  final TrackerMetrics m;
  final VoidCallback onOpenLifeGrid;

  const AgeSection({super.key, required this.m, required this.onOpenLifeGrid});

  @override
  Widget build(BuildContext context) {
    final next = m.nextBirthday;
    final until = m.untilBirthday;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader('Birthday'),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              InfoRow(
                icon: AppIcons.age,
                label: 'Next birthday',
                value: '${formatDate(next)} · ${weekdayName(next)}',
              ),
              const Divider(indent: AppSpacing.md),
              InfoRow(
                icon: AppIcons.hourglass,
                label: 'Turning ${m.turning} in',
                value: compactSpan(until),
              ),
              const Divider(indent: AppSpacing.md),
              InfoRow(
                icon: AppIcons.calendar,
                label: 'Born on a',
                value: weekdayName(m.tracker.startAt),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _LifeWeeksCard(m: m, onTap: onOpenLifeGrid),
      ],
    );
  }
}

/// Teaser for the life-in-weeks grid.
class _LifeWeeksCard extends StatelessWidget {
  final TrackerMetrics m;
  final VoidCallback onTap;

  const _LifeWeeksCard({required this.m, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final w = LifeWeeks.of(m.tracker.startAt, m.now, m.tracker.lifeYears);
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(AppIcons.lifeGrid, size: 20),
              const SizedBox(width: AppSpacing.sm),
              const Expanded(
                child: Text('Life in weeks', style: AppText.titleSm),
              ),
              const Icon(
                AppIcons.chevron,
                size: 20,
                color: AppColors.textTertiary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${formatNumber(w.lived)} of ${formatNumber(w.total)} weeks · '
            '${(w.progress * 100).toStringAsFixed(0)}%',
            style: AppText.body,
          ),
          const SizedBox(height: AppSpacing.xs),
          AppProgress(value: w.progress),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Based on ${w.lifeYears} years. Tap to see the grid.',
            style: AppText.bodySm.copyWith(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}

/// Current vs best streak, plus the reset history.
class HabitSection extends StatelessWidget {
  final TrackerMetrics m;
  final VoidCallback onReset;

  const HabitSection({super.key, required this.m, required this.onReset});

  @override
  Widget build(BuildContext context) {
    final resets = m.tracker.resets;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader('Streak'),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              InfoRow(
                label: 'Best streak',
                value: m.isBestStreak
                    ? '${compactDuration(m.bestStreak)} · now'
                    : compactDuration(m.bestStreak),
              ),
              const Divider(indent: AppSpacing.md),
              InfoRow(label: 'Attempts', value: '${resets.length + 1}'),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: onReset,
          icon: const Icon(AppIcons.reset, size: 20),
          label: const Text('Reset streak'),
        ),
        if (resets.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          const AppSectionHeader('History'),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < resets.length; i++) ...[
                  if (i > 0) const Divider(indent: AppSpacing.md),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${formatDate(resets[i].startedAt)} – '
                                '${formatDate(resets[i].resetAt)}',
                                style: AppText.body,
                              ),
                              if (resets[i].note != null)
                                Text(resets[i].note!, style: AppText.bodySm),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          compactDuration(resets[i].length),
                          style: AppText.body.copyWith(
                            color: AppColors.textSecondary,
                            fontFeatures: _tabular,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
