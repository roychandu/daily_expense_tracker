import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class TertiaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const TertiaryButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primarySelected,
        textStyle: AppTextStyles.body.copyWith(
          color: AppColors.primarySelected,
          decoration: TextDecoration.underline,
        ),
      ),
      child: Text(title),
    );
  }
}
