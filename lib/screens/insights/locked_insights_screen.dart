import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/category_progress_bar.dart';
import '../../controllers/settings_controller.dart';
import '../../utils/formatters.dart';
import '../../utils/app_layout.dart';
import 'dart:ui';
import '../../l10n/app_localizations.dart';
import 'insights_breakdown_screen.dart';
import '../premium/unlock_premium_screen.dart';
import '../../common_widgets/custom_snackbar.dart';
import '../../services/ad_service.dart';

Widget buildLockedInsightsBody({
  required BuildContext context,
  required bool isDark,
  required double netBalance,
  required double totalMonthlyIncome,
  required double totalMonthlyExpense,
  required SettingsController settings,
  required DateTime selectedDate,
  required VoidCallback onSelectMonth,
  required int transactionCount,
  required List<MapEntry<String, double>> sortedCategories,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppLayout.horizontalPadding(context),
        ),
        child: _summarySection(
          context: context,
          isDark: isDark,
          netBalance: netBalance,
          totalMonthlyIncome: totalMonthlyIncome,
          totalMonthlyExpense: totalMonthlyExpense,
          settings: settings,
          selectedDate: selectedDate,
          onSelectMonth: onSelectMonth,
          transactionCount: transactionCount,
          isPremium: false,
        ),
      ),
      const SizedBox(height: 32),
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppLayout.horizontalPadding(context),
        ),
        child: _spendingBreakdownSection(
          context: context,
          sortedCategories: sortedCategories,
          totalMonthlyExpense: totalMonthlyExpense,
          settings: settings,
          isLocked: true,
        ),
      ),
      const SizedBox(height: 32),
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppLayout.horizontalPadding(context),
        ),
        child: const _LockedInsightsCard(),
      ),
    ],
  );
}

Widget _summarySection({
  required BuildContext context,
  required bool isDark,
  required double netBalance,
  required double totalMonthlyIncome,
  required double totalMonthlyExpense,
  required SettingsController settings,
  required DateTime selectedDate,
  required VoidCallback onSelectMonth,
  required int transactionCount,
  required bool isPremium,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: isDark ? AppColors.cardDark : AppColors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withValues(alpha: isDark ? 0.3 : 0.1),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${DateFormat('MMMM').format(selectedDate).toUpperCase()} ${AppLocalizations.of(context)!.summary.toUpperCase()}',
              style: AppTextStyles.labelSmall.copyWith(
                letterSpacing: 1.2,
                color: isDark
                    ? AppColors.whiteOpacity60
                    : AppColors.blackOpacity54,
              ),
            ),
            GestureDetector(
              onTap: onSelectMonth,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentOrange.withValues(
                    alpha: isDark ? 0.3 : 0.1,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.accentOrange,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            AppFormatters.formatCurrency(
              netBalance,
              settings.currency,
              settings.locale,
            ),
            style: AppTextStyles.amountDisplay.copyWith(
              fontSize: 36,
              color: isDark ? AppColors.white : AppColors.charcoal,
            ),
          ),
        ),
        Text(
          AppLocalizations.of(context)!.netBalanceStr,
          style: AppTextStyles.label.copyWith(
            color: AppColors.successGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _summaryItem(
              AppLocalizations.of(context)!.income,
              totalMonthlyIncome,
              AppColors.successGreen,
              isDark,
              settings,
            ),
            const SizedBox(width: 16),
            _summaryItem(
              AppLocalizations.of(context)!.expense,
              totalMonthlyExpense,
              AppColors.softCoral,
              isDark,
              settings,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _summaryItem(
  String label,
  double amount,
  Color color,
  bool isDark,
  SettingsController settings,
) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isDark ? AppColors.whiteOpacity60 : AppColors.blackOpacity54,
          ),
        ),
        Text(
          AppFormatters.formatCurrency(
            amount,
            settings.currency,
            settings.locale,
          ),
          style: AppTextStyles.amountLarge.copyWith(
            color: color,
            fontFamily: 'Serif',
          ),
        ),
      ],
    ),
  );
}

Widget _spendingBreakdownSection({
  required BuildContext context,
  required List<MapEntry<String, double>> sortedCategories,
  required double totalMonthlyExpense,
  required SettingsController settings,
  required bool isLocked,
}) {
  final itemsToShow = sortedCategories.take(3).toList();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.topSpendBreakdownText,
            style: AppTextStyles.h2Section.copyWith(
              fontSize: 20,
              fontFamily: 'Serif',
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      ...List.generate(itemsToShow.length, (index) {
        final entry = itemsToShow[index];
        final percentage = totalMonthlyExpense > 0
            ? (entry.value / totalMonthlyExpense) * 100
            : 0.0;
        return CategoryProgressBar(
          category: entry.key,
          amount: entry.value,
          percentage: percentage,
          settings: settings,
          isBlurred: isLocked && index == 2,
          isDark: settings.themeMode == ThemeMode.dark, // Simplified
        );
      }),
      if (sortedCategories.length > 3 && !isLocked)
        Center(
          child: TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InsightsBreakdownScreen(
                  sortedCategories: sortedCategories,
                  totalMonthlyExpense: totalMonthlyExpense,
                  settings: settings,
                  isDark: settings.themeMode == ThemeMode.dark,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.viewFullBreakdownTxt,
                  style: AppTextStyles.label.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        ),
    ],
  );
}

class _LockedInsightsCard extends StatelessWidget {
  const _LockedInsightsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.deepBlue,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.4),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
        image: const DecorationImage(
          image: AssetImage('assets/images/locked-card-bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: AppColors.accentOrange,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.unlockWatchFullInsights,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _bulletItem(
            context,
            AppLocalizations.of(context)!.detailedSpendingBreakdown,
          ),
          _bulletItem(
            context,
            AppLocalizations.of(context)!.smartTailoredInsights,
          ),
          _bulletItem(
            context,
            AppLocalizations.of(context)!.weeklyIncVsExpTrend,
          ),
          _bulletItem(context, AppLocalizations.of(context)!.monthlyTrend),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UnlockPremiumScreen(),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentOrange,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.upgradeNowBtn,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    AdService().showRewardedAd(
                      onAdFailed: (message) {
                        showCustomSnackBar(context, message);
                      },
                      onRewardEarned: () async {
                        await context
                            .read<SettingsController>()
                            .unlockInsightsViaAd();
                        if (context.mounted) {
                          showCustomSnackBar(
                            context,
                            'Insights unlocked for 2 minutes! 🔓',
                          );
                        }
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.accentOrange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.watchAdsTxt,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bulletItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: AppColors.whiteOpacity70),
          const SizedBox(width: 12),
          Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.whiteOpacity70,
            ),
          ),
        ],
      ),
    );
  }
}
