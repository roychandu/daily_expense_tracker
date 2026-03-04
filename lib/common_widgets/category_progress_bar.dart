import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import '../../controllers/settings_controller.dart';
import '../../utils/formatters.dart';
import '../../utils/category_utils.dart';
import 'category_icon.dart';

class CategoryProgressBar extends StatelessWidget {
  final String category;
  final double amount;
  final double percentage;
  final SettingsController settings;
  final bool isDark;
  final bool isBlurred;

  const CategoryProgressBar({
    super.key,
    required this.category,
    required this.amount,
    required this.percentage,
    required this.settings,
    required this.isDark,
    this.isBlurred = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              CategoryIcon(category: category, isDark: isDark, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.whiteOpacity70
                        : AppColors.blackOpacity87,
                  ),
                ),
              ),
              Text(
                AppFormatters.formatCurrency(
                  amount,
                  settings.currency,
                  settings.locale,
                  decimalDigits: 0,
                ),
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.black12,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: (percentage / 100).clamp(0.01, 1.0),
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: CategoryUtils.getColor(category),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (isBlurred) {
      return ClipRect(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: content,
        ),
      );
    }
    return content;
  }
}
