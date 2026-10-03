import 'package:flutter/material.dart';

/// Central color palette + theme for CinElite, matched to the
/// navy / light-blue palette used throughout the original mockups.
class AppColors {
  AppColors._();

  static const Color navy = Color(0xFF1B3A5C); // primary / header / footer
  static const Color navyDark = Color(0xFF122A44); // footer / deep shade
  static const Color skyLight = Color(0xFFDCE7FA); // page background
  static const Color pillUnselected = Color(0xFFB9D3EF); // inactive tab pill
  static const Color card = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF152A3E);
  static const Color textMuted = Color(0xFF5E7288);
  static const Color available = Color(0xFF3E63A0); // seat available (blue)
  static const Color selected = Color(0xFF34A853); // seat selected (green)
  static const Color unavailable = Color(0xFFB0B7C1); // seat unavailable
  static const Color gcash = Color(0xFF0074E4);
  static const Color grabpay = Color(0xFF00B14F);
  static const Color danger = Color(0xFFD64545);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.navy,
        primary: AppColors.navy,
        surface: AppColors.skyLight,
      ),
      scaffoldBackgroundColor: AppColors.skyLight,
      fontFamily: 'Roboto',
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.navy,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.navy,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textDark,
        displayColor: AppColors.textDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          minimumSize: const Size(64, 48), // WCAG 2.1 SC 2.5.5 touch target
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          side: const BorderSide(color: AppColors.navy, width: 1.4),
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.navy, width: 1.6),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  /// High-contrast theme toggle referenced in the assistive-design
  /// section of the project (dark background, white text, yellow accent).
  static ThemeData get highContrast {
    const yellow = Color(0xFFFFD400);
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: const ColorScheme.dark(
        primary: yellow,
        secondary: yellow,
        surface: Color(0xFF121212),
      ),
    );
    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: yellow,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: yellow,
          fontSize: 22,
          fontWeight: FontWeight.w900,
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: yellow,
          foregroundColor: Colors.black,
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1B1B1B),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: yellow, width: 1),
        ),
      ),
    );
  }
}
