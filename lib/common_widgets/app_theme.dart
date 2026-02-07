import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryDeepBlue,
        secondary: AppColors.accentTeal,
        error: AppColors.softCoral,
        surface: AppColors.cardLight,
        // background is deprecated in ColorScheme from seed but still used here safely
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        onSurface: AppColors.charcoal,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryDeepBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: _textThemeLight,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.softGray, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accentTeal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.softCoral, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.softCoral, width: 2),
        ),
        hintStyle: AppTextStyles.caption.copyWith(color: AppColors.softGray),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentTeal,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          textStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          minimumSize: const Size.fromHeight(48),
        ),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDeepBlue,
        secondary: AppColors.accentTeal,
        error: AppColors.softCoral,
        surface: AppColors.cardDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        onSurface: AppColors.textDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkNavy, // Or primaryDeepBlue
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      textTheme: _textThemeDark,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.softGray, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accentTeal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.softCoral, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.softCoral, width: 2),
        ),
        hintStyle: AppTextStyles.caption.copyWith(color: AppColors.softGray),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentTeal,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          textStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          minimumSize: const Size.fromHeight(48),
        ),
      ),
    );
  }

  static TextTheme get _textThemeLight {
    return const TextTheme(
      displayLarge: AppTextStyles.h1Display,
      headlineMedium: AppTextStyles.h1Display, // Map for counter text
      titleLarge: AppTextStyles.h2Section,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.body,
      labelLarge: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ), // Button text
      bodySmall: AppTextStyles.caption,
    );
  }

  static TextTheme get _textThemeDark {
    return TextTheme(
      displayLarge: AppTextStyles.h1Display.copyWith(color: AppColors.textDark),
      headlineMedium: AppTextStyles.h1Display.copyWith(
        color: AppColors.textDark,
      ),
      titleLarge: AppTextStyles.h2Section.copyWith(color: AppColors.textDark),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textDark),
      bodyMedium: AppTextStyles.body.copyWith(color: AppColors.textDark),
      labelLarge: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Colors.white,
      ),
      bodySmall: AppTextStyles.caption.copyWith(color: AppColors.softGray),
    );
  }
}
