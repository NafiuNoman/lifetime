import 'dart:convert';

import 'package:get/get.dart';

import '../core/formatters.dart';
import '../data/model/tracker.dart';
import 'shared_pref.dart';

enum SortMode {
  newest('Recently added'),
  oldestStart('Longest running'),
  nearestDeadline('Closest deadline'),
  title('Title A–Z');

  final String label;
  const SortMode(this.label);
}

/// Single source of truth for trackers and view preferences.
/// Everything is stored locally as JSON in SharedPreferences.
class TrackerStore extends GetxService {
  final items = <Tracker>[].obs;
  final format = DisplayFormat.calendar.obs;
  final sort = SortMode.newest.obs;

  final _prefs = SharedPrefs();

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void _load() {
    final raw = _prefs.getString(SharedPrefs.trackers);
    if (raw != null && raw.isNotEmpty) {
      final list = jsonDecode(raw) as List;
      items.assignAll(
        list.map((e) => Tracker.fromJson(Map<String, dynamic>.from(e))),
      );
    }
    format.value = DisplayFormat.values.firstWhere(
      (f) => f.name == _prefs.getString(SharedPrefs.displayFormat),
      orElse: () => DisplayFormat.calendar,
    );
    sort.value = SortMode.values.firstWhere(
      (s) => s.name == _prefs.getString(SharedPrefs.sortMode),
      orElse: () => SortMode.newest,
    );
    if (items.isEmpty && const bool.fromEnvironment('SEED_DEMO')) _seedDemo();
  }

  /// Sample data for screenshots: `flutter run --dart-define=SEED_DEMO=true`.
  void _seedDemo() {
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    items.assignAll([
      Tracker(
        id: 'demo-age',
        title: 'My age',
        type: TrackerType.age,
        startAt: DateTime(1996, 3, 14),
        pinned: true,
        createdAt: now,
      ),
      Tracker(
        id: 'demo-habit',
        title: 'No sugar',
        type: TrackerType.habit,
        startAt: day.subtract(const Duration(days: 23, hours: 6)),
        withTime: true,
        createdAt: now.subtract(const Duration(minutes: 1)),
        resets: [
          StreakReset(
            startedAt: day.subtract(const Duration(days: 80)),
            resetAt: day.subtract(const Duration(days: 23, hours: 6)),
            note: 'Birthday cake',
          ),
        ],
      ),
      Tracker(
        id: 'demo-project',
        title: 'Ship Lifetime v1',
        type: TrackerType.event,
        startAt: day.subtract(const Duration(days: 12)),
        deadlineAt: day.add(const Duration(days: 18)),
        createdAt: now.subtract(const Duration(minutes: 2)),
      ),
      Tracker(
        id: 'demo-overdue',
        title: 'Renew passport',
        type: TrackerType.event,
        startAt: day.subtract(const Duration(days: 60)),
        deadlineAt: day.subtract(const Duration(days: 3)),
        createdAt: now.subtract(const Duration(minutes: 3)),
      ),
      Tracker(
        id: 'demo-moved',
        title: 'Moved to Dhaka',
        type: TrackerType.event,
        startAt: DateTime(2019, 8, 1),
        createdAt: now.subtract(const Duration(minutes: 4)),
      ),
    ]);
  }

  Future<void> _save() => _prefs.saveString(
    SharedPrefs.trackers,
    jsonEncode(items.map((t) => t.toJson()).toList()),
  );

  /// Pinned first, then by the chosen [sort].
  List<Tracker> get sorted {
    final list = [...items];
    int bySort(Tracker a, Tracker b) {
      switch (sort.value) {
        case SortMode.newest:
          return b.createdAt.compareTo(a.createdAt);
        case SortMode.oldestStart:
          return a.startAt.compareTo(b.startAt);
        case SortMode.nearestDeadline:
          final da = a.deadlineAt, db = b.deadlineAt;
          if (da == null && db == null) {
            return b.createdAt.compareTo(a.createdAt);
          }
          if (da == null) return 1;
          if (db == null) return -1;
          return da.compareTo(db);
        case SortMode.title:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      }
    }

    list.sort((a, b) {
      if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
      return bySort(a, b);
    });
    return list;
  }

  Tracker? byId(String id) => items.firstWhereOrNull((t) => t.id == id);

  Future<void> upsert(Tracker t) {
    final i = items.indexWhere((e) => e.id == t.id);
    if (i == -1) {
      items.add(t);
    } else {
      items[i] = t;
    }
    return _save();
  }

  Future<void> delete(String id) {
    items.removeWhere((t) => t.id == id);
    return _save();
  }

  Future<void> togglePin(String id) {
    final t = byId(id);
    if (t == null) return Future.value();
    return upsert(t.copyWith(pinned: !t.pinned));
  }

  /// Ends the current habit streak (saved to history) and starts a new one now.
  Future<void> resetStreak(String id, {String? note}) {
    final t = byId(id);
    if (t == null) return Future.value();
    final now = DateTime.now();
    return upsert(
      t.copyWith(
        startAt: now,
        withTime: true,
        resets: [
          StreakReset(startedAt: t.startAt, resetAt: now, note: note),
          ...t.resets,
        ],
      ),
    );
  }

  Future<void> setLifeYears(String id, int years) {
    final t = byId(id);
    if (t == null || t.lifeYears == years) return Future.value();
    return upsert(t.copyWith(lifeYears: years));
  }

  void setFormat(DisplayFormat f) {
    format.value = f;
    _prefs.saveString(SharedPrefs.displayFormat, f.name);
  }

  void setSort(SortMode s) {
    sort.value = s;
    _prefs.saveString(SharedPrefs.sortMode, s.name);
  }
}
