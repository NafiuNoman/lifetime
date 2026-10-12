import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/formatters.dart';
import '../../../core/tracker_metrics.dart';
import '../../../data/model/tracker.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text.dart';
import '../../../widgets/app_icon_menu.dart';
import '../../../widgets/app_section_header.dart';
import '../../../widgets/tracker_type_icon.dart';
import '../controller/detail_controller.dart';
import '../widget/detail_sections.dart';

class DetailScreen extends GetView<DetailController> {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final m = controller.metrics;
      // Deleted while open: render nothing while the route pops.
      if (m == null) return const Scaffold();
      final t = m.tracker;

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Back',
            onPressed: Get.back,
            icon: const Icon(AppIcons.back, size: 24),
          ),
          actions: [
            AppIconMenu(
              items: [
                AppIconMenuItem(
                  icon: t.pinned ? AppIcons.unpin : AppIcons.pin,
                  label: t.pinned ? 'Unpin' : 'Pin to top',
                  onTap: controller.togglePin,
                ),
                AppIconMenuItem(
                  icon: AppIcons.edit,
                  label: 'Edit',
                  onTap: controller.edit,
                ),
                AppIconMenuItem(
                  icon: AppIcons.delete,
                  label: 'Delete',
                  onTap: controller.delete,
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              AppSpacing.xs,
              AppSpacing.screenH,
              AppSpacing.xxl,
            ),
            children: [
              _Header(m: m, use24h: controller.settings.use24h.value),
              const SizedBox(height: AppSpacing.xl),
              AppSectionHeader(m.started ? 'Breakdown' : 'Starts in'),
              BreakdownGrid(span: m.elapsed),
              if (m.hasDeadline) ...[
                const SizedBox(height: AppSpacing.xl),
                DeadlineSection(m: m),
              ],
              if (t.type == TrackerType.age && m.started) ...[
                const SizedBox(height: AppSpacing.xl),
                AgeSection(m: m, onOpenLifeGrid: controller.openLifeGrid),
              ],
              if (t.type == TrackerType.habit && m.started) ...[
                const SizedBox(height: AppSpacing.xl),
                HabitSection(m: m, onReset: controller.resetStreak),
              ],
              const SizedBox(height: AppSpacing.xl),
              const AppSectionHeader('In total'),
              TotalsList(span: m.elapsed),
              if (t.note != null) ...[
                const SizedBox(height: AppSpacing.xl),
                const AppSectionHeader('Note'),
                Text(
                  t.note!,
                  style: AppText.body.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}

class _Header extends StatelessWidget {
  final TrackerMetrics m;
  final bool use24h;
  const _Header({required this.m, required this.use24h});

  @override
  Widget build(BuildContext context) {
    final t = m.tracker;
    final overline = !m.started
        ? 'Starts in'
        : switch (t.type) {
            TrackerType.event => 'Elapsed',
            TrackerType.age => 'Age',
            TrackerType.habit => 'Current streak',
          };
    final dateLabel = t.type == TrackerType.age ? 'Born' : 'From';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              trackerTypeIcon(t.type),
              size: 16,
              color: AppColors.textTertiary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(t.type.label.toUpperCase(), style: AppText.caption),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(t.title, style: AppText.titleLg),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          '$dateLabel ${formatDateTime(t.startAt, withTime: t.withTime, use24h: use24h)}',
          style: AppText.bodySm,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(overline.toUpperCase(), style: AppText.caption),
        const SizedBox(height: AppSpacing.xxs),
        Text(compactSpan(m.elapsed), style: AppText.display),
        Text(
          clockSpan(m.elapsed),
          style: AppText.titleSm.copyWith(
            color: AppColors.textSecondary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
