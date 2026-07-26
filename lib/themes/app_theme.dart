import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color primary = Color(0xFFE85D24);
  static const Color secondary = Color(0xFFFFA15C);
  static const Color lightBackground = Color(0xFFFFFAF5);
  static const Color darkBackground = Color(0xFF24160F);

  static ThemeData lightTheme() {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        secondary: secondary,
        primaryContainer: const Color(0xFFFFD8BF),
        secondaryContainer: const Color(0xFFFFE6D5),
        surface: lightBackground,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: lightBackground,
      fontFamily: 'sans',
    );
    return base.copyWith(
      appBarTheme: base.appBarTheme.copyWith(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: lightBackground,
        foregroundColor: const Color(0xFF24160F),
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          color: const Color(0xFF24160F),
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
      ),
      textTheme: base.textTheme.copyWith(
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: const Color(0xFF2B2118),
        ),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF4D4035),
        ),
      ),
      cardTheme: base.cardTheme.copyWith(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFFFE0CC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: primary, width: 1.4),
        ),
        hintStyle: const TextStyle(color: Color(0xFF8C7465)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: primary,
          foregroundColor: Colors.white,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          foregroundColor: primary,
          side: const BorderSide(color: Color(0xFFE85D24)),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        selectedColor: const Color(0xFFFFD8BF),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        elevation: 0,
        backgroundColor: Colors.white,
        selectedItemColor: primary,
        unselectedItemColor: const Color(0xFF9A8A80),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }

  static ThemeData darkTheme() {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        secondary: secondary,
        brightness: Brightness.dark,
        surface: darkBackground,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: darkBackground,
    );
    return base.copyWith(
      appBarTheme: base.appBarTheme.copyWith(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: darkBackground,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
      ),
      textTheme: base.textTheme.copyWith(
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: base.cardTheme.copyWith(
        elevation: 2,
        color: const Color(0xFF2B2C2F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: const Color(0xFF303134),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: primary, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: primary,
          foregroundColor: Colors.white,
        ),
      ),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        elevation: 0,
        backgroundColor: const Color(0xFF202124),
        selectedItemColor: primary,
        unselectedItemColor: const Color(0xFF9E9E9E),
      ),
    );
  }
}
