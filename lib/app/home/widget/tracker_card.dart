import 'package:flutter/material.dart';

import '../../../core/formatters.dart';
import '../../../core/tracker_metrics.dart';
import '../../../data/model/tracker.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_pie.dart';
import '../../../widgets/tracker_type_icon.dart';

/// One tracker on the home list. Rebuilt every tick by the parent `Obx`.
class TrackerCard extends StatelessWidget {
  final TrackerMetrics m;
  final DisplayFormat format;
  final bool use24h;
  final VoidCallback onTap;

  const TrackerCard({
    super.key,
    required this.m,
    required this.format,
    this.use24h = false,
    required this.onTap,
  });

  Tracker get t => m.tracker;

  String get _overline {
    if (!m.started) return 'Starts in';
    return switch (t.type) {
      TrackerType.event => 'Since ${formatDate(t.startAt)}',
      TrackerType.age => 'Age',
      TrackerType.habit => 'Current streak',
    };
  }

  String? get _footnote {
    if (!m.started) {
      return formatDateTime(t.startAt, withTime: t.withTime, use24h: use24h);
    }
    return switch (t.type) {
      TrackerType.age => 'Turns ${m.turning} in ${roughSpan(m.untilBirthday)}',
      TrackerType.habit when t.resets.isNotEmpty =>
        m.isBestStreak
            ? 'Best streak so far'
            : 'Best ${compactDuration(m.bestStreak)}',
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(trackerTypeIcon(t.type), size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  t.title,
                  style: AppText.titleSm,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (t.pinned)
                const Icon(
                  AppIcons.pin,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(_overline.toUpperCase(), style: AppText.caption),
          const SizedBox(height: AppSpacing.xxs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  formatSpan(m.elapsed, format),
                  style: AppText.titleLg,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                clockSpan(m.elapsed),
                style: AppText.bodySm.copyWith(
                  color: AppColors.textTertiary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          if (_footnote != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(_footnote!, style: AppText.bodySm),
          ],
          if (m.hasDeadline) ...[
            const SizedBox(height: AppSpacing.md),
            _DeadlineLine(m: m),
          ],
        ],
      ),
    );
  }
}

class _DeadlineLine extends StatelessWidget {
  final TrackerMetrics m;
  const _DeadlineLine({required this.m});

  @override
  Widget build(BuildContext context) {
    final pct = ((m.progress ?? 0) * 100).floor();
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (m.overdue)
                Row(
                  children: [
                    const Icon(
                      AppIcons.warning,
                      size: 16,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Flexible(
                      child: Text(
                        'Overdue by ${compactSpan(m.overdueBy!)}',
                        style: AppText.label,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  '${compactSpan(m.remaining!)} left',
                  style: AppText.bodySm.copyWith(color: AppColors.textPrimary),
                ),
              const SizedBox(height: AppSpacing.xxs),
              Text('$pct% passed', style: AppText.bodySm),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        AppPie(value: m.progress ?? 0),
      ],
    );
  }
}
