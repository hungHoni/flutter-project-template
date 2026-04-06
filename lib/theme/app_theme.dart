import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// ThemeData factory — overrides ALL Material defaults.
/// Zero elevation everywhere. No Material color scheme defaults.
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.surface,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.primaryDark,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          error: AppColors.error,
          outline: AppColors.border,
        ),
        dividerColor: AppColors.border,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,

        // ── AppBar — none by default ──
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: AppTypography.title,
        ),

        // ── Cards — flat with 1px border ──
        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.border),
          ),
          margin: EdgeInsets.zero,
        ),

        // ── Buttons — flat, no elevation ──
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            textStyle: AppTypography.button,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTypography.button,
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryDark,
            textStyle: AppTypography.button,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),

        // ── Input — flat with 1px border ──
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.background,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          hintStyle: AppTypography.label,
        ),

        // ── Chips — flat, editorial ──
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.background,
          selectedColor: AppColors.primaryLight,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          labelStyle: AppTypography.label,
          elevation: 0,
          pressElevation: 0,
        ),

        // ── Bottom nav — hidden, we use custom ──
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          elevation: 0,
        ),

        // ── Dialog — flat ──
        dialogTheme: DialogThemeData(
          elevation: 0,
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.surfaceDarkMode,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.primaryDark,
          surface: AppColors.surfaceDarkMode,
          onSurface: AppColors.textPrimaryDarkMode,
          error: AppColors.error,
          outline: AppColors.borderDarkMode,
        ),
        dividerColor: AppColors.borderDarkMode,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,

        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surfaceDarkMode,
          foregroundColor: AppColors.textPrimaryDarkMode,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: AppTypography.title.copyWith(
            color: AppColors.textPrimaryDarkMode,
          ),
        ),

        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColors.backgroundDarkMode,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.borderDarkMode),
          ),
          margin: EdgeInsets.zero,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            textStyle: AppTypography.button,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTypography.button,
            side: const BorderSide(color: AppColors.borderDarkMode),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTypography.button,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.backgroundDarkMode,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderDarkMode),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderDarkMode),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          hintStyle: AppTypography.label.copyWith(
            color: AppColors.textMetaDarkMode,
          ),
        ),

        chipTheme: ChipThemeData(
          backgroundColor: AppColors.backgroundDarkMode,
          selectedColor: AppColors.primaryDark,
          side: const BorderSide(color: AppColors.borderDarkMode),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          labelStyle: AppTypography.label.copyWith(
            color: AppColors.textSecondaryDarkMode,
          ),
          elevation: 0,
          pressElevation: 0,
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          elevation: 0,
        ),

        dialogTheme: DialogThemeData(
          elevation: 0,
          backgroundColor: AppColors.backgroundDarkMode,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.borderDarkMode),
          ),
        ),
      );
}
