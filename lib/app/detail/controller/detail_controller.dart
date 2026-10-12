import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/app_routes.dart';
import '../../../core/tracker_metrics.dart';
import '../../../data/model/tracker.dart';
import '../../../service/settings_service.dart';
import '../../../service/tick_service.dart';
import '../../../service/tracker_store.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/app_feedback.dart';

/// Detail of one tracker. Expects the tracker id as `Get.arguments`.
class DetailController extends GetxController {
  final store = Get.find<TrackerStore>();
  final tick = Get.find<TickService>();
  final settings = Get.find<SettingsService>();
  late final String id = Get.arguments as String;

  /// Reactive: re-reads the store, so edits show up immediately.
  Tracker? get tracker => store.byId(id);

  TrackerMetrics? get metrics {
    final t = tracker;
    return t == null ? null : TrackerMetrics.of(t, tick.now.value);
  }

  void togglePin() => store.togglePin(id);

  void edit() => Get.toNamed(AppRoutes.editorPath, arguments: id);

  void openLifeGrid() => Get.toNamed(AppRoutes.lifeGridPath, arguments: id);

  Future<void> delete() async {
    final ok = await confirmDialog(
      title: 'Delete “${tracker?.title}”?',
      message: 'This removes it and its history. This can’t be undone.',
      confirmLabel: 'Delete',
      confirmIcon: AppIcons.delete,
    );
    if (!ok) return;
    Get.back();
    await store.delete(id);
    showAppSnack('Deleted');
  }

  Future<void> resetStreak() async {
    final noteCtrl = TextEditingController();
    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Reset streak?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'The current streak is saved to history and a new one '
              'starts now.',
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: noteCtrl,
              decoration: const InputDecoration(hintText: 'Note (optional)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton.icon(
            onPressed: () => Get.back(result: true),
            icon: const Icon(AppIcons.reset, size: 20),
            label: const Text('Reset'),
          ),
        ],
      ),
    );
    final note = noteCtrl.text.trim();
    noteCtrl.dispose();
    if (ok != true) return;
    await store.resetStreak(id, note: note.isEmpty ? null : note);
    showAppSnack('New streak started', status: AppStatus.info);
  }
}
