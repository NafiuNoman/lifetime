import 'package:get/get.dart';

import '../../../service/settings_service.dart';

class SettingsController extends GetxController {
  final settings = Get.find<SettingsService>();

  bool get use24h => settings.use24h.value;

  void setUse24h(bool v) => settings.setUse24h(v);
}
