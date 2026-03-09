import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../controllers/settings_controller.dart';
import '../../models/expense.dart';
import '../../utils/formatters.dart';
import '../../common_widgets/category_icon.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/app_layout.dart';
import 'insights_breakdown_screen.dart';
import '../../common_widgets/category_progress_bar.dart';
import '../../common_widgets/premium_export_lock_section.dart';

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
  required List<Expense> monthTransactions,
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
        monthTransactions: monthTransactions,
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
        child: const PremiumExportLockSection(),
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
          isDark: isDark,
        );
      }),
      if (sortedCategories.length > 4)
        Center(
          child: TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InsightsBreakdownScreen(
                  sortedCategories: sortedCategories,
                  totalMonthlyExpense: totalMonthlyExpense,
                  settings: settings,
                  isDark: isDark,
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
  required List<Expense> monthTransactions,
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
              monthTransactions,
            ),
            if (mostFrequentCategory != null) ...[
              const SizedBox(width: 24),
              _frequentCategoryCard(
                context,
                mostFrequentCategory.key,
                mostFrequentCategory.value,
                isDark,
                settings,
                monthTransactions,
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
  SettingsController settings,
  List<Expense> monthTransactions,
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
        const SizedBox(height: 12),
        Text(category, style: AppTextStyles.h3Title.copyWith(fontSize: 18)),
        Text(
          '$count transactions',
          style: AppTextStyles.label.copyWith(
            color: isDark ? AppColors.whiteOpacity60 : AppColors.blackOpacity54,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _getFrequentCategoryInsight(
            category,
            count,
            monthTransactions,
            settings,
          ),
          style: AppTextStyles.micro.copyWith(
            color: isDark ? AppColors.whiteOpacity70 : AppColors.softGray,
            fontStyle: FontStyle.italic,
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
  List<Expense> monthTransactions,
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
        const SizedBox(height: 12),
        Text(
          AppLocalizations.of(context)!.thisMonthActivity,
          style: AppTextStyles.labelSmall.copyWith(
            color: isDark ? AppColors.whiteOpacity24 : Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _getDailyAverageInsight(dailyAvg, monthTransactions, settings),
          style: AppTextStyles.micro.copyWith(
            color: isDark ? AppColors.whiteOpacity70 : AppColors.softGray,
            fontStyle: FontStyle.italic,
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

String _getFrequentCategoryInsight(
  String category,
  int count,
  List<Expense> monthTransactions,
  SettingsController settings,
) {
  final categoryExpenses = monthTransactions
      .where((e) => e.isExpense && e.category == category)
      .toList();
  final totalCatAmount = categoryExpenses.fold(0.0, (sum, e) => sum + e.amount);

  final nameTotals = <String, double>{};
  for (final e in categoryExpenses) {
    final name = e.note.isNotEmpty ? e.note : e.category;
    nameTotals[name] = (nameTotals[name] ?? 0.0) + e.amount;
  }

  final sortedNames = nameTotals.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final top3Names = sortedNames.take(3).map((e) => e.key).join(', ');

  final formattedAmount = AppFormatters.formatCurrency(
    totalCatAmount,
    settings.currency,
    settings.locale,
  );
  return "Like you spent total of $formattedAmount on this category with top spending from: $top3Names";
}

String _getDailyAverageInsight(
  double dailyAvg,
  List<Expense> monthTransactions,
  SettingsController settings,
) {
  final expenses = monthTransactions.where((e) => e.isExpense).toList();
  final totalMonth = expenses.fold(0.0, (sum, e) => sum + e.amount);

  final dayTotals = <String, double>{};
  for (final e in expenses) {
    final dayKey = DateFormat('yyyy-MM-dd').format(e.date);
    dayTotals[dayKey] = (dayTotals[dayKey] ?? 0.0) + e.amount;
  }

  final highestDayEntry = dayTotals.entries.isEmpty
      ? null
      : (dayTotals.entries.toList()..sort((a, b) => b.value.compareTo(a.value)))
            .first;
  final formattedTotal = AppFormatters.formatCurrency(
    totalMonth,
    settings.currency,
    settings.locale,
  );

  if (highestDayEntry != null) {
    final formattedHighest = AppFormatters.formatCurrency(
      highestDayEntry.value,
      settings.currency,
      settings.locale,
    );
    final dayLabel = DateFormat(
      'MMM d',
    ).format(DateTime.parse(highestDayEntry.key));
    return "You've spent a total of $formattedTotal this month. Highest daily spend was $formattedHighest on $dayLabel.";
  }
  return "You haven't recorded any expenses yet to calculate a daily average.";
}
