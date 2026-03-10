import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Widget? icon;
  final double iconSize;
  final double? width;
  final double height;
  final Color? borderColor;
  final Color? textColor;

  const SecondaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.icon,
    this.iconSize = 24,
    this.width,
    this.height = 48,
    this.borderColor,
    this.textColor,
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
          foregroundColor: textColor ?? (isDark ? AppColors.textDark : AppColors.charcoal),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: borderColor ?? AppColors.softGray, width: 1),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              SizedBox(width: iconSize, height: iconSize, child: icon),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: AppTextStyles.body.copyWith(
                color: textColor ?? (isDark ? AppColors.textDark : AppColors.charcoal),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
