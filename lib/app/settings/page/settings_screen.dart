import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/formatters.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_section_header.dart';
import '../controller/settings_controller.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: Get.back,
          icon: const Icon(AppIcons.back, size: 24),
        ),
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: Obx(() {
          final sample = DateTime(2000, 1, 1, 21, 5);
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              AppSpacing.xs,
              AppSpacing.screenH,
              AppSpacing.xxl,
            ),
            children: [
              const AppSectionHeader('Time'),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(AppIcons.clock, size: 20),
                        const SizedBox(width: AppSpacing.sm),
                        const Expanded(
                          child: Text('Time format', style: AppText.body),
                        ),
                        Text(
                          formatTime(sample, use24h: controller.use24h),
                          style: AppText.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SegmentedButton<bool>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(value: false, label: Text('12-hour')),
                        ButtonSegment(value: true, label: Text('24-hour')),
                      ],
                      selected: {controller.use24h},
                      onSelectionChanged: (s) => controller.setUse24h(s.first),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Used for start times, deadlines and the time picker.',
                style: AppText.bodySm.copyWith(color: AppColors.textTertiary),
              ),
            ],
          );
        }),
      ),
    );
  }
}
