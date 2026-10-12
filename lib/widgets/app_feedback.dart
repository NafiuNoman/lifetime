import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';

/// Status without color (DESIGN_SYSTEM.md §3): always an icon + words.
enum AppStatus {
  success(AppIcons.success),
  error(AppIcons.error),
  warning(AppIcons.warning),
  info(AppIcons.info);

  final IconData icon;
  const AppStatus(this.icon);
}

/// Toast on bg.highest with a leading status icon.
void showAppSnack(String message, {AppStatus status = AppStatus.success}) {
  final context = Get.context;
  if (context == null) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            Icon(status.icon, color: AppColors.textPrimary, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(message, style: AppText.body)),
          ],
        ),
      ),
    );
}

/// Inline error under a field: icon + text-primary message.
class AppFieldError extends StatelessWidget {
  final String message;
  const AppFieldError(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        children: [
          const Icon(AppIcons.error, size: 16, color: AppColors.textPrimary),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              message,
              style: AppText.bodySm.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

/// Confirmation dialog. Destructive confirms use a bold label + icon, never color.
Future<bool> confirmDialog({
  required String title,
  required String message,
  required String confirmLabel,
  IconData? confirmIcon,
}) async {
  final result = await Get.dialog<bool>(
    AlertDialog(
      title: Text(title),
      content: Text(
        message,
        style: AppText.body.copyWith(color: AppColors.textSecondary),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text('Cancel'),
        ),
        TextButton.icon(
          onPressed: () => Get.back(result: true),
          icon: confirmIcon == null ? null : Icon(confirmIcon, size: 20),
          label: Text(confirmLabel),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            textStyle: AppText.label.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}
