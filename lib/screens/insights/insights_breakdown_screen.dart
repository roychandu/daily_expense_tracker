import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../controllers/settings_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../common_widgets/category_progress_bar.dart';

class InsightsBreakdownScreen extends StatelessWidget {
  final List<MapEntry<String, double>> sortedCategories;
  final double totalMonthlyExpense;
  final SettingsController settings;
  final bool isDark;

  const InsightsBreakdownScreen({
    super.key,
    required this.sortedCategories,
    required this.totalMonthlyExpense,
    required this.settings,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.cardDark : AppColors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.spendBreakdownHeadline,
          style: AppTextStyles.h2Section.copyWith(
            fontSize: 20,
            fontFamily: 'Serif',
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.white : AppColors.charcoal,
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: sortedCategories.length,
          itemBuilder: (context, index) {
            final entry = sortedCategories[index];
            final percentage = totalMonthlyExpense > 0
                ? (entry.value / totalMonthlyExpense) * 100
                : 0.0;
            return CategoryProgressBar(
              category: entry.key,
              amount: entry.value,
              percentage: percentage,
              settings: settings,
              isDark: isDark,
            );
          },
        ),
      ),
    );
  }
}
