import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Zakat-mode theme overlay: premium emerald-and-gold palette, Inter for UI
/// text and Playfair for display titles. Awqaf screens are not affected.
abstract final class ZakatTheme {
  ZakatTheme._();

  static const double _radiusSm = 14;
  static const double _radiusLg = 24;

  static ColorScheme _scheme(ColorScheme base) {
    if (base.brightness == Brightness.dark) {
      return base.copyWith(
        primary: const Color(0xFF2FA878),
        onPrimary: Colors.white,
        primaryContainer: const Color(0xFF0D5A43),
        onPrimaryContainer: const Color(0xFFA8F0CE),
        secondary: const Color(0xFFE9C46A),
        onSecondary: const Color(0xFF3A2A00),
        secondaryContainer: const Color(0xFF5A4300),
        onSecondaryContainer: const Color(0xFFFFE08F),
        tertiary: AppColors.goldLight,
        surface: const Color(0xFF0B1512),
        onSurface: const Color(0xFFE6ECE8),
        onSurfaceVariant: const Color(0xFFA9B8B0),
        surfaceContainerLowest: const Color(0xFF111D19),
        surfaceContainerLow: const Color(0xFF14211D),
        surfaceContainer: const Color(0xFF182622),
        surfaceContainerHigh: const Color(0xFF1D2D28),
        surfaceContainerHighest: const Color(0xFF23352F),
        outline: const Color(0xFF6F7F77),
        outlineVariant: const Color(0xFF2C3F37),
        inverseSurface: const Color(0xFFE6ECE8),
        onInverseSurface: AppColors.forestGreen,
        surfaceTint: Colors.transparent,
      );
    }
    return base.copyWith(
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: const Color(0xFFD3EEE1),
      onPrimaryContainer: AppColors.emeraldNight,
      secondary: AppColors.warmGold,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.tagGoldBg,
      onSecondaryContainer: AppColors.tagGoldText,
      tertiary: AppColors.goldDeep,
      surface: AppColors.parchment,
      onSurface: AppColors.ink,
      onSurfaceVariant: AppColors.mutedText,
      surfaceContainerLowest: AppColors.ivory,
      surfaceContainerLow: const Color(0xFFF6F2E9),
      surfaceContainer: const Color(0xFFF1ECE0),
      surfaceContainerHigh: const Color(0xFFECE5D6),
      surfaceContainerHighest: const Color(0xFFF3EEE3),
      outline: const Color(0xFFCDBF9C),
      outlineVariant: AppColors.borderWarm,
      inverseSurface: AppColors.forestGreen,
      onInverseSurface: AppColors.mintGreen,
      surfaceTint: Colors.transparent,
    );
  }

  static ThemeData of(BuildContext context) {
    final base = Theme.of(context);
    final scheme = _scheme(base.colorScheme);
    final textTheme = AppTypography.buildTextTheme(
      base: base.textTheme,
      scheme: scheme,
    );
    final isDark = scheme.brightness == Brightness.dark;

    final controlShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_radiusSm),
    );
    const buttonPadding = EdgeInsets.symmetric(horizontal: 22, vertical: 15);
    final buttonText = textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
      fontSize: 15,
    );

    OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radiusSm),
          borderSide: BorderSide(color: color, width: width),
        );

    return base.copyWith(
      colorScheme: scheme,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      canvasColor: scheme.surface,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: scheme.onSurface.withValues(alpha: 0.10),
          disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.38),
          minimumSize: const Size(0, 52),
          padding: buttonPadding,
          shape: controlShape,
          textStyle: buttonText,
          elevation: 0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.warmGold,
          foregroundColor: AppColors.onSecondary,
          disabledBackgroundColor: scheme.onSurface.withValues(alpha: 0.10),
          disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.38),
          minimumSize: const Size(0, 52),
          padding: buttonPadding,
          shape: controlShape,
          textStyle: buttonText,
          elevation: 0,
          shadowColor: AppColors.goldDeep.withValues(alpha: 0.4),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.outline),
          minimumSize: const Size(0, 52),
          padding: buttonPadding,
          shape: controlShape,
          textStyle: buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size(0, 44),
          shape: controlShape,
          textStyle: buttonText?.copyWith(fontSize: 14),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.warmGold,
        foregroundColor: AppColors.onSecondary,
        shape: controlShape,
        elevation: 2,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? scheme.surfaceContainerHigh : AppColors.ivory,
        alignLabelWithHint: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        floatingLabelStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.primary,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        prefixIconColor: scheme.onSurfaceVariant,
        suffixIconColor: scheme.onSurfaceVariant,
        border: inputBorder(scheme.outlineVariant),
        enabledBorder: inputBorder(scheme.outlineVariant),
        focusedBorder: inputBorder(scheme.primary, 1.6),
        errorBorder: inputBorder(scheme.error),
        focusedErrorBorder: inputBorder(scheme.error, 1.6),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: scheme.surfaceContainerLowest,
        selectedColor: scheme.primary,
        secondarySelectedColor: scheme.primary,
        checkmarkColor: scheme.onPrimary,
        side: BorderSide(color: scheme.outlineVariant),
        shape: const StadiumBorder(),
        labelStyle: textTheme.labelLarge,
        secondaryLabelStyle:
            textTheme.labelLarge?.copyWith(color: scheme.onPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: scheme.surfaceContainerLowest,
          selectedBackgroundColor: scheme.primary,
          selectedForegroundColor: scheme.onPrimary,
          side: BorderSide(color: scheme.outlineVariant),
          textStyle: textTheme.labelLarge,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: AppColors.warmGold,
        dividerColor: scheme.outlineVariant,
        labelStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        unselectedLabelStyle: textTheme.titleSmall,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? Colors.white : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? scheme.primary : null,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? scheme.primary : null,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? scheme.primary : null,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.warmGold,
        linearTrackColor:
            isDark ? scheme.surfaceContainerHighest : AppColors.progressTrack,
        circularTrackColor: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.primary,
        titleTextStyle:
            textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        subtitleTextStyle:
            textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        shape: controlShape,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: AppColors.forestGreen,
        contentTextStyle:
            textTheme.bodyMedium?.copyWith(color: AppColors.mintGreen),
        actionTextColor: AppColors.goldLight,
        shape: controlShape,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusLg),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: scheme.surfaceContainerLowest,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(_radiusLg)),
        ),
        showDragHandle: true,
        dragHandleColor: AppColors.goldHairline,
        elevation: 0,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusSm),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        textStyle: textTheme.bodyMedium,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: AppColors.forestGreen,
        headerForegroundColor: AppColors.textOnPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusLg),
        ),
      ),
    );
  }
}
