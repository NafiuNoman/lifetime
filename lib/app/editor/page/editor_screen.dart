import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/formatters.dart';
import '../../../data/model/tracker.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text.dart';
import '../../../widgets/app_feedback.dart';
import '../../../widgets/app_field.dart';
import '../../../widgets/tracker_type_icon.dart';
import '../controller/editor_controller.dart';

class EditorScreen extends GetView<EditorController> {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Close',
          onPressed: Get.back,
          icon: const Icon(AppIcons.close, size: 24),
        ),
        title: Text(c.isEditing ? 'Edit' : 'New date'),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Obx(
            () => ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                AppSpacing.xs,
                AppSpacing.screenH,
                AppSpacing.xl,
              ),
              children: [
                // ── Type ──
                const AppFieldLabel('Type'),
                SegmentedButton<TrackerType>(
                  showSelectedIcon: false,
                  segments: [
                    for (final t in TrackerType.values)
                      ButtonSegment(
                        value: t,
                        label: Text(t.label),
                        icon: Icon(trackerTypeIcon(t), size: 20),
                      ),
                  ],
                  selected: {c.type.value},
                  onSelectionChanged: (s) => c.setType(s.first),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  c.type.value.hint,
                  style: AppText.bodySm.copyWith(color: AppColors.textTertiary),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Title ──
                const AppFieldLabel('Title'),
                TextField(
                  controller: c.titleCtrl,
                  style: AppText.body,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: c.titleHint,
                    enabledBorder: c.titleError.value == null
                        ? null
                        : Theme.of(context).inputDecorationTheme.errorBorder,
                  ),
                  onChanged: (_) => c.titleError.value = null,
                ),
                if (c.titleError.value != null)
                  AppFieldError(c.titleError.value!),
                const SizedBox(height: AppSpacing.lg),

                // ── Start ──
                AppFieldLabel(c.startLabel),
                AppPickerField(
                  icon: AppIcons.calendar,
                  value: c.startDate.value == null
                      ? null
                      : formatDate(c.startDate.value!),
                  placeholder: 'Pick a date',
                  hasError: c.startError.value != null,
                  onTap: () => c.pickStartDate(context),
                ),
                if (c.withTime.value) ...[
                  const SizedBox(height: AppSpacing.xs),
                  AppPickerField(
                    icon: AppIcons.clock,
                    value: c.startTime.value?.format(context),
                    placeholder: c.timePlaceholder,
                    onTap: () => c.pickStartTime(context),
                  ),
                ],
                if (c.startError.value != null)
                  AppFieldError(c.startError.value!),
                const SizedBox(height: AppSpacing.xs),
                AppSwitchRow(
                  title: 'Include time',
                  subtitle: 'Track to the exact minute',
                  value: c.withTime.value,
                  onChanged: (v) => c.withTime.value = v,
                ),

                // ── Deadline ──
                if (c.deadlineAllowed) ...[
                  const Divider(height: AppSpacing.lg),
                  AppSwitchRow(
                    title: 'Deadline',
                    subtitle: 'Also count down, and show overdue time',
                    value: c.hasDeadline.value,
                    onChanged: (v) {
                      c.hasDeadline.value = v;
                      c.deadlineError.value = null;
                    },
                  ),
                  if (c.hasDeadline.value) ...[
                    const SizedBox(height: AppSpacing.xs),
                    SegmentedButton<bool>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(
                          value: false,
                          label: Text('On a date'),
                          icon: Icon(AppIcons.calendar, size: 20),
                        ),
                        ButtonSegment(
                          value: true,
                          label: Text('After a period'),
                          icon: Icon(AppIcons.hourglass, size: 20),
                        ),
                      ],
                      selected: {c.deadlineByPeriod.value},
                      onSelectionChanged: (s) {
                        c.deadlineByPeriod.value = s.first;
                        c.deadlineError.value = null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  if (c.hasDeadline.value && c.deadlineByPeriod.value) ...[
                    Row(
                      children: [
                        _PeriodField(
                          label: 'Years',
                          ctrl: c.yearsCtrl,
                          hasError: c.deadlineError.value != null,
                          onChanged: c.onPeriodChanged,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _PeriodField(
                          label: 'Months',
                          ctrl: c.monthsCtrl,
                          hasError: c.deadlineError.value != null,
                          onChanged: c.onPeriodChanged,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _PeriodField(
                          label: 'Days',
                          ctrl: c.daysCtrl,
                          hasError: c.deadlineError.value != null,
                          onChanged: c.onPeriodChanged,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      c.periodDeadline == null
                          ? 'Counted from the ${c.startLabel.toLowerCase()}, '
                                'e.g. 32 years from date of birth.'
                          : 'Ends on ${formatDate(c.periodDeadline!)} '
                                '(${c.period.value.label} after '
                                '${formatDate(c.startDate.value!)})',
                      style: AppText.bodySm.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    if (c.deadlineError.value != null)
                      AppFieldError(c.deadlineError.value!),
                  ],
                  if (c.hasDeadline.value && !c.deadlineByPeriod.value) ...[
                    AppPickerField(
                      icon: AppIcons.hourglass,
                      value: c.deadlineDate.value == null
                          ? null
                          : formatDate(c.deadlineDate.value!),
                      placeholder: 'Pick a deadline date',
                      hasError: c.deadlineError.value != null,
                      onTap: () => c.pickDeadlineDate(context),
                    ),
                    if (c.withTime.value) ...[
                      const SizedBox(height: AppSpacing.xs),
                      AppPickerField(
                        icon: AppIcons.clock,
                        value: c.deadlineTime.value?.format(context),
                        placeholder: c.timePlaceholder,
                        onTap: () => c.pickDeadlineTime(context),
                      ),
                    ],
                    if (c.deadlineError.value != null)
                      AppFieldError(c.deadlineError.value!),
                  ],
                ],
                const SizedBox(height: AppSpacing.lg),

                // ── Note ──
                const AppFieldLabel('Note (optional)'),
                TextField(
                  controller: c.noteCtrl,
                  style: AppText.body,
                  minLines: 2,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(hintText: 'Why it matters'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenH,
            AppSpacing.xs,
            AppSpacing.screenH,
            AppSpacing.md,
          ),
          child: FilledButton(
            onPressed: c.save,
            child: Text(c.isEditing ? 'Save changes' : 'Add'),
          ),
        ),
      ),
    );
  }
}

/// One numeric box (Years / Months / Days) of a period deadline.
class _PeriodField extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final bool hasError;
  final VoidCallback onChanged;

  const _PeriodField({
    required this.label,
    required this.ctrl,
    required this.hasError,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppFieldLabel(label),
          TextField(
            controller: ctrl,
            style: AppText.body,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            decoration: InputDecoration(
              hintText: '0',
              enabledBorder: hasError
                  ? Theme.of(context).inputDecorationTheme.errorBorder
                  : null,
            ),
            onChanged: (_) => onChanged(),
          ),
        ],
      ),
    );
  }
}
