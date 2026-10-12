import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/tracker_metrics.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text.dart';
import '../../../widgets/app_icon_menu.dart';
import '../controller/home_controller.dart';
import '../widget/tracker_card.dart';
import '../widget/view_options_sheet.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppSpacing.screenH,
        title: const Text('Lifetime', style: AppText.titleLg),
        actions: [
          AppIconMenu(
            items: [
              AppIconMenuItem(
                icon: AppIcons.add,
                label: 'Add date',
                onTap: controller.openAdd,
              ),
              const AppIconMenuItem(
                icon: AppIcons.sort,
                label: 'Sort and display',
                onTap: showViewOptionsSheet,
              ),
              AppIconMenuItem(
                icon: AppIcons.settings,
                label: 'Settings',
                onTap: controller.openSettings,
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final trackers = controller.trackers;
          if (trackers.isEmpty) return _EmptyState(onAdd: controller.openAdd);

          final now = controller.tick.now.value;
          final format = controller.format;
          final use24h = controller.use24h;
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              AppSpacing.xs,
              AppSpacing.screenH,
              AppSpacing.xxl,
            ),
            itemCount: trackers.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (_, i) => TrackerCard(
              m: TrackerMetrics.of(trackers[i], now),
              format: format,
              use24h: use24h,
              onTap: () => controller.openDetail(trackers[i]),
            ),
          );
        }),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(AppIcons.empty, size: 40, color: AppColors.textTertiary),
          const SizedBox(height: AppSpacing.lg),
          const Text('Nothing tracked yet', style: AppText.titleMd),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Pick any date to see how much time has passed, '
            'or how much is left until a deadline.',
            style: AppText.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(AppIcons.add, size: 20),
            label: const Text('Add your first date'),
          ),
        ],
      ),
    );
  }
}
