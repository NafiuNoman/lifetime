import 'package:get/get.dart';

import 'shared_pref.dart';

/// App-wide preferences shown on the Settings screen.
class SettingsService extends GetxService {
  final _prefs = SharedPrefs();

  /// 24-hour clock ("21:05") instead of 12-hour ("9:05 PM").
  final use24h = false.obs;

  @override
  void onInit() {
    super.onInit();
    use24h.value = _prefs.getBool(SharedPrefs.use24h) ?? false;
  }

  void setUse24h(bool v) {
    use24h.value = v;
    _prefs.saveBool(SharedPrefs.use24h, v);
  }
}
