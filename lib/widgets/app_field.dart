import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';

/// Label above a field, in body.sm / text.secondary.
class AppFieldLabel extends StatelessWidget {
  final String text;
  const AppFieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
    child: Text(text, style: AppText.bodySm),
  );
}

/// Input-styled tappable box that opens a picker (date, time).
class AppPickerField extends StatelessWidget {
  final IconData icon;
  final String? value;
  final String placeholder;
  final VoidCallback onTap;
  final bool hasError;

  const AppPickerField({
    super.key,
    required this.icon,
    required this.value,
    required this.placeholder,
    required this.onTap,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgOverlay,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.brMd,
        side: hasError
            ? const BorderSide(color: AppColors.borderFocus, width: 1.5)
            : const BorderSide(color: AppColors.borderDefault),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.brMd,
        child: SizedBox(
          height: 48,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Icon(icon, size: 20, color: AppColors.textSecondary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    value ?? placeholder,
                    style: value == null
                        ? AppText.body.copyWith(color: AppColors.textTertiary)
                        : AppText.body,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A full-width row with a label, optional caption and a switch.
class AppSwitchRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppSwitchRow({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: AppRadius.brMd,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: AppText.body),
                  if (subtitle != null) Text(subtitle!, style: AppText.bodySm),
                ],
              ),
            ),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
