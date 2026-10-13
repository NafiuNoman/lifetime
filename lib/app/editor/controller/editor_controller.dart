import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/formatters.dart';
import '../../../data/model/tracker.dart';
import '../../../service/settings_service.dart';
import '../../../service/tracker_store.dart';
import '../../../widgets/app_feedback.dart';

/// Add / edit form. Pass a tracker id as `Get.arguments` to edit.
class EditorController extends GetxController {
  final store = Get.find<TrackerStore>();
  final settings = Get.find<SettingsService>();

  final titleCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  final yearsCtrl = TextEditingController();
  final monthsCtrl = TextEditingController();
  final daysCtrl = TextEditingController();

  final type = TrackerType.event.obs;
  final startDate = Rxn<DateTime>();
  final startTime = Rxn<TimeOfDay>();
  final withTime = false.obs;
  final hasDeadline = false.obs;
  final deadlineDate = Rxn<DateTime>();
  final deadlineTime = Rxn<TimeOfDay>();

  /// Deadline entered as a period after the start (e.g. an age limit).
  final deadlineByPeriod = false.obs;
  final period = const DeadlineOffset().obs;

  final titleError = RxnString();
  final startError = RxnString();
  final deadlineError = RxnString();

  Tracker? _editing;
  bool get isEditing => _editing != null;

  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments as String?;
    _editing = id == null ? null : store.byId(id);
    final t = _editing;
    if (t == null) {
      startDate.value = _dateOnly(DateTime.now());
      return;
    }
    titleCtrl.text = t.title;
    noteCtrl.text = t.note ?? '';
    type.value = t.type;
    withTime.value = t.withTime;
    startDate.value = _dateOnly(t.startAt);
    startTime.value = TimeOfDay.fromDateTime(t.startAt);
    if (t.deadlineAt != null) {
      hasDeadline.value = true;
      deadlineDate.value = _dateOnly(t.deadlineAt!);
      deadlineTime.value = TimeOfDay.fromDateTime(t.deadlineAt!);
    }
    final offset = t.deadlineOffset;
    if (offset != null) {
      deadlineByPeriod.value = true;
      period.value = offset;
      yearsCtrl.text = offset.years == 0 ? '' : '${offset.years}';
      monthsCtrl.text = offset.months == 0 ? '' : '${offset.months}';
      daysCtrl.text = offset.days == 0 ? '' : '${offset.days}';
    }
  }

  @override
  void onClose() {
    titleCtrl.dispose();
    noteCtrl.dispose();
    yearsCtrl.dispose();
    monthsCtrl.dispose();
    daysCtrl.dispose();
    super.onClose();
  }

  String get startLabel => switch (type.value) {
    TrackerType.event => 'Date',
    TrackerType.age => 'Date of birth',
    TrackerType.habit => 'Streak started',
  };

  String get titleHint => switch (type.value) {
    TrackerType.event => 'e.g. Moved to Dhaka',
    TrackerType.age => 'e.g. My age',
    TrackerType.habit => 'e.g. No sugar',
  };

  String get timePlaceholder =>
      'Pick a time (default ${formatTime(DateTime(2000), use24h: settings.use24h.value)})';

  /// Age trackers count down to the next birthday on their own.
  bool get deadlineAllowed => type.value != TrackerType.age;

  void setType(TrackerType t) {
    type.value = t;
    if (!deadlineAllowed) hasDeadline.value = false;
  }

  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
    );
    if (picked != null) {
      startDate.value = picked;
      startError.value = null;
      deadlineError.value = null;
    }
  }

  Future<void> pickStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: startTime.value ?? TimeOfDay.now(),
    );
    if (picked != null) startTime.value = picked;
  }

  Future<void> pickDeadlineDate(BuildContext context) async {
    final base = startDate.value ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate:
          deadlineDate.value ??
          (base.isAfter(DateTime.now()) ? base : DateTime.now()).add(
            const Duration(days: 30),
          ),
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
    );
    if (picked != null) {
      deadlineDate.value = picked;
      deadlineError.value = null;
    }
  }

  Future<void> pickDeadlineTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: deadlineTime.value ?? const TimeOfDay(hour: 23, minute: 59),
    );
    if (picked != null) deadlineTime.value = picked;
  }

  void onPeriodChanged() {
    int read(TextEditingController c) => int.tryParse(c.text.trim()) ?? 0;
    period.value = DeadlineOffset(
      years: read(yearsCtrl),
      months: read(monthsCtrl),
      days: read(daysCtrl),
    );
    deadlineError.value = null;
  }

  /// Live preview of the period deadline, e.g. "Ends on 2 May 2028".
  DateTime? get periodDeadline {
    final start = _startAt;
    if (start == null || period.value.isEmpty) return null;
    return period.value.addTo(start);
  }

  DateTime? get _startAt => _combine(startDate.value, startTime.value);
  DateTime? get _deadlineAt => deadlineByPeriod.value
      ? periodDeadline
      : _combine(deadlineDate.value, deadlineTime.value);

  DateTime? _combine(DateTime? date, TimeOfDay? time) {
    if (date == null) return null;
    final t = withTime.value ? time : null;
    return DateTime(
      date.year,
      date.month,
      date.day,
      t?.hour ?? 0,
      t?.minute ?? 0,
    );
  }

  bool _validate() {
    final title = titleCtrl.text.trim();
    titleError.value = title.isEmpty ? 'Error: give it a title.' : null;
    startError.value = _startAt == null
        ? 'Error: pick a ${startLabel.toLowerCase()}.'
        : null;
    if (type.value == TrackerType.age &&
        _startAt != null &&
        _startAt!.isAfter(DateTime.now())) {
      startError.value = 'Error: date of birth can’t be in the future.';
    }

    deadlineError.value = null;
    if (hasDeadline.value) {
      if (deadlineByPeriod.value && period.value.isEmpty) {
        deadlineError.value = 'Error: enter years, months or days.';
      } else if (_deadlineAt == null) {
        deadlineError.value = 'Error: pick a deadline date.';
      } else if (_startAt != null && !_deadlineAt!.isAfter(_startAt!)) {
        deadlineError.value = 'Error: the deadline must be after the start.';
      }
    }
    return titleError.value == null &&
        startError.value == null &&
        deadlineError.value == null;
  }

  Future<void> save() async {
    if (!_validate()) return;
    final note = noteCtrl.text.trim();
    final base =
        _editing ??
        Tracker(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: '',
          type: type.value,
          startAt: _startAt!,
          createdAt: DateTime.now(),
        );
    await store.upsert(
      base.copyWith(
        title: titleCtrl.text.trim(),
        type: type.value,
        startAt: _startAt,
        deadlineAt: () => hasDeadline.value ? _deadlineAt : null,
        deadlineOffset: () =>
            hasDeadline.value && deadlineByPeriod.value ? period.value : null,
        withTime: withTime.value,
        note: () => note.isEmpty ? null : note,
      ),
    );
    Get.back();
    showAppSnack(isEditing ? 'Changes saved' : 'Added');
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
