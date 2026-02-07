import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static const TextStyle h1Display = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.bold,
    fontSize: 32,
    height: 40 / 32,
    color: AppColors.charcoal,
  );

  static const TextStyle h2Section = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 24,
    height: 32 / 24,
    color: AppColors.charcoal,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 18,
    height: 26 / 18,
    color: AppColors.charcoal,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 24 / 16,
    color: AppColors.charcoal,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 20 / 14,
    color: AppColors.softGray,
  );

  static const TextStyle amountDisplay = TextStyle(
    fontFamily: 'Roboto Mono',
    fontWeight: FontWeight.w600,
    fontSize: 28,
    height: 36 / 28,
    color: AppColors.charcoal,
  );
}
