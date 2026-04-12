import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF0F1116);
  static const Color surface = Color(0xFF171A21);
  static const Color surfaceVariant = Color(0xFF1F242D);

  static const Color primary = Color(0xFF4A7CCF);
  static const Color primaryContainer = Color(0xFF2E4C78);
  static const Color secondary = Color(0xFF6FA8FF);
  static const Color tertiary = Color(0xFF7BD0E8);

  static const Color textPrimary = Color(0xFFDCE1EB);
  static const Color textSecondary = Color(0xFFA7ADBA);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: background,
      cardTheme: CardThemeData(
        color: surfaceVariant,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}