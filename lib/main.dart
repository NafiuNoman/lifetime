import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'common/app_routes.dart';
import 'service/settings_service.dart';
import 'service/shared_pref.dart';
import 'service/tick_service.dart';
import 'service/tracker_store.dart';
import 'theme/app_colors.dart';
import 'theme/app_spacing.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPrefs().init();
  Get.put(SettingsService(), permanent: true);
  Get.put(TickService(), permanent: true);
  Get.put(TrackerStore(), permanent: true);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark, // iOS
      systemNavigationBarColor: AppColors.bgBase,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return GetMaterialApp(
      title: 'Lifetime',
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark, // app is always dark
      initialRoute: AppRoutes.homePath,
      getPages: AppRoutes.routes,
      defaultTransition: Transition.fadeIn,
      transitionDuration: reduceMotion ? Duration.zero : AppMotion.normal,
      debugShowCheckedModeBanner: false,
      // Time pickers and TimeOfDay.format follow the 12/24-hour setting.
      builder: (context, child) => Obx(
        () => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: Get.find<SettingsService>().use24h.value,
          ),
          child: child!,
        ),
      ),
    );
  }
}
