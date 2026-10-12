import 'package:get/get.dart';
import 'package:lifetime/app/detail/controller/detail_binding.dart';
import 'package:lifetime/app/detail/page/detail_screen.dart';
import 'package:lifetime/app/editor/controller/editor_binding.dart';
import 'package:lifetime/app/editor/page/editor_screen.dart';
import 'package:lifetime/app/home/controller/home_binding.dart';
import 'package:lifetime/app/home/page/home_screen.dart';
import 'package:lifetime/app/life_grid/controller/life_grid_binding.dart';
import 'package:lifetime/app/life_grid/page/life_grid_screen.dart';
import 'package:lifetime/app/settings/controller/settings_binding.dart';
import 'package:lifetime/app/settings/page/settings_screen.dart';

class AppRoutes {
  static const String homePath = '/home_path';
  static const String editorPath = '/editor_path';
  static const String detailPath = '/detail_path';
  static const String lifeGridPath = '/life_grid_path';
  static const String settingsPath = '/settings_path';

  static final routes = [
    GetPage(
      name: homePath,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: editorPath,
      page: () => const EditorScreen(),
      binding: EditorBinding(),
      fullscreenDialog: true,
    ),
    GetPage(
      name: detailPath,
      page: () => const DetailScreen(),
      binding: DetailBinding(),
    ),
    GetPage(
      name: lifeGridPath,
      page: () => const LifeGridScreen(),
      binding: LifeGridBinding(),
    ),
    GetPage(
      name: settingsPath,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),
  ];
}
