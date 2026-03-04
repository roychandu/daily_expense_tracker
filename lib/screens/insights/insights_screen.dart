import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../controllers/expense_controller.dart';
import '../../l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../controllers/settings_controller.dart';
import 'locked_insights_screen.dart';
import 'ads_unlock_insights_screen.dart';
import 'premium_insights_screen.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectMonth(BuildContext context) async {
    int selectedYear = _selectedDate.year;
    int selectedMonth = _selectedDate.month;

    final result = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1E1E1E)
                  : Colors.white,
              title: Text(
                AppLocalizations.of(context)!.selectMonth,
                style: TextStyle(fontFamily: 'Serif'),
              ),
              content: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, size: 16),
                          onPressed: () => setDialogState(() => selectedYear--),
                        ),
                        Text(
                          '$selectedYear',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, size: 16),
                          onPressed: () => setDialogState(() => selectedYear++),
                        ),
                      ],
                    ),
                    const Divider(),
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.5,
                          ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        final month = index + 1;
                        final isSelected = selectedMonth == month;
                        return InkWell(
                          onTap: () {
                            setDialogState(() => selectedMonth = month);
                            Navigator.pop(
                              context,
                              DateTime(selectedYear, selectedMonth),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primarySelected
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              DateFormat('MMM').format(DateTime(2022, month)),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white70
                                          : Colors.black87),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedDate = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsController>();
    final expenseController = context.watch<ExpenseController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (expenseController.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final monthTransactions = expenseController.expenses.where((e) {
      return e.date.month == _selectedDate.month &&
          e.date.year == _selectedDate.year;
    }).toList();

    final totalMonthlyIncome = monthTransactions
        .where((e) => !e.isExpense)
        .fold(0.0, (sum, e) => sum + e.amount);

    final totalMonthlyExpense = monthTransactions
        .where((e) => e.isExpense)
        .fold(0.0, (sum, e) => sum + e.amount);

    final netBalance = totalMonthlyIncome - totalMonthlyExpense;

    // Category Breakdown
    final categoryTotals = <String, double>{};
    for (final e in monthTransactions.where((e) => e.isExpense)) {
      categoryTotals[e.category] =
          (categoryTotals[e.category] ?? 0.0) + e.amount;
    }
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Highest Spend Day
    final dayTotals = <String, double>{};
    for (final e in monthTransactions.where((e) => e.isExpense)) {
      final dayKey = DateFormat('yyyy-MM-dd').format(e.date);
      dayTotals[dayKey] = (dayTotals[dayKey] ?? 0.0) + e.amount;
    }
    final highestDayEntry = dayTotals.entries.isEmpty
        ? null
        : (dayTotals.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value)))
              .first;

    DateTime? highestDate;
    if (highestDayEntry != null) {
      highestDate = DateTime.parse(highestDayEntry.key);
    }

    // Most Frequent Category
    final categoryFrequencies = <String, int>{};
    for (final e in monthTransactions.where((e) => e.isExpense)) {
      categoryFrequencies[e.category] =
          (categoryFrequencies[e.category] ?? 0) + 1;
    }
    final mostFrequentCategory = categoryFrequencies.entries.isEmpty
        ? null
        : (categoryFrequencies.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value)))
              .first;

    // Weekly Chart Data
    DateTime chartStartDate;
    if (_selectedDate.month == DateTime.now().month &&
        _selectedDate.year == DateTime.now().year) {
      chartStartDate = DateTime.now().subtract(
        Duration(days: DateTime.now().weekday % 7),
      );
    } else {
      chartStartDate = DateTime(_selectedDate.year, _selectedDate.month, 1);
    }

    List<double> weeklyData = [];
    for (int i = 0; i < 7; i++) {
      final date = chartStartDate.add(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      weeklyData.add(dayTotals[dateStr] ?? 0.0);
    }
    final maxWeekly = weeklyData.isEmpty
        ? 0.0
        : weeklyData.reduce((a, b) => a > b ? a : b);

    // Weekly Income vs Expense calculation
    final weeklyIncome = List.filled(4, 0.0);
    final weeklyExpense = List.filled(4, 0.0);
    for (final e in monthTransactions) {
      int week = ((e.date.day - 1) ~/ 7).clamp(0, 3);
      if (e.isExpense) {
        weeklyExpense[week] += e.amount;
      } else {
        weeklyIncome[week] += e.amount;
      }
    }

    // 6-Month Income Trend
    final sixMonthIncomeData = <Map<String, dynamic>>[];
    for (int i = 5; i >= 0; i--) {
      final monthDate = DateTime(
        _selectedDate.year,
        _selectedDate.month - i,
        1,
      );
      final monthTransactions6 = expenseController.expenses.where((e) {
        return e.date.month == monthDate.month && e.date.year == monthDate.year;
      });
      final monthIncome = monthTransactions6
          .where((e) => !e.isExpense)
          .fold(0.0, (sum, e) => sum + e.amount);
      sixMonthIncomeData.add({
        'month': DateFormat('MMM').format(monthDate),
        'income': monthIncome,
      });
    }

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          l10n.insights,
          style: AppTextStyles.h1Display.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 28,
            fontFamily: 'Serif',
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => expenseController.refreshExpenses(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          clipBehavior: Clip.none,
          physics: const AlwaysScrollableScrollPhysics(),
          child: _buildContent(
            context,
            settings,
            isDark,
            netBalance,
            totalMonthlyIncome,
            totalMonthlyExpense,
            monthTransactions.length,
            sortedCategories,
            highestDate,
            highestDayEntry?.value ?? 0.0,
            weeklyData,
            maxWeekly,
            weeklyIncome,
            weeklyExpense,
            sixMonthIncomeData,
            mostFrequentCategory,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SettingsController settings,
    bool isDark,
    double netBalance,
    double totalMonthlyIncome,
    double totalMonthlyExpense,
    int transactionCount,
    List<MapEntry<String, double>> sortedCategories,
    DateTime? highestDate,
    double highestDayEntryValue,
    List<double> weeklyData,
    double maxWeekly,
    List<double> weeklyIncome,
    List<double> weeklyExpense,
    List<Map<String, dynamic>> sixMonthIncomeData,
    MapEntry<String, int>? mostFrequentCategory,
  ) {
    if (settings.isPremium) {
      return buildPremiumInsightsBody(
        context: context,
        isDark: isDark,
        netBalance: netBalance,
        totalMonthlyIncome: totalMonthlyIncome,
        totalMonthlyExpense: totalMonthlyExpense,
        settings: settings,
        selectedDate: _selectedDate,
        onSelectMonth: () => _selectMonth(context),
        transactionCount: transactionCount,
        sortedCategories: sortedCategories,
        highestDate: highestDate,
        highestDayEntryValue: highestDayEntryValue,
        weeklyData: weeklyData,
        maxWeekly: maxWeekly,
        weeklyIncome: weeklyIncome,
        weeklyExpense: weeklyExpense,
        sixMonthIncomeData: sixMonthIncomeData,
        mostFrequentCategory: mostFrequentCategory,
      );
    } else if (settings.isInsightsUnlockedViaAd) {
      return buildAdsUnlockedInsightsBody(
        context: context,
        isDark: isDark,
        netBalance: netBalance,
        totalMonthlyIncome: totalMonthlyIncome,
        totalMonthlyExpense: totalMonthlyExpense,
        settings: settings,
        selectedDate: _selectedDate,
        onSelectMonth: () => _selectMonth(context),
        transactionCount: transactionCount,
        sortedCategories: sortedCategories,
        highestDate: highestDate,
        highestDayEntryValue: highestDayEntryValue,
        weeklyData: weeklyData,
        maxWeekly: maxWeekly,
        weeklyIncome: weeklyIncome,
        weeklyExpense: weeklyExpense,
        sixMonthIncomeData: sixMonthIncomeData,
        mostFrequentCategory: mostFrequentCategory,
      );
    } else {
      return buildLockedInsightsBody(
        context: context,
        isDark: isDark,
        netBalance: netBalance,
        totalMonthlyIncome: totalMonthlyIncome,
        totalMonthlyExpense: totalMonthlyExpense,
        settings: settings,
        selectedDate: _selectedDate,
        onSelectMonth: () => _selectMonth(context),
        transactionCount: transactionCount,
        sortedCategories: sortedCategories,
      );
    }
  }
}
