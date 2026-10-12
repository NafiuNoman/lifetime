import 'package:get/get.dart';

import '../../../core/life_weeks.dart';
import '../../../data/model/tracker.dart';
import '../../../service/tracker_store.dart';

/// Life-in-weeks grid for an Age tracker. Expects the tracker id as arguments.
class LifeGridController extends GetxController {
  final store = Get.find<TrackerStore>();
  late final String id = Get.arguments as String;

  /// Live slider value; persisted on release.
  late final lifeYears =
      (store.byId(id)?.lifeYears ?? Tracker.defaultLifeYears).obs;

  Tracker? get tracker => store.byId(id);

  /// Recomputed on build; the grid only changes once a week, so no ticking.
  LifeWeeks? get weeks {
    final t = tracker;
    if (t == null) return null;
    return LifeWeeks.of(t.startAt, DateTime.now(), lifeYears.value);
  }

  void onSlide(double v) => lifeYears.value = v.round();

  void onSlideEnd(double v) => store.setLifeYears(id, v.round());
}
