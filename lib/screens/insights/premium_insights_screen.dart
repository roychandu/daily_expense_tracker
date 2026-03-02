import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../controllers/settings_controller.dart';
import '../../utils/formatters.dart';
import '../../utils/category_utils.dart';
import '../history/expense_history_screen.dart';
import '../../services/export_service.dart';
import '../../services/database_service.dart';
import '../../common_widgets/custom_snackbar.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/app_layout.dart';

Widget buildPremiumInsightsBody({
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
          isDark: isDark,
          netBalance: netBalance,
          totalMonthlyIncome: totalMonthlyIncome,
          totalMonthlyExpense: totalMonthlyExpense,
          settings: settings,
          selectedDate: selectedDate,
          onSelectMonth: onSelectMonth,
          transactionCount: transactionCount,
          isPremium: true,
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
          weeklyIncome: weeklyIncome,
          weeklyExpense: weeklyExpense,
          month: DateFormat('MMM').format(selectedDate).toUpperCase(),
          isDark: isDark,
        ),
      ),
      const SizedBox(height: 32),
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppLayout.horizontalPadding(context),
        ),
        child: _sixMonthTrendSection(
          sixMonthIncomeData: sixMonthIncomeData,
          isDark: isDark,
        ),
      ),
      const SizedBox(height: 32),
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppLayout.horizontalPadding(context),
        ),
        child: const _ReportSection(),
      ),
    ],
  );
}

Widget _summarySection({
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
  final contentColor = isDark ? Colors.white : Colors.black87;
  final secondaryColor = isDark ? Colors.white70 : Colors.black54;

  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              isDark
                  ? 'assets/images/premium-main-card-dark-bg.png'
                  : 'assets/images/premium-main-card-light-bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${DateFormat('MMMM').format(selectedDate).toUpperCase()} SUMMARY',
                      style: AppTextStyles.caption.copyWith(
                        letterSpacing: 1.2,
                        color: secondaryColor,
                        fontSize: 11,
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
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Serif',
                      color: contentColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : Colors.black).withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 14,
                        color: secondaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$transactionCount Transactions',
                        style: TextStyle(
                          fontSize: 12,
                          color: contentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _summaryItem(
                      'Income',
                      totalMonthlyIncome,
                      AppColors.successGreen,
                      isDark,
                      settings,
                    ),
                    const SizedBox(width: 16),
                    _summaryItem(
                      'Expense',
                      totalMonthlyExpense,
                      AppColors.softCoral,
                      isDark,
                      settings,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
  final secondaryColor = isDark ? Colors.white70 : Colors.black54;

  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: secondaryColor, fontSize: 12)),
        Text(
          AppFormatters.formatCurrency(
            amount,
            settings.currency,
            settings.locale,
          ),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
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
            'Spending Breakdown',
            style: AppTextStyles.h2Section.copyWith(
              fontSize: 20,
              fontFamily: 'Serif',
            ),
          ),
          Text(
            'VIEW ALL',
            style: TextStyle(
              color: AppColors.primarySelected,
              fontSize: 12,
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
                const Text(
                  'View Full Breakdown',
                  style: TextStyle(
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
            Image.asset(
              CategoryUtils.getIcon(category, isDark: isDark),
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                category,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87,
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
              style: const TextStyle(fontWeight: FontWeight.bold),
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
                  color: AppColors.primarySelected,
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
        child: const Text(
          'Smart Insights',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Serif',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 160,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          children: [
            _highestSpendDayCard(
              highestDate,
              highestDayEntryValue,
              settings,
              weeklyData,
              maxWeekly,
              isDark,
            ),
            const SizedBox(width: 16),
            _dailyAverageCard(totalMonthlyExpense / 30, settings, isDark),
            if (mostFrequentCategory != null) ...[
              const SizedBox(width: 16),
              _frequentCategoryCard(
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

Widget _frequentCategoryCard(String category, int count, bool isDark) {
  return Container(
    width: 280,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
          blurRadius: 15,
          offset: const Offset(0, 5),
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
                    'Most Frequent',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    'Category this month',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                CategoryUtils.getIcon(category, isDark: isDark),
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
        const Spacer(),
        Text(
          category,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Serif',
          ),
        ),
        Text(
          '$count transactions',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
      ],
    ),
  );
}

Widget _highestSpendDayCard(
  DateTime? date,
  double amount,
  SettingsController settings,
  List<double> weeklyData,
  double maxWeekly,
  bool isDark,
) {
  String dayLabel = date != null
      ? DateFormat('MMM d, EEEE').format(date)
      : 'No Data';
  return Container(
    width: 280,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark
          ? const Color(0xFF8B5E3C).withValues(alpha: 0.8)
          : const Color(0xFFFFE5D0),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
          blurRadius: 15,
          offset: const Offset(0, 5),
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
                    'Highest Spend Day',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    dayLabel,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.white70 : Colors.black54,
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'Serif',
              ),
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
                    ? Colors.orange
                    : (isDark ? Colors.white24 : Colors.white),
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
  double dailyAvg,
  SettingsController settings,
  bool isDark,
) {
  return Container(
    width: 280,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
          blurRadius: 15,
          offset: const Offset(0, 5),
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            fontFamily: 'Serif',
          ),
        ),
        const Text(
          'Daily Average',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        const Spacer(),
        Text(
          'Based on this month\'s activity',
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white30 : Colors.grey,
          ),
        ),
      ],
    ),
  );
}

Widget _advanceInsightsSection({
  required List<double> weeklyIncome,
  required List<double> weeklyExpense,
  required String month,
  required bool isDark,
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
      const Text(
        'Advance Insights',
        style: TextStyle(
          fontSize: 20,
          fontFamily: 'Serif',
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 200,
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Monthly Comparison Trend',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    month,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
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
      Text(label, style: const TextStyle(fontSize: 8, color: Colors.grey)),
    ],
  );
}

Widget _sixMonthTrendSection({
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
      const Text(
        '6-Month Income Trend',
        style: TextStyle(
          fontSize: 20,
          fontFamily: 'Serif',
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 200,
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
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
                    style: const TextStyle(fontSize: 8, color: Colors.grey),
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

class _ReportSection extends StatelessWidget {
  const _ReportSection();

  void _onExport(BuildContext context, bool isCsv) async {
    final l10n = AppLocalizations.of(context)!;
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primarySelected),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (!context.mounted) return;
      showCustomSnackBar(
        context,
        isCsv ? l10n.generatingCsv : l10n.generatingPdf,
      );

      final expenses = await DatabaseService.instance.readExpensesByDateRange(
        picked.start,
        picked.end,
      );

      if (expenses.isEmpty) {
        if (!context.mounted) return;
        showCustomSnackBar(context, l10n.noDataFound, isError: true);
        return;
      }

      final fileName =
          'Expenses_${DateFormat('yyyyMMdd').format(picked.start)}_${DateFormat('yyyyMMdd').format(picked.end)}';

      String? result;
      if (isCsv) {
        result = await ExportService.exportToCSV(
          expenses,
          fileName,
          headers: [
            l10n.reportID,
            l10n.reportDate,
            l10n.reportCategory,
            l10n.reportAmount,
            l10n.reportType,
            l10n.reportNote,
          ],
          expenseLabel: l10n.expense,
          incomeLabel: l10n.income,
          fileSavedLabel: l10n.fileSavedTo,
          errorLabel: l10n.error,
          noDirLabel: l10n.couldNotFindExportDir,
        );
      } else {
        result = await ExportService.exportToPDF(
          expenses,
          fileName,
          picked.start,
          picked.end,
          headers: [
            l10n.reportDate,
            l10n.reportCategory,
            l10n.reportType,
            l10n.reportAmount,
            l10n.reportNote,
          ],
          reportTitle: l10n.expenseReport,
          totalExpenseLabel: l10n.totalExpenses,
          totalIncomeLabel: l10n.totalIncome,
          expLabelShort: 'Exp',
          incLabelShort: 'Inc',
          fileSavedLabel: l10n.fileSavedTo,
          errorLabel: l10n.error,
          noDirLabel: l10n.couldNotFindExportDir,
        );
      }

      if (!context.mounted) return;
      if (result != null && result.startsWith('File saved')) {
        showCustomSnackBar(context, result);
      } else {
        showCustomSnackBar(context, result ?? 'Unknown error', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        InkWell(
          onTap: () => _onExport(context, true),
          borderRadius: BorderRadius.circular(16),
          child: _reportItem(
            Icons.download_for_offline,
            'Export Transaction History',
            'CSV',
            isDark,
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => _onExport(context, false),
          borderRadius: BorderRadius.circular(16),
          child: _reportItem(
            Icons.picture_as_pdf,
            'Annual Financial Report',
            'PDF',
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _reportItem(IconData icon, String label, String tag, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ],
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
          color: (AppColors.primarySelected).withValues(alpha: 0.4),
          border: Border.all(color: AppColors.primarySelected, width: 2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.calendar_month_outlined,
          color: AppColors.primarySelected,
          size: 26,
        ),
      ),
    );
  }
}
