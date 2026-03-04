import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../controllers/settings_controller.dart';
import '../../utils/formatters.dart';
import '../../utils/category_utils.dart';
import '../../common_widgets/category_icon.dart';
import '../../utils/app_layout.dart';
import '../history/expense_history_screen.dart';
import '../../l10n/app_localizations.dart';

Widget buildAdsUnlockedInsightsBody({
  required BuildContext context,
  required bool isDark,
  required double netBalance,
  required double totalMonthlyIncome,
  required double totalMonthlyExpense,
  required SettingsController settings,
  required DateTime selectedDate,
  required VoidCallback onSelectMonth,
  required VoidCallback onPreviousMonth,
  required VoidCallback onNextMonth,
  required int transactionCount,
  required List<MapEntry<String, double>> sortedCategories,
  required DateTime? highestDate,
  required double highestDayEntryValue,
  required List<double> weeklyData,
  required double maxWeekly,
  required List<double> weeklyIncome,
  required List<double> weeklyExpense,
  required List<Map<String, dynamic>> sixMonthIncomeData,
  required MapEntry<String, int>? mostFrequentCategory,
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
          isDark: isDark,
        ),
      ),
      const SizedBox(height: 32),
      _smartInsightsSection(
        context: context,
        highestDate: highestDate,
        highestDayEntryValue: highestDayEntryValue,
        weeklyData: weeklyData,
        maxWeekly: maxWeekly,
        settings: settings,
        totalMonthlyExpense: totalMonthlyExpense,
        isDark: isDark,
        mostFrequentCategory: mostFrequentCategory,
      ),
      const SizedBox(height: 32),
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppLayout.horizontalPadding(context),
        ),
        child: _advanceInsightsSection(
          context: context,
          weeklyIncome: weeklyIncome,
          weeklyExpense: weeklyExpense,
          month: DateFormat('MMMM yyyy').format(selectedDate).toUpperCase(),
          isDark: isDark,
          onPreviousMonth: onPreviousMonth,
          onNextMonth: onNextMonth,
        ),
      ),
      const SizedBox(height: 32),
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppLayout.horizontalPadding(context),
        ),
        child: _sixMonthTrendSection(
          context: context,
          sixMonthIncomeData: sixMonthIncomeData,
          isDark: isDark,
        ),
      ),
      const SizedBox(height: 32),
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppLayout.horizontalPadding(context),
        ),
        child: const _PremiumExportLockSection(),
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
          color: AppColors.black.withValues(alpha: isDark ? 0.35 : 0.12),
          blurRadius: 20,
          offset: const Offset(0, 8),
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
            _CalendarButton(isDark: isDark, onTap: onSelectMonth),
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
          style: AppTextStyles.label.copyWith(
            color: isDark ? AppColors.whiteOpacity60 : AppColors.blackOpacity54,
          ),
        ),
        Text(
          AppFormatters.formatCurrency(
            amount,
            settings.currency,
            settings.locale,
          ),
          style: AppTextStyles.amountSmall.copyWith(
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
  required bool isDark,
}) {
  final itemsToShow = sortedCategories.take(4).toList();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.spendBreakdownHeadline,
            style: AppTextStyles.h2Section.copyWith(
              fontSize: 20,
              fontFamily: 'Serif',
            ),
          ),
          Text(
            AppLocalizations.of(context)!.viewInfoText,
            style: AppTextStyles.label.copyWith(
              color: AppColors.accentOrange.withValues(alpha: 0.8),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
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
        return _categoryProgressBar(
          category: entry.key,
          amount: entry.value,
          percentage: percentage,
          settings: settings,
          isDark: isDark,
        );
      }),
      if (sortedCategories.length > 4)
        Center(
          child: TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ExpenseHistoryScreen(),
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

Widget _categoryProgressBar({
  required String category,
  required double amount,
  required double percentage,
  required SettingsController settings,
  required bool isDark,
}) {
  return Padding(
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
                      : AppColors.blackOpacity54,
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
                color: isDark
                    ? AppColors.whiteOpacity10
                    : AppColors.blackOpacity12,
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
}

Widget _smartInsightsSection({
  required BuildContext context,
  required DateTime? highestDate,
  required double highestDayEntryValue,
  required List<double> weeklyData,
  required double maxWeekly,
  required SettingsController settings,
  required double totalMonthlyExpense,
  required bool isDark,
  required MapEntry<String, int>? mostFrequentCategory,
}) {
  final horizontalPadding = AppLayout.horizontalPadding(context);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Text(
          AppLocalizations.of(context)!.smartInsightsHeader,
          style: AppTextStyles.h3Title,
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 200,
        child: ListView(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 20,
          ),
          children: [
            _highestSpendDayCard(
              context,
              highestDate,
              highestDayEntryValue,
              settings,
              weeklyData,
              maxWeekly,
              isDark,
            ),
            const SizedBox(width: 24),
            _dailyAverageCard(
              context,
              totalMonthlyExpense / 30,
              settings,
              isDark,
            ),
            if (mostFrequentCategory != null) ...[
              const SizedBox(width: 24),
              _frequentCategoryCard(
                context,
                mostFrequentCategory.key,
                mostFrequentCategory.value,
                isDark,
              ),
            ],
          ],
        ),
      ),
    ],
  );
}

Widget _frequentCategoryCard(
  BuildContext context,
  String category,
  int count,
  bool isDark,
) {
  return Container(
    width: 280,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? AppColors.cardDark : AppColors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withValues(alpha: isDark ? 0.35 : 0.12),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.mostFrequentCardText,
                    style: AppTextStyles.label.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.white
                          : AppColors.blackOpacity87,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.categoryThisMonthCardText,
                    style: AppTextStyles.micro.copyWith(
                      color: isDark
                          ? AppColors.whiteOpacity70
                          : AppColors.blackOpacity54,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.categoryBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CategoryIcon(category: category, isDark: isDark, size: 24),
            ),
          ],
        ),
        const Spacer(),
        Text(category, style: AppTextStyles.h3Title.copyWith(fontSize: 18)),
        Text(
          '$count transactions',
          style: AppTextStyles.label.copyWith(
            color: isDark ? AppColors.whiteOpacity60 : AppColors.blackOpacity54,
          ),
        ),
      ],
    ),
  );
}

Widget _highestSpendDayCard(
  BuildContext context,
  DateTime? date,
  double amount,
  SettingsController settings,
  List<double> weeklyData,
  double maxWeekly,
  bool isDark,
) {
  String dayLabel = date != null
      ? DateFormat('MMM d, EEEE').format(date)
      : AppLocalizations.of(context)!.noData;
  return Container(
    width: 280,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark
          ? AppColors.primaryUnselected.withValues(alpha: 0.8)
          : AppColors.noteBorder,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withValues(alpha: isDark ? 0.35 : 0.12),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.highestSpendDayHeader,
                    style: AppTextStyles.label.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.white
                          : AppColors.blackOpacity87,
                    ),
                  ),
                  Text(
                    dayLabel,
                    style: AppTextStyles.micro.copyWith(
                      color: isDark
                          ? AppColors.whiteOpacity70
                          : AppColors.blackOpacity54,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              AppFormatters.formatCurrency(
                amount,
                settings.currency,
                settings.locale,
              ),
              style: AppTextStyles.h3Title.copyWith(fontSize: 18),
            ),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(7, (index) {
            final val = weeklyData[index];
            final barHeight = maxWeekly > 0 ? (val / maxWeekly) * 30 : 2.0;
            return Container(
              width: 28,
              height: barHeight.clamp(4.0, 30.0),
              decoration: BoxDecoration(
                color: val == amount && amount > 0
                    ? AppColors.accentOrange
                    : (isDark ? AppColors.whiteOpacity24 : AppColors.white),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
      ],
    ),
  );
}

Widget _dailyAverageCard(
  BuildContext context,
  double dailyAvg,
  SettingsController settings,
  bool isDark,
) {
  return Container(
    width: 280,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: isDark ? AppColors.cardDark : AppColors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withValues(alpha: isDark ? 0.35 : 0.12),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppFormatters.formatCurrency(
            dailyAvg,
            settings.currency,
            settings.locale,
          ),
          style: AppTextStyles.amountDisplay.copyWith(
            fontSize: 26,
            color: isDark ? AppColors.white : AppColors.charcoal,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.dailyAverageMetrics,
          style: AppTextStyles.label.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        const Spacer(),
        Text(
          AppLocalizations.of(context)!.thisMonthActivity,
          style: AppTextStyles.labelSmall.copyWith(
            color: isDark ? AppColors.whiteOpacity24 : Colors.grey,
          ),
        ),
      ],
    ),
  );
}

Widget _advanceInsightsSection({
  required BuildContext context,
  required List<double> weeklyIncome,
  required List<double> weeklyExpense,
  required String month,
  required bool isDark,
  required VoidCallback onPreviousMonth,
  required VoidCallback onNextMonth,
}) {
  double maxVal = 0;
  for (int i = 0; i < 4; i++) {
    if (weeklyIncome[i] > maxVal) maxVal = weeklyIncome[i];
    if (weeklyExpense[i] > maxVal) maxVal = weeklyExpense[i];
  }
  if (maxVal == 0) maxVal = 1000;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        AppLocalizations.of(context)!.advanceInsightsAnalytics,
        style: AppTextStyles.h3Title,
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 200,
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.monthlyComparisonAnalytics,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onPreviousMonth,
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        month,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.accentOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onNextMonth,
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(4, (index) {
                  return _weeklyComparisonBar(
                    weeklyIncome[index],
                    weeklyExpense[index],
                    maxVal,
                    'WK ${index + 1}',
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _weeklyComparisonBar(
  double income,
  double expense,
  double maxVal,
  String label,
) {
  const double chartHeight = 80.0;
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 10,
            height: (income / maxVal * chartHeight).clamp(4, chartHeight),
            decoration: BoxDecoration(
              color: AppColors.successGreen,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 4),
          Container(
            width: 10,
            height: (expense / maxVal * chartHeight).clamp(4, chartHeight),
            decoration: BoxDecoration(
              color: AppColors.softCoral,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.softGray,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Widget _sixMonthTrendSection({
  required BuildContext context,
  required List<Map<String, dynamic>> sixMonthIncomeData,
  required bool isDark,
}) {
  double maxIncome = 0;
  for (var d in sixMonthIncomeData) {
    if (d['income'] > maxIncome) maxIncome = d['income'];
  }
  if (maxIncome == 0) maxIncome = 1000;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        AppLocalizations.of(context)!.sixMonthIncomeAnalytics,
        style: AppTextStyles.h3Title,
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 200,
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(sixMonthIncomeData.length, (index) {
              final data = sixMonthIncomeData[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: (data['income'] / maxIncome * 110).clamp(
                      10.0,
                      110.0,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.orange, Colors.deepOrange],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data['month'].toString().toUpperCase(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    ],
  );
}

class _PremiumExportLockSection extends StatelessWidget {
  const _PremiumExportLockSection();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E30) : const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: isDark ? 0.4 : 0.15),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              isDark
                  ? 'assets/images/premium-export-dark-bg.png'
                  : 'assets/images/premium-export-light-bg.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 180,
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.premiumExportTitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h3Title.copyWith(
                      fontSize: 18,
                      color: isDark ? AppColors.white : AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.unlockProfessionalDetails,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.label.copyWith(
                      color: isDark
                          ? AppColors.whiteOpacity70
                          : AppColors.softGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<SettingsController>().updatePremium(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.goPremiumBtn,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;
  const _CalendarButton({required this.isDark, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.calendar_month_outlined,
          color: Colors.orange,
          size: 20,
        ),
      ),
    );
  }
}
