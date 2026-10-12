import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Lucide icons at the 300 weight (≈1.5px stroke, DESIGN_SYSTEM.md §7).
/// Always reference icons through this class so the stroke stays consistent.
abstract final class AppIcons {
  static const add = LucideIcons.plus300;
  static const back = LucideIcons.chevronLeft300;
  static const chevron = LucideIcons.chevronRight300;
  static const close = LucideIcons.x300;
  static const more = LucideIcons.ellipsisVertical300;
  static const sort = LucideIcons.arrowUpDown300;
  static const settings = LucideIcons.settings300;

  static const calendar = LucideIcons.calendar300;
  static const clock = LucideIcons.clock300;
  static const hourglass = LucideIcons.hourglass300;
  static const history = LucideIcons.history300;

  static const event = LucideIcons.calendarDays300;
  static const age = LucideIcons.cake300;
  static const habit = LucideIcons.flame300;

  static const pin = LucideIcons.pin300;
  static const unpin = LucideIcons.pinOff300;
  static const edit = LucideIcons.pencil300;
  static const delete = LucideIcons.trash2300;
  static const reset = LucideIcons.rotateCcw300;
  static const check = LucideIcons.check300;

  static const error = LucideIcons.circleAlert300;
  static const success = LucideIcons.circleCheck300;
  static const warning = LucideIcons.triangleAlert300;
  static const info = LucideIcons.info300;

  static const IconData empty = LucideIcons.timer300;
  static const lifeGrid = LucideIcons.grid3x3300;
}
