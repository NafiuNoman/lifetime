import 'dart:async';

import 'package:get/get.dart';

/// A single app-wide clock that ticks once per second.
/// Widgets read [now] inside `Obx` to update live without their own timers.
class TickService extends GetxService {
  final now = DateTime.now().obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      now.value = DateTime.now();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
