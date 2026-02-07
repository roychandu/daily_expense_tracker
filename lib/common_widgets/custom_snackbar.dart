import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

void showCustomSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: AppTextStyles.body.copyWith(color: Colors.white),
      ),
      backgroundColor: isError ? AppColors.softCoral : AppColors.charcoal,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      duration: const Duration(seconds: 3),
    ),
  );
}
