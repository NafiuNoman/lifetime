import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/formatters.dart';
import '../../../core/life_weeks.dart';
import '../../../data/model/tracker.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_section_header.dart';
import '../controller/life_grid_controller.dart';
import '../widget/life_grid_painter.dart';

class LifeGridScreen extends GetView<LifeGridController> {
  const LifeGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: Get.back,
          icon: const Icon(AppIcons.back, size: 24),
        ),
        title: const Text('Life in weeks'),
      ),
      body: SafeArea(
        child: Obx(() {
          final w = controller.weeks;
          if (w == null) return const SizedBox.shrink();
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              AppSpacing.xs,
              AppSpacing.screenH,
              AppSpacing.xxl,
            ),
            children: [
              _Summary(w: w),
              const SizedBox(height: AppSpacing.lg),
              const _Legend(),
              const SizedBox(height: AppSpacing.md),
              LayoutBuilder(
                builder: (_, box) {
                  final height = LifeGridPainter.heightFor(
                    box.maxWidth,
                    w.rows,
                  );
                  return Semantics(
                    label:
                        'Life grid: ${formatNumber(w.lived)} of '
                        '${formatNumber(w.total)} weeks lived',
                    child: CustomPaint(
                      size: Size(box.maxWidth, height),
                      painter: LifeGridPainter(w),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              _ExpectancyCard(controller: controller),
            ],
          );
        }),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final LifeWeeks w;
  const _Summary({required this.w});

  @override
  Widget build(BuildContext context) {
    final pct = (w.progress * 100).toStringAsFixed(1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('WEEKS LIVED', style: AppText.caption),
        const SizedBox(height: AppSpacing.xxs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(formatNumber(w.lived), style: AppText.display),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '/ ${formatNumber(w.total)}',
              style: AppText.titleSm.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          w.beyondExpectancy
              ? 'Past ${w.lifeYears} years: every week is a bonus.'
              : '$pct% · ${formatNumber(w.left)} weeks ahead '
                    'until ${w.lifeYears}',
          style: AppText.bodySm,
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    Widget item(Widget box, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        box,
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: AppText.bodySm),
      ],
    );
    Widget swatch({Color? fill, bool outline = false}) => Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(2),
        border: outline ? Border.all(color: AppColors.accent) : null,
      ),
    );

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      children: [
        item(swatch(fill: AppColors.textPrimary), 'Lived'),
        item(swatch(outline: true), 'This week'),
        item(swatch(fill: AppColors.bgHighest), 'Ahead'),
        Text(
          '1 row = 1 year',
          style: AppText.bodySm.copyWith(color: AppColors.textTertiary),
        ),
      ],
    );
  }
}

class _ExpectancyCard extends StatelessWidget {
  final LifeGridController controller;
  const _ExpectancyCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final years = controller.lifeYears.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader('Life expectancy'),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Draw the grid for',
                      style: AppText.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Text('$years years', style: AppText.titleSm),
                ],
              ),
              Slider(
                value: years.toDouble(),
                min: Tracker.minLifeYears.toDouble(),
                max: Tracker.maxLifeYears.toDouble(),
                divisions: Tracker.maxLifeYears - Tracker.minLifeYears,
                label: '$years',
                onChanged: controller.onSlide,
                onChangeEnd: controller.onSlideEnd,
              ),
              Row(
                children: [
                  Text('${Tracker.minLifeYears}', style: AppText.caption),
                  const Spacer(),
                  Text('${Tracker.maxLifeYears}', style: AppText.caption),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
