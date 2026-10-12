import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/formatters.dart';
import '../../../service/tracker_store.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text.dart';
import '../../../widgets/app_section_header.dart';

/// Bottom sheet: how numbers are shown + how the list is sorted.
void showViewOptionsSheet() {
  final store = Get.find<TrackerStore>();
  Get.bottomSheet(
    SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenH,
          0,
          AppSpacing.screenH,
          AppSpacing.lg,
        ),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppSectionHeader('Show time as'),
              SegmentedButton<DisplayFormat>(
                showSelectedIcon: false,
                segments: [
                  for (final f in DisplayFormat.values)
                    ButtonSegment(value: f, label: Text(f.label)),
                ],
                selected: {store.format.value},
                onSelectionChanged: (s) => store.setFormat(s.first),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'e.g. ${store.format.value.example}',
                style: AppText.bodySm.copyWith(color: AppColors.textTertiary),
              ),
              const SizedBox(height: AppSpacing.xl),
              const AppSectionHeader('Sort by'),
              for (final s in SortMode.values)
                _SortRow(
                  label: s.label,
                  selected: store.sort.value == s,
                  onTap: () => store.setSort(s),
                ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Pinned items always stay on top.',
                style: AppText.bodySm.copyWith(color: AppColors.textTertiary),
              ),
            ],
          ),
        ),
      ),
    ),
    isScrollControlled: true,
  );
}

class _SortRow extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SortRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.brMd,
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: selected
                    ? AppText.body
                    : AppText.body.copyWith(color: AppColors.textSecondary),
              ),
            ),
            if (selected)
              const Icon(AppIcons.check, color: AppColors.textPrimary),
          ],
        ),
      ),
    );
  }
}
