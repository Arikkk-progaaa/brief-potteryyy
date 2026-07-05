import 'package:flutter/material.dart';

/// Цвета и типографика приложения мастерской «Глина».
abstract final class AppTheme {
  static const _sage = Color(0xFF3D5A45);
  static const _clay = Color(0xFFB8734A);
  static const _cream = Color(0xFFF5F0E8);
  static const _ink = Color(0xFF1E2420);
  static const _muted = Color(0xFF6B756C);

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _cream,
      colorScheme: ColorScheme.light(
        primary: _sage,
        onPrimary: Colors.white,
        primaryContainer: const Color(0xFFD4E4D8),
        onPrimaryContainer: _sage,
        secondary: _clay,
        onSecondary: Colors.white,
        secondaryContainer: const Color(0xFFF5DFC8),
        onSecondaryContainer: const Color(0xFF5C3D24),
        surface: Colors.white,
        onSurface: _ink,
        onSurfaceVariant: _muted,
        outline: const Color(0xFFC8CFC9),
        outlineVariant: const Color(0xFFE2E8E3),
        error: const Color(0xFFC0392B),
        errorContainer: const Color(0xFFFADBD8),
        onErrorContainer: const Color(0xFF922B21),
        tertiary: const Color(0xFF8E6B4A),
      ),
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: _cream,
        foregroundColor: _ink,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: _ink,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: base.colorScheme.outlineVariant),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: DividerThemeData(
        color: base.colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _sage,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _sage,
          side: BorderSide(color: _sage.withValues(alpha: 0.45)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: _ink,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _sage;
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _sage.withValues(alpha: 0.35);
          }
          return null;
        }),
      ),
    );
  }

  static const slotAccentAvailable = Color(0xFF3D5A45);
  static const slotAccentFull = Color(0xFF9AA39B);
  static const slotAccentCancelled = Color(0xFFC0392B);
}
