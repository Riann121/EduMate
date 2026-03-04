import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  // App Main Theme
  ThemeData AppThemeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.surface,
      textTheme: _textTheme(),
      colorScheme: _colorScheme(),
      appBarTheme: _appBarTheme(),
      elevatedButtonTheme: _elevatedButtonTheme(),
      inputDecorationTheme: _inputDecorationTheme(),
      cardTheme: _cardTheme(),
    );
  }

  //helper methods to build theme components
  TextTheme _textTheme() {
    return GoogleFonts.montserratTextTheme().apply( //copy default theme and override it
      bodyColor: AppColors.onSurface,
      displayColor: AppColors.onSurface,
    );
  }

  ColorScheme _colorScheme() {
    return ColorScheme.fromSeed(
      seedColor: AppColors.primary, //main theme color
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary, //overriden the specific colors from the seed
      onPrimary: AppColors.onPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
    );
  }

  AppBarTheme _appBarTheme() {
    return const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
    );
  }

  ElevatedButtonThemeData _elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
    );
  }

  InputDecorationTheme _inputDecorationTheme() {
    return const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide.none,
      ),
    );
  }

  CardThemeData _cardTheme() {
    return const CardThemeData(
      color: AppColors.surfaceContainerHighest,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black26,
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        side: BorderSide(color: Color(0xFFD0D0D0), width: 1.5),
      ),
    );
  }
}
