import 'package:flutter/widgets.dart';

import '../data/model/tracker.dart';
import '../theme/app_icons.dart';

IconData trackerTypeIcon(TrackerType type) => switch (type) {
  TrackerType.event => AppIcons.event,
  TrackerType.age => AppIcons.age,
  TrackerType.habit => AppIcons.habit,
};
