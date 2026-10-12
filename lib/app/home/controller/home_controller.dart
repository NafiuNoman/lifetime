import 'package:get/get.dart';

import '../../../common/app_routes.dart';
import '../../../core/formatters.dart';
import '../../../data/model/tracker.dart';
import '../../../service/settings_service.dart';
import '../../../service/tick_service.dart';
import '../../../service/tracker_store.dart';

class HomeController extends GetxController {
  final store = Get.find<TrackerStore>();
  final tick = Get.find<TickService>();
  final settings = Get.find<SettingsService>();

  List<Tracker> get trackers => store.sorted;
  DisplayFormat get format => store.format.value;
  bool get use24h => settings.use24h.value;

  void openAdd() => Get.toNamed(AppRoutes.editorPath);

  void openSettings() => Get.toNamed(AppRoutes.settingsPath);

  void openDetail(Tracker t) =>
      Get.toNamed(AppRoutes.detailPath, arguments: t.id);
}
