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
      error: AppColors.textPrimary, // no red: errors = white + icon
      onError: AppColors.textInverse,
      errorContainer: AppColors.bgHighest,
      onErrorContainer: AppColors.textPrimary,
      inverseSurface: AppColors.textPrimary,
      onInverseSurface: AppColors.textInverse,
      scrim: AppColors.scrim,
      shadow: Colors.black,
      surfaceTint: Colors.transparent, // disable M3 color tint on elevation
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
        color: AppColors.borderSubtle,
        thickness: 1,
        space: 1,
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
          textStyle: WidgetStatePropertyAll(
            AppText.label.copyWith(fontSize: 15),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((s) {
            if (s.contains(WidgetState.disabled)) return AppColors.bgOverlay;
            if (s.contains(WidgetState.pressed)) return AppColors.accentPressed;
            return AppColors.accent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.disabled)
                ? AppColors.textDisabled
                : AppColors.textInverse,
          ),
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
        iconTheme: WidgetStateProperty.resolveWith(
          (s) => IconThemeData(
            size: 24,
            color: s.contains(WidgetState.selected)
                ? AppColors.textPrimary
                : AppColors.textTertiary,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => AppText.caption.copyWith(
            color: s.contains(WidgetState.selected)
                ? AppColors.textPrimary
                : AppColors.textTertiary,
          ),
        ),
      ),

      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.textPrimary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.accent,
        dividerColor: AppColors.borderSubtle,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.bgBase
              : AppColors.accentMuted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.accent
              : AppColors.bgHighest,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.accent
              : Colors.transparent,
        ),
        checkColor: const WidgetStatePropertyAll(AppColors.textInverse),
        side: const BorderSide(color: AppColors.borderStrong, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.accent
              : AppColors.borderStrong,
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.bgOverlay,
        selectedColor: AppColors.accent,
        labelStyle: AppText.label.copyWith(color: AppColors.textSecondary),
        secondaryLabelStyle: AppText.label.copyWith(
          color: AppColors.textInverse,
        ),
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
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
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
          color: AppColors.bgHighest,
          borderRadius: AppRadius.brSm,
        ),
        textStyle: AppText.bodySm.copyWith(color: AppColors.textPrimary),
      ),

      // ── Extensions to the design system (same rules, missing components) ──
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.accent,
        selectionColor: AppColors.borderStrong,
        selectionHandleColor: AppColors.accent,
      ),

      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(0, AppSpacing.minTouch),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.brMd),
          ),
          side: const WidgetStatePropertyAll(BorderSide.none),
          textStyle: const WidgetStatePropertyAll(AppText.label),
          backgroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? AppColors.bgHighest
                : AppColors.bgOverlay,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? AppColors.textPrimary
                : AppColors.textSecondary,
          ),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        ),
      ),

      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.bgRaised,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brXl),
        headerBackgroundColor: AppColors.bgRaised,
        headerForegroundColor: AppColors.textPrimary,
        dividerColor: AppColors.borderSubtle,
        todayBorder: const BorderSide(color: AppColors.borderStrong),
        cancelButtonStyle: TextButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
        ),
        confirmButtonStyle: TextButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
        ),
      ),

      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.accent,
        inactiveTrackColor: AppColors.bgHighest,
        thumbColor: AppColors.accent,
        overlayColor: Colors.transparent,
        activeTickMarkColor: Colors.transparent,
        inactiveTickMarkColor: Colors.transparent,
        valueIndicatorColor: AppColors.bgHighest,
        valueIndicatorTextStyle: AppText.label,
        trackHeight: 4,
      ),

      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.bgRaised,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brXl),
        dialBackgroundColor: AppColors.bgOverlay,
        hourMinuteColor: AppColors.bgOverlay,
        dayPeriodColor: AppColors.bgHighest,
        cancelButtonStyle: TextButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
        ),
        confirmButtonStyle: TextButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
        ),
      ),
    );
  }
}
