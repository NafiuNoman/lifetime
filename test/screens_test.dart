import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:lifetime/common/app_routes.dart';
import 'package:lifetime/data/model/tracker.dart';
import 'package:lifetime/service/settings_service.dart';
import 'package:lifetime/service/shared_pref.dart';
import 'package:lifetime/service/tick_service.dart';
import 'package:lifetime/service/tracker_store.dart';
import 'package:lifetime/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Renders each screen on a phone-sized surface; fails on overflow/exceptions.
Future<void> _pump(WidgetTester tester, String route, {Object? args}) async {
  tester.view.physicalSize = const Size(393 * 3, 852 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    GetMaterialApp(
      theme: AppTheme.dark,
      initialRoute: AppRoutes.homePath,
      getPages: AppRoutes.routes,
    ),
  );
  if (route != AppRoutes.homePath) {
    Get.toNamed(route, arguments: args);
  }
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPrefs().init();
    Get.reset();
    Get.put(SettingsService(), permanent: true);
    Get.put(TickService(), permanent: true);
    final store = Get.put(TrackerStore(), permanent: true);
    final now = DateTime.now();
    await store.upsert(
      Tracker(
        id: 'h',
        title: 'No sugar',
        type: TrackerType.habit,
        startAt: now.subtract(const Duration(days: 10)),
        deadlineAt: now.add(const Duration(days: 20)),
        createdAt: now,
        resets: [
          StreakReset(
            startedAt: now.subtract(const Duration(days: 60)),
            resetAt: now.subtract(const Duration(days: 10)),
            note: 'Cake',
          ),
        ],
      ),
    );
    await store.upsert(
      Tracker(
        id: 'a',
        title: 'My age',
        type: TrackerType.age,
        startAt: DateTime(1996, 3, 14),
        createdAt: now,
      ),
    );
  });

  tearDown(() => Get.find<TickService>().onClose());

  testWidgets('home renders cards', (tester) async {
    await _pump(tester, AppRoutes.homePath);
    expect(find.text('No sugar'), findsOneWidget);
    expect(find.text('My age'), findsOneWidget);
  });

  testWidgets('home actions live in the app bar menu (icons only)', (
    tester,
  ) async {
    await _pump(tester, AppRoutes.homePath);
    expect(find.text('Add date'), findsNothing);

    await tester.tap(find.byTooltip('Options'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Sort and display'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Add date'));
    await tester.pumpAndSettle();
    expect(find.text('New date'), findsOneWidget);
  });

  testWidgets('settings: switching to 24-hour updates times', (tester) async {
    await _pump(tester, AppRoutes.homePath);
    await tester.tap(find.byTooltip('Options'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('9:05 PM'), findsOneWidget);
    await tester.tap(find.text('24-hour'));
    await tester.pumpAndSettle();
    expect(find.text('21:05'), findsOneWidget);
    expect(Get.find<SettingsService>().use24h.value, isTrue);
    expect(SharedPrefs().getBool(SharedPrefs.use24h), isTrue);
  });

  testWidgets('habit detail renders all sections', (tester) async {
    await _pump(tester, AppRoutes.detailPath, args: 'h');
    expect(find.text('CURRENT STREAK'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Reset streak'), 200);
    await tester.scrollUntilVisible(find.text('Cake'), 200);
  });

  testWidgets('detail actions live in the app bar menu (icons only)', (
    tester,
  ) async {
    await _pump(tester, AppRoutes.detailPath, args: 'h');
    expect(find.text('Delete'), findsNothing);

    await tester.tap(find.byTooltip('Options'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Pin to top'), findsOneWidget);
    expect(find.bySemanticsLabel('Edit'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Delete “No sugar”?'), findsOneWidget);
  });

  testWidgets('age detail shows birthday', (tester) async {
    await _pump(tester, AppRoutes.detailPath, args: 'a');
    await tester.scrollUntilVisible(find.text('Next birthday'), 200);
  });

  testWidgets('life grid renders and slider updates expectancy', (
    tester,
  ) async {
    await _pump(tester, AppRoutes.detailPath, args: 'a');
    await tester.scrollUntilVisible(find.text('Life in weeks'), 200);
    expect(find.textContaining('Based on 60 years'), findsOneWidget);

    Get.toNamed(AppRoutes.lifeGridPath, arguments: 'a');
    await tester.pumpAndSettle();
    expect(find.textContaining('/ 3,120'), findsOneWidget);

    await tester.scrollUntilVisible(find.byType(Slider), 200);
    await tester.drag(find.byType(Slider), const Offset(2000, 0));
    await tester.pumpAndSettle();
    // The grid grew by 40 rows, so the card may now be below the fold.
    expect(find.text('100 years', skipOffstage: false), findsOneWidget);
    expect(find.textContaining('/ 5,200'), findsOneWidget);
    expect(Get.find<TrackerStore>().byId('a')!.lifeYears, 100);
  });

  testWidgets('editor validates empty title', (tester) async {
    await _pump(tester, AppRoutes.editorPath);
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    expect(find.text('Error: give it a title.'), findsOneWidget);

    await tester.tap(find.text('Deadline'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Exam');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    expect(find.text('Error: pick a deadline date.'), findsOneWidget);
  });
}
