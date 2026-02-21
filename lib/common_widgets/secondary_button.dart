import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double? width;
  final double height;

  const SecondaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.width,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark
              ? AppColors.cardDark
              : AppColors.backgroundLight,
          foregroundColor: isDark ? AppColors.textDark : AppColors.charcoal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.softGray, width: 1),
          ),
          elevation: 0,
        ),
        child: Text(
          title,
          style: AppTextStyles.body.copyWith(
            color: isDark ? AppColors.textDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
