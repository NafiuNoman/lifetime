# Lifetime

A personal, offline time tracker for people who want to see their time clearly. Pick any date and see exactly how much time has passed. Add a deadline to also count down, with overdue time shown once it passes. It doubles as an age calculator and a habit-streak counter.

## What it does

- **Track any date**: titled entries showing live elapsed time (`2y 3m 14d · 05:12:09`)
  - Future start dates count down to the start
- **Optional deadline**: elapsed + countdown + progress bar
  - Past the deadline the card shows **Overdue by …** instead of stopping at zero
- **Three types**
  - **Event**: time since/until any moment
  - **Age**: exact age, next birthday, "turning N in …", weekday you were born
    - **Life in weeks**: your life as a grid of 52 boxes per year (lived / this week / ahead). Life expectancy defaults to 60 and is adjustable from 30 to 100
  - **Habit**: current streak, **Reset streak** (saved to history with an optional note), best streak, attempts
- **Detail screen**: Y/M/D/h/m/s breakdown, totals (months, weeks, days, hours, minutes, seconds), deadline progress
- **View options**: show numbers as `Y M D`, `Days` or `Hours`; sort by recently added, longest running, closest deadline or title. Pinned items stay on top
- **Settings**: 12-hour or 24-hour time format
- **Local only**: no account, no server, works offline
- **Minimal monochrome dark UI** following [`docs/DESIGN_SYSTEM.md`](docs/DESIGN_SYSTEM.md)

## Tech stack

Flutter (Material 3) · GetX (state, routing, DI) · shared_preferences (JSON storage) · lucide_icons_flutter · bundled Inter + Hind Siliguri fonts.

## Getting started

```bash
flutter pub get
flutter run
```

No config files or environment variables are needed.

To launch with sample data (handy for screenshots), run:

```bash
flutter run --dart-define=SEED_DEMO=true
```

Demo data is only seeded when the list is empty.

## Tests

```bash
flutter test      # time math, formatting, JSON, screen rendering + validation
flutter analyze
```

## Build

```bash
flutter build apk --release          # Android APK
flutter build appbundle --release    # Play Store
flutter build ipa --release          # iOS
```

App icon: put a 1024×1024 PNG at `assets/images/app_logo.png`, then run `dart run flutter_launcher_icons`.

## Project layout

```
lib/
├── main.dart                 # init SharedPrefs, TickService, TrackerStore; dark system bars
├── app/
│   ├── home/                 # tracker list, live cards, view-options sheet
│   ├── editor/               # add / edit form (type, dates, deadline, note) + validation
│   ├── detail/               # breakdown, totals, deadline / age / habit sections, delete
│   ├── life_grid/            # life-in-weeks grid (CustomPainter) + life-expectancy slider
│   └── settings/             # app settings (12/24-hour time format)
├── common/app_routes.dart    # GetX routes: home, editor, detail, life grid, settings
├── core/
│   ├── time_span.dart        # calendar-accurate Y/M/D/h/m/s diff, month clamping, birthdays
│   ├── tracker_metrics.dart  # elapsed / remaining / overdue / progress / streaks per tick
│   ├── life_weeks.dart       # weeks lived / total / current box for the life grid
│   └── formatters.dart       # "2y 3m 14d", "823 days", dates, numbers
├── data/model/tracker.dart   # Tracker, TrackerType, StreakReset (+ JSON)
├── service/
│   ├── shared_pref.dart      # SharedPreferences singleton
│   ├── settings_service.dart # app preferences (24-hour clock)
│   ├── tick_service.dart     # one app-wide 1-second clock
│   └── tracker_store.dart    # CRUD, sort, display format, persistence
├── theme/                    # design tokens: colors, spacing, text, icons, ThemeData
└── widgets/                  # shared UI: card, icon menu, fields, feedback, progress, headers
```

Each feature module follows page/ + controller/ (with binding) + widget/ (GetX).

See [`docs/APP_FLOW.md`](docs/APP_FLOW.md) for the full user and data flow.
