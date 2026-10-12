# Design System — Monochrome Minimal Dark (Flutter)

> **Platform:** Flutter (Dart) only, Material 3 (`useMaterial3: true`).
>
> **Instruction to the code agent:** Follow this file for ALL UI work in this app. It is the single source of truth for colors, typography, spacing and components. Do not introduce any value that is not defined here. If something is missing, extend this system using the same rules rather than improvising.

---

## 1. Core Rule — Strictly Monochrome

The app uses **only black, white, and the grays between them**. Nothing else.

- ❌ NO hue of any kind: no blue, red, green, orange, purple, teal, etc. Not even for links, errors, success, charts, badges, or focus rings.
- ❌ NO gradients that contain color. Black-to-gray gradients are allowed only where noted.
- ❌ NO colored images, emojis, or illustrations in UI chrome. Photos/user content may display as-is, but default illustrations and placeholders must be grayscale.
- ✅ Every color in code must come from the tokens in section 2. No hard-coded hex values in components.

Hierarchy and meaning are created by **brightness, size, weight, spacing, and icons**, never by hue.

---

## 2. Color Tokens

The app is **dark mode first**. The background is near-black, and the brightest elements are white.

### 2.1 Surfaces (backgrounds, from deepest to highest)

| Token | Hex | Use |
|---|---|---|
| `bg.base` | `#0A0A0A` | App background, scaffold |
| `bg.surface` | `#141414` | Cards, list groups, bottom bar |
| `bg.raised` | `#1C1C1C` | Elevated cards, sheets, dialogs, menus |
| `bg.overlay` | `#242424` | Inputs, chips, hover/pressed surfaces |
| `bg.highest` | `#2E2E2E` | Selected item background, tooltips |

### 2.2 Borders and dividers

| Token | Hex | Use |
|---|---|---|
| `border.subtle` | `#1F1F1F` | Dividers between list rows |
| `border.default` | `#2A2A2A` | Card outlines, input borders |
| `border.strong` | `#3D3D3D` | Hovered inputs, emphasized outlines |
| `border.focus` | `#FFFFFF` | Focused input / keyboard focus ring |

### 2.3 Text and icons

| Token | Hex | Use |
|---|---|---|
| `text.primary` | `#F2F2F2` | Headings, main body text |
| `text.secondary` | `#A3A3A3` | Supporting text, subtitles |
| `text.tertiary` | `#6B6B6B` | Hints, timestamps, placeholders |
| `text.disabled` | `#474747` | Disabled labels |
| `text.inverse` | `#0A0A0A` | Text on white buttons/surfaces |

### 2.4 Accent (the "color" of this app is white)

| Token | Hex | Use |
|---|---|---|
| `accent.primary` | `#FFFFFF` | Primary button fill, active tab, toggles ON, progress fill |
| `accent.pressed` | `#D9D9D9` | Primary button pressed |
| `accent.muted` | `#8A8A8A` | Inactive toggle thumb, secondary progress |

### 2.5 Scrim

| Token | Value | Use |
|---|---|---|
| `scrim` | `#99000000` (60% black) | Behind modals and bottom sheets |

**Rules**
- Do not use pure `#000000` for large areas; use `bg.base`.
- Do not use pure `#FFFFFF` for body text; use `text.primary`. Pure white is reserved for `accent.primary` and focus.
- Elevation is shown by a **lighter surface**, not by shadows. Shadows are allowed only for floating elements (sheets, menus), and must be black: `AppShadow.floating`.
- Text must meet WCAG contrast: body text ≥ 4.5:1 against its background, large text ≥ 3:1. `text.tertiary` is for non-essential info only.

---

## 3. Status and Feedback Without Color

Since there is no red or green, communicate states like this:

| State | How to show it |
|---|---|
| **Error** | `text.primary` message + **error icon** (circle with exclamation) + input border `border.focus` (white) at 1.5px. Message text starts with the word "Error:" or a clear phrase. |
| **Success** | Check-circle icon + short confirmation text. Toast on `bg.highest`. |
| **Warning** | Triangle-alert icon + text. |
| **Info** | Info-circle icon + text in `text.secondary`. |
| **Destructive action** (delete) | Outlined button with **bold** label and trash icon, plus a confirmation dialog. Never rely on color. |
| **Positive/negative numbers** | Use `+` / `−` signs and ▲ / ▼ arrows. |
| **Charts** | Use shades of gray (`#F2F2F2`, `#A3A3A3`, `#6B6B6B`, `#3D3D3D`) plus patterns (solid, dashed, dotted) and direct labels instead of a colored legend. |

---

## 4. Typography

- **Font:** `Inter` (Latin). For Bangla text use `Hind Siliguri` or `Noto Sans Bengali`. Bundle the font files in `assets/fonts/` and declare them in `pubspec.yaml` (preferred, works offline), or use the `google_fonts` package. Set `Hind Siliguri` as a `fontFamilyFallback` so Bangla renders correctly.
- Use **one font family**. Hierarchy comes from size and weight only.
- Use the weights 400 (Regular), 500 (Medium), and 600 (SemiBold). Avoid 700+ except for large display numbers.

| Token | Size / Line height | Weight | Letter spacing | Use |
|---|---|---|---|---|
| `display` | 34 / 40 | 600 | -0.5 | Big numbers, hero values |
| `title.lg` | 24 / 30 | 600 | -0.3 | Screen titles |
| `title.md` | 20 / 26 | 600 | -0.2 | Section headers |
| `title.sm` | 17 / 22 | 500 | 0 | Card titles, list item titles |
| `body` | 15 / 22 | 400 | 0 | Default text |
| `body.sm` | 13 / 18 | 400 | 0 | Secondary text |
| `label` | 13 / 16 | 500 | 0.2 | Buttons, tabs, chips |
| `caption` | 11 / 14 | 500 | 0.4, UPPERCASE optional | Overlines, metadata |

---

## 5. Spacing, Layout, Shape

- **Grid:** 8pt system. Allowed spacing values: `4, 8, 12, 16, 24, 32, 40, 48, 64`.
- **Screen padding:** 20 horizontal.
- **Gap between sections:** 32. **Between cards:** 12. **Inside cards:** 16.
- **Minimum touch target:** 44 × 44.
- **Corner radius:**

| Token | Value | Use |
|---|---|---|
| `radius.sm` | 8 | Chips, small inputs, tags |
| `radius.md` | 12 | Buttons, inputs |
| `radius.lg` | 16 | Cards |
| `radius.xl` | 24 | Bottom sheets (top corners), modals |
| `radius.full` | 999 | Avatars, pills, toggles |

- **Border width:** 1px default, 1.5px for focus/error.
- Whitespace is the main design tool. When unsure, add space rather than a divider or a box.

---

## 6. Components

### Buttons
| Variant | Background | Text | Border |
|---|---|---|---|
| Primary | `accent.primary` (white) | `text.inverse` (black) | none |
| Secondary | `bg.overlay` | `text.primary` | none |
| Outline | transparent | `text.primary` | 1px `border.strong` |
| Ghost / text | transparent | `text.secondary` → `text.primary` on press | none |
| Disabled | `bg.overlay` | `text.disabled` | none |

- Height 48 (default), 40 (small). Radius `radius.md`. Label style `label` at 15px.
- Only **one primary (white) button per screen** section.
- Pressed state: Primary uses `accent.pressed`; others use one surface step lighter.

### Inputs
- Background `bg.overlay`, border 1px `border.default`, radius `radius.md`, height 48, padding 16.
- Placeholder `text.tertiary`; value `text.primary`; label above the field in `body.sm` `text.secondary`.
- Focus: border 1.5px `border.focus`.
- Error: border 1.5px `border.focus` + error icon + message below (see section 3).

### Cards
- `bg.surface`, radius `radius.lg`, padding 16, optional 1px `border.subtle`. No shadow.

### Lists
- Row height ≥ 56. Divider `border.subtle` inset 16 from the left. Leading icon in `text.secondary`, chevron in `text.tertiary`.

### Navigation
- **Bottom nav:** `bg.surface` with a top 1px `border.subtle`. Active icon + label `text.primary`; inactive `text.tertiary`. Optional active indicator: small pill in `bg.highest`.
- **Top app bar:** transparent over `bg.base`; title `title.md`; becomes `bg.base` with a bottom divider on scroll.
- **Tabs / segmented control:** container `bg.overlay`; selected segment `bg.highest` with `text.primary`; unselected `text.secondary`.

### Toggles, checkboxes, radios
- ON: track `accent.primary` (white), thumb `bg.base` (black).
- OFF: track `bg.highest`, thumb `accent.muted`.
- Checkbox checked: white fill with a black check.

### Chips / tags
- `bg.overlay`, text `text.secondary`, radius `radius.sm`. Selected: `accent.primary` background with `text.inverse`.

### Dialogs and bottom sheets
- Surface `bg.raised`, `radius.xl`, `scrim` behind, the floating shadow from section 2.
- Drag handle: 36 × 4, `border.strong`, radius full.

### Toasts / snackbars
- `bg.highest`, `text.primary`, leading status icon, radius `radius.md`, bottom of the screen above the nav.

### Avatars and images
- Avatar placeholder: `bg.highest` with initials in `text.secondary`.
- Image placeholders and skeletons: `bg.overlay` with a subtle shimmer from `#242424` to `#2E2E2E` (gray-only gradient allowed here).

### Progress and loaders
- Track `bg.highest`, fill `accent.primary`. Spinners in `text.primary`.

---

## 7. Icons

- One icon set only, line/outline style: **Lucide** via the `lucide_icons_flutter` package (preferred) or **Phosphor (Regular)** via `phosphor_flutter`. If no package is allowed, use Material `Icons.*_outlined` / `Icons.*_rounded` consistently.
- Stroke 1.5px, sizes 20 (default) and 24 (navigation).
- Default color `text.secondary`; active/important `text.primary`.
- No filled colorful icons and no emoji as icons.

---

## 8. Motion

- Durations: 150ms (press/hover), 200–250ms (enter/exit), 300ms (sheets).
- Easing: `Cubic(0.2, 0, 0, 1)` (`AppMotion.curve`).
- Prefer fades and small translations (≤ 8px). No bouncy or springy effects.
- Respect the system "reduce motion" setting (`MediaQuery.of(context).disableAnimations`).

---

## 9. Do / Don't

**Do**
- Use whitespace and type weight to create hierarchy.
- Keep one white primary action per section.
- Pair every status with an icon and clear words.
- Check contrast for every text/background pair.

**Don't**
- Add any hue, ever, including for errors, links or charts.
- Hard-code colors or font sizes inside components.
- Use shadows for elevation on normal cards.
- Use pure white body text or pure black large backgrounds.
- Stack many borders and boxes; remove a container if spacing alone works.

---

## 10. Flutter Implementation

Put all design values in `lib/theme/`. Widgets must reference these classes (`AppColors`, `AppSpacing`, `AppRadius`, `AppText`) or `Theme.of(context)`, and never use raw `Color(0x...)`, `Colors.*`, or numeric font sizes.

### 10.1 File structure

```
lib/theme/
  app_colors.dart     // color tokens
  app_spacing.dart    // spacing + radius tokens
  app_text.dart       // text styles
  app_theme.dart      // ThemeData that wires everything together
```

In `main.dart`:

```dart
MaterialApp(
  theme: AppTheme.dark,
  darkTheme: AppTheme.dark,
  themeMode: ThemeMode.dark, // app is always dark
  // ...
);
```

Also set the system bars to match:

```dart
SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark, // iOS
  systemNavigationBarColor: AppColors.bgBase,
  systemNavigationBarIconBrightness: Brightness.light,
));
```

### 10.2 `app_colors.dart`

```dart
import 'package:flutter/material.dart';

/// Monochrome palette. Do not add any color with a hue.
abstract final class AppColors {
  // Surfaces
  static const bgBase = Color(0xFF0A0A0A);
  static const bgSurface = Color(0xFF141414);
  static const bgRaised = Color(0xFF1C1C1C);
  static const bgOverlay = Color(0xFF242424);
  static const bgHighest = Color(0xFF2E2E2E);

  // Borders
  static const borderSubtle = Color(0xFF1F1F1F);
  static const borderDefault = Color(0xFF2A2A2A);
  static const borderStrong = Color(0xFF3D3D3D);
  static const borderFocus = Color(0xFFFFFFFF);

  // Text & icons
  static const textPrimary = Color(0xFFF2F2F2);
  static const textSecondary = Color(0xFFA3A3A3);
  static const textTertiary = Color(0xFF6B6B6B);
  static const textDisabled = Color(0xFF474747);
  static const textInverse = Color(0xFF0A0A0A);

  // Accent (white is the accent)
  static const accent = Color(0xFFFFFFFF);
  static const accentPressed = Color(0xFFD9D9D9);
  static const accentMuted = Color(0xFF8A8A8A);

  // Overlay
  static const scrim = Color(0x99000000); // 60% black

  // Chart shades (use with patterns + labels)
  static const chart = [
    Color(0xFFF2F2F2),
    Color(0xFFA3A3A3),
    Color(0xFF6B6B6B),
    Color(0xFF3D3D3D),
  ];
}
```

### 10.3 `app_spacing.dart`

```dart
import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;
  static const double xxxl = 48;
  static const double huge = 64;

  static const double screenH = 20; // horizontal screen padding
  static const double minTouch = 44;

  static const screenPadding = EdgeInsets.symmetric(horizontal: screenH);
}

abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 999;

  static final brSm = BorderRadius.circular(sm);
  static final brMd = BorderRadius.circular(md);
  static final brLg = BorderRadius.circular(lg);
  static final brXl = BorderRadius.circular(xl);
}

abstract final class AppMotion {
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 220);
  static const slow = Duration(milliseconds: 300);
  static const curve = Cubic(0.2, 0, 0, 1);
}

abstract final class AppShadow {
  /// Only for floating elements (sheets, menus). Never on normal cards.
  static const floating = [
    BoxShadow(color: Color(0x80000000), blurRadius: 24, offset: Offset(0, 8)),
  ];
}
```

### 10.4 `app_text.dart`

```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppText {
  static const _family = 'Inter';
  static const _fallback = ['Hind Siliguri'];

  static const display = TextStyle(
    fontFamily: _family, fontFamilyFallback: _fallback,
    fontSize: 34, height: 40 / 34, fontWeight: FontWeight.w600,
    letterSpacing: -0.5, color: AppColors.textPrimary,
  );
  static const titleLg = TextStyle(
    fontFamily: _family, fontFamilyFallback: _fallback,
    fontSize: 24, height: 30 / 24, fontWeight: FontWeight.w600,
    letterSpacing: -0.3, color: AppColors.textPrimary,
  );
  static const titleMd = TextStyle(
    fontFamily: _family, fontFamilyFallback: _fallback,
    fontSize: 20, height: 26 / 20, fontWeight: FontWeight.w600,
    letterSpacing: -0.2, color: AppColors.textPrimary,
  );
  static const titleSm = TextStyle(
    fontFamily: _family, fontFamilyFallback: _fallback,
    fontSize: 17, height: 22 / 17, fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  static const body = TextStyle(
    fontFamily: _family, fontFamilyFallback: _fallback,
    fontSize: 15, height: 22 / 15, fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  static const bodySm = TextStyle(
    fontFamily: _family, fontFamilyFallback: _fallback,
    fontSize: 13, height: 18 / 13, fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  static const label = TextStyle(
    fontFamily: _family, fontFamilyFallback: _fallback,
    fontSize: 13, height: 16 / 13, fontWeight: FontWeight.w500,
    letterSpacing: 0.2, color: AppColors.textPrimary,
  );
  static const caption = TextStyle(
    fontFamily: _family, fontFamilyFallback: _fallback,
    fontSize: 11, height: 14 / 11, fontWeight: FontWeight.w500,
    letterSpacing: 0.4, color: AppColors.textTertiary,
  );

  static const textTheme = TextTheme(
    displaySmall: display,
    headlineSmall: titleLg,
    titleLarge: titleMd,
    titleMedium: titleSm,
    bodyLarge: body,
    bodyMedium: body,
    bodySmall: bodySm,
    labelLarge: label,
    labelSmall: caption,
  );
}
```

### 10.5 `app_theme.dart`

```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text.dart';

abstract final class AppTheme {
  static final ThemeData dark = _build();

  static ThemeData _build() {
    const scheme = ColorScheme.dark(
      primary: AppColors.accent,
      onPrimary: AppColors.textInverse,
      primaryContainer: AppColors.bgHighest,
      onPrimaryContainer: AppColors.textPrimary,
      secondary: AppColors.bgHighest,
      onSecondary: AppColors.textPrimary,
      secondaryContainer: AppColors.bgHighest,
      onSecondaryContainer: AppColors.textPrimary,
      tertiary: AppColors.accentMuted,
      onTertiary: AppColors.textInverse,
      surface: AppColors.bgSurface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      surfaceContainerLowest: AppColors.bgBase,
      surfaceContainerLow: AppColors.bgSurface,
      surfaceContainer: AppColors.bgRaised,
      surfaceContainerHigh: AppColors.bgOverlay,
      surfaceContainerHighest: AppColors.bgHighest,
      outline: AppColors.borderDefault,
      outlineVariant: AppColors.borderSubtle,
      error: AppColors.textPrimary,      // no red: errors = white + icon
      onError: AppColors.textInverse,
      errorContainer: AppColors.bgHighest,
      onErrorContainer: AppColors.textPrimary,
      inverseSurface: AppColors.textPrimary,
      onInverseSurface: AppColors.textInverse,
      scrim: AppColors.scrim,
      shadow: Colors.black,
      surfaceTint: Colors.transparent,   // disable M3 color tint on elevation
    );

    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: AppRadius.brMd,
          borderSide: BorderSide(color: c, width: w),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.bgBase,
      canvasColor: AppColors.bgBase,
      fontFamily: 'Inter',
      textTheme: AppText.textTheme,
      splashFactory: NoSplash.splashFactory,
      highlightColor: AppColors.bgHighest.withValues(alpha: 0.5),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderSubtle, thickness: 1, space: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.textSecondary, size: 20),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgBase,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppText.titleMd,
      ),

      cardTheme: CardThemeData(
        color: AppColors.bgSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brLg),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.brMd),
          ),
          textStyle: WidgetStatePropertyAll(AppText.label.copyWith(fontSize: 15)),
          backgroundColor: WidgetStateProperty.resolveWith((s) {
            if (s.contains(WidgetState.disabled)) return AppColors.bgOverlay;
            if (s.contains(WidgetState.pressed)) return AppColors.accentPressed;
            return AppColors.accent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((s) =>
              s.contains(WidgetState.disabled)
                  ? AppColors.textDisabled
                  : AppColors.textInverse),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.borderStrong),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.brMd),
          textStyle: AppText.label.copyWith(fontSize: 15),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          textStyle: AppText.label.copyWith(fontSize: 15),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgOverlay,
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        hintStyle: AppText.body.copyWith(color: AppColors.textTertiary),
        labelStyle: AppText.bodySm,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        errorStyle: AppText.bodySm.copyWith(color: AppColors.textPrimary),
        border: border(AppColors.borderDefault),
        enabledBorder: border(AppColors.borderDefault),
        focusedBorder: border(AppColors.borderFocus, 1.5),
        errorBorder: border(AppColors.borderFocus, 1.5),
        focusedErrorBorder: border(AppColors.borderFocus, 1.5),
        disabledBorder: border(AppColors.borderSubtle),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.bgSurface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.bgHighest,
        elevation: 0,
        height: 64,
        iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
              size: 24,
              color: s.contains(WidgetState.selected)
                  ? AppColors.textPrimary
                  : AppColors.textTertiary,
            )),
        labelTextStyle: WidgetStateProperty.resolveWith((s) =>
            AppText.caption.copyWith(
              color: s.contains(WidgetState.selected)
                  ? AppColors.textPrimary
                  : AppColors.textTertiary,
            )),
      ),

      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.textPrimary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.accent,
        dividerColor: AppColors.borderSubtle,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? AppColors.bgBase
                : AppColors.accentMuted),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? AppColors.accent
                : AppColors.bgHighest),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? AppColors.accent
                : Colors.transparent),
        checkColor: const WidgetStatePropertyAll(AppColors.textInverse),
        side: const BorderSide(color: AppColors.borderStrong, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? AppColors.accent
                : AppColors.borderStrong),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.bgOverlay,
        selectedColor: AppColors.accent,
        labelStyle: AppText.label.copyWith(color: AppColors.textSecondary),
        secondaryLabelStyle: AppText.label.copyWith(color: AppColors.textInverse),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brSm),
        checkmarkColor: AppColors.textInverse,
      ),

      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.textSecondary,
        textColor: AppColors.textPrimary,
        minVerticalPadding: 12,
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.bgRaised,
        surfaceTintColor: Colors.transparent,
        modalBarrierColor: AppColors.scrim,
        showDragHandle: true,
        dragHandleColor: AppColors.borderStrong,
        dragHandleSize: const Size(36, 4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.bgRaised,
        surfaceTintColor: Colors.transparent,
        barrierColor: AppColors.scrim,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brXl),
        titleTextStyle: AppText.titleMd,
        contentTextStyle: AppText.body,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.bgHighest,
        contentTextStyle: AppText.body,
        actionTextColor: AppColors.textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brMd),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accent,
        linearTrackColor: AppColors.bgHighest,
        circularTrackColor: AppColors.bgHighest,
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.bgRaised,
        surfaceTintColor: Colors.transparent,
        textStyle: AppText.body,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brMd),
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.bgHighest, borderRadius: AppRadius.brSm,
        ),
        textStyle: AppText.bodySm.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
```

### 10.6 Flutter rules for the agent

- Never use `Colors.blue`, `Colors.red`, `Colors.green`, etc. The only allowed `Colors.*` values are `Colors.transparent`, `Colors.black` and `Colors.white` (and prefer the tokens even for those).
- Always set `surfaceTintColor: Colors.transparent` on any new Material surface; Material 3 otherwise adds a tint on elevation.
- Use `FilledButton` for the primary (white) action, `OutlinedButton` for secondary, `TextButton` for ghost. Do not use `ElevatedButton`.
- Use `NavigationBar` (Material 3), not `BottomNavigationBar`.
- Show feedback with `ScaffoldMessenger.of(context).showSnackBar(...)` using a leading status icon (see section 3).
- Wrap screen content in `SafeArea` and use `AppSpacing.screenPadding`.
- Build reusable widgets in `lib/widgets/` (e.g. `AppCard`, `AppStatusMessage`, `AppSectionHeader`) instead of repeating styling.
- Support Flutter's text scaling; do not lock `textScaler`.
- Check that the app builds without warnings: `flutter analyze`.

### 10.7 `pubspec.yaml` (fonts and icons)

```yaml
dependencies:
  lucide_icons_flutter: any   # pin a version when adding

flutter:
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
          weight: 400
        - asset: assets/fonts/Inter-Medium.ttf
          weight: 500
        - asset: assets/fonts/Inter-SemiBold.ttf
          weight: 600
    - family: Hind Siliguri
      fonts:
        - asset: assets/fonts/HindSiliguri-Regular.ttf
          weight: 400
        - asset: assets/fonts/HindSiliguri-Medium.ttf
          weight: 500
        - asset: assets/fonts/HindSiliguri-SemiBold.ttf
          weight: 600
```

---

## 11. Checklist Before Finishing Any Screen

- [ ] Only tokens from this file are used; no raw hex values in components.
- [ ] No hue appears anywhere on the screen.
- [ ] There is at most one white primary button per section.
- [ ] Every error, success, or warning has an icon and clear text.
- [ ] All text passes contrast (body ≥ 4.5:1).
- [ ] Spacing values are on the 8pt scale.
- [ ] Touch targets are at least 44 × 44.
- [ ] No raw `Colors.*` (except transparent) or `Color(0x...)` outside `lib/theme/`.
- [ ] `flutter analyze` passes with no warnings.
- [ ] The screen still reads clearly if the user turns on grayscale mode, since that is how it should already look.

---

## 12. Project Notes (Lifetime)

Additions made in this app, following the rules above:

- **Icons:** `lucide_icons_flutter`, always via `AppIcons` (`lib/theme/app_icons.dart`), which uses the `*300` variants (≈1.55px stroke).
- **Extra theme entries:** `textSelectionTheme`, `segmentedButtonTheme`, `datePickerTheme` and `timePickerTheme` were added to `app_theme.dart` with the same tokens.
- **Numbers:** live counters use `FontFeature.tabularFigures()` so digits don't jitter while ticking.
- **Overdue:** shown with the warning icon, `label` weight, and a `+` prefix, never with color.
