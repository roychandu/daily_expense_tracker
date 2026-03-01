import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../controllers/expense_controller.dart';
import '../../l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../controllers/settings_controller.dart';
import '../../utils/formatters.dart';
import '../../utils/category_utils.dart';
import '../history/expense_history_screen.dart';
import 'dart:ui';

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
              title: const Text(
                'Select Month',
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

    // Category Breakdown (Expenses only)
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

    final isLocked = !settings.isPremium;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : AppColors.backgroundLight,
      appBar: _buildAppBar(l10n),
      body: RefreshIndicator(
        onRefresh: () => expenseController.refreshExpenses(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 32),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SummarySection(
                isDark: isDark,
                netBalance: netBalance,
                totalMonthlyIncome: totalMonthlyIncome,
                totalMonthlyExpense: totalMonthlyExpense,
                settings: settings,
                selectedDate: _selectedDate,
                onSelectMonth: () => _selectMonth(context),
              ),
              const SizedBox(height: 32),
              _SpendingBreakdownSection(
                sortedCategories: sortedCategories,
                totalMonthlyExpense: totalMonthlyExpense,
                settings: settings,
                isLocked: isLocked,
              ),
              const SizedBox(height: 32),
              _SmartInsightsSection(
                highestDate: highestDate,
                highestDayEntryValue: highestDayEntry?.value ?? 0,
                weeklyData: weeklyData,
                maxWeekly: maxWeekly,
                settings: settings,
                sortedCategories: sortedCategories,
                totalMonthlyExpense: totalMonthlyExpense,
                selectedDate: _selectedDate,
              ),
              if (isLocked) ...[
                const SizedBox(height: 32),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _LockedInsightsCard(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations l10n) {
    return AppBar(
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
    );
  }
}

class _SummarySection extends StatelessWidget {
  final bool isDark;
  final double netBalance;
  final double totalMonthlyIncome;
  final double totalMonthlyExpense;
  final SettingsController settings;
  final DateTime selectedDate;
  final VoidCallback onSelectMonth;

  const _SummarySection({
    required this.isDark,
    required this.netBalance,
    required this.totalMonthlyIncome,
    required this.totalMonthlyExpense,
    required this.settings,
    required this.selectedDate,
    required this.onSelectMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.4)
                  : Colors.black.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 12),
              spreadRadius: 2,
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
                  '${DateFormat('MMMM').format(selectedDate).toUpperCase()} SUMMARY',
                  style: AppTextStyles.caption.copyWith(
                    letterSpacing: 1.2,
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isDark
                        ? Border.all(color: AppColors.primarySelected, width: 2)
                        : null,
                    color: isDark
                        ? AppColors.primarySelected.withOpacity(0.4)
                        : null,
                  ),
                  child: IconButton(
                    onPressed: onSelectMonth,
                    icon: const Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.orange,
                      size: 24,
                    ),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                AppFormatters.formatCurrency(
                  netBalance,
                  settings.currency,
                  settings.locale,
                ),
                style: AppTextStyles.amountDisplay.copyWith(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Serif',
                ),
              ),
            ),
            Text(
              'Net Balance',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.successGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _SummaryItem(
                  label: 'Income',
                  amount: totalMonthlyIncome,
                  color: AppColors.successGreen,
                  isDark: isDark,
                  settings: settings,
                ),
                _SummaryItem(
                  label: 'Expense',
                  amount: totalMonthlyExpense,
                  color: AppColors.softCoral,
                  isDark: isDark,
                  settings: settings,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final bool isDark;
  final SettingsController settings;

  const _SummaryItem({
    required this.label,
    required this.amount,
    required this.color,
    required this.isDark,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              AppFormatters.formatCurrency(
                amount,
                settings.currency,
                settings.locale,
              ),
              style: AppTextStyles.body.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'Serif',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpendingBreakdownSection extends StatelessWidget {
  final List<MapEntry<String, double>> sortedCategories;
  final double totalMonthlyExpense;
  final SettingsController settings;
  final bool isLocked;

  const _SpendingBreakdownSection({
    required this.sortedCategories,
    required this.totalMonthlyExpense,
    required this.settings,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Spending Breakdown',
                style: AppTextStyles.h2Section.copyWith(
                  fontSize: 20,
                  fontFamily: 'Serif',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExpenseHistoryScreen(),
                    ),
                  );
                },
                child: Text(
                  'VIEW ALL',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primarySelected,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(sortedCategories.length, (index) {
            final entry = sortedCategories[index];
            final percentage = totalMonthlyExpense > 0
                ? (entry.value / totalMonthlyExpense) * 100
                : 0.0;
            final shouldBlur = isLocked && index >= 2;

            return _CategoryProgressBar(
              category: entry.key,
              amount: entry.value,
              percentage: percentage,
              settings: settings,
              isBlurred: shouldBlur,
            );
          }),
        ],
      ),
    );
  }
}

class _SmartInsightsSection extends StatelessWidget {
  final DateTime? highestDate;
  final double highestDayEntryValue;
  final List<double> weeklyData;
  final double maxWeekly;
  final SettingsController settings;
  final List<MapEntry<String, double>> sortedCategories;
  final double totalMonthlyExpense;
  final DateTime selectedDate;

  const _SmartInsightsSection({
    required this.highestDate,
    required this.highestDayEntryValue,
    required this.weeklyData,
    required this.maxWeekly,
    required this.settings,
    required this.sortedCategories,
    required this.totalMonthlyExpense,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Smart Insights',
            style: AppTextStyles.h2Section.copyWith(
              fontSize: 20,
              fontFamily: 'Serif',
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _HighestSpendDayCard(
                date: highestDate,
                amount: highestDayEntryValue,
                weeklyData: weeklyData,
                maxAmount: maxWeekly,
                settings: settings,
                primaryCategory: sortedCategories.isNotEmpty
                    ? sortedCategories.first.key
                    : null,
              ),
              const SizedBox(width: 16),
              _BalanceInsightCard(
                dailyAvg:
                    selectedDate.month == DateTime.now().month &&
                        selectedDate.year == DateTime.now().year
                    ? totalMonthlyExpense / DateTime.now().day
                    : totalMonthlyExpense /
                          DateUtils.getDaysInMonth(
                            selectedDate.year,
                            selectedDate.month,
                          ),
                settings: settings,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LockedInsightsCard extends StatelessWidget {
  const _LockedInsightsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A),
        borderRadius: BorderRadius.circular(24),
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
              const Icon(Icons.auto_awesome, color: Colors.orange, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Unlock to watch full Inishgts',
                  style: AppTextStyles.h2Section.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _BulletPoint(text: 'Detailed spending breakdown'),
          _BulletPoint(text: 'Smart tailored insights'),
          _BulletPoint(text: 'Weekly Inc vs Exp trend'),
          _BulletPoint(text: 'Monthly trend'),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Upgrade Now',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.orange,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Watch Ads',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.circle, color: Colors.white70, size: 6),
          const SizedBox(width: 12),
          Text(
            text,
            style: AppTextStyles.body.copyWith(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryProgressBar extends StatelessWidget {
  final String category;
  final double amount;
  final double percentage;
  final SettingsController settings;

  final bool isBlurred;

  const _CategoryProgressBar({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.settings,
    this.isBlurred = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _getCategoryColor(category);

    Widget content = Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                CategoryUtils.getIcon(category),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    AppFormatters.formatCurrency(
                      amount,
                      settings.currency,
                      settings.locale,
                      decimalDigits: 0,
                    ),
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 11,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2A2A) : Colors.black12,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: (percentage / 100).clamp(0.01, 1.0),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
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

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food & drinks':
        return AppColors.primarySelected;
      case 'rent & bills':
        return AppColors.softCoral;
      case 'transport':
        return Colors.blue;
      case 'shopping':
        return const Color(0xFF7D8FA9);
      default:
        return AppColors.accentTeal;
    }
  }
}

class _HighestSpendDayCard extends StatelessWidget {
  final DateTime? date;
  final double amount;
  final List<double> weeklyData;
  final double maxAmount;
  final SettingsController settings;
  final String? primaryCategory;

  const _HighestSpendDayCard({
    this.date,
    required this.amount,
    required this.weeklyData,
    required this.maxAmount,
    required this.settings,
    this.primaryCategory,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF3D2C1E) : const Color(0xFFFEE4CB),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Highest Spend Day',
                    style: AppTextStyles.body.copyWith(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    date != null
                        ? DateFormat('MMM dth, EEEE').format(date!)
                        : 'N/A',
                    style: AppTextStyles.caption.copyWith(
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        AppFormatters.formatCurrency(
                          amount,
                          settings.currency,
                          settings.locale,
                        ),
                        style: AppTextStyles.amountDisplay.copyWith(
                          fontSize: 22,
                          fontFamily: 'Serif',
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    if (primaryCategory != null)
                      Text(
                        'Primarily $primaryCategory',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final val = weeklyData[index];
              final heightFactor = maxAmount > 0
                  ? (val / maxAmount).clamp(0.1, 1.0)
                  : 0.1;
              final isToday = index == (DateTime.now().weekday % 7);

              return Column(
                children: [
                  Container(
                    width: 30,
                    height: 60 * heightFactor,
                    decoration: BoxDecoration(
                      color: isToday
                          ? AppColors.primarySelected
                          : (isDark
                                ? Colors.white.withValues(alpha: 0.2)
                                : Colors.white),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'][index],
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: AppColors.charcoal,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _BalanceInsightCard extends StatelessWidget {
  final double dailyAvg;
  final SettingsController settings;

  const _BalanceInsightCard({required this.dailyAvg, required this.settings});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Average',
                style: AppTextStyles.body.copyWith(
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontSize: 14,
                ),
              ),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    AppFormatters.formatCurrency(
                      dailyAvg,
                      settings.currency,
                      settings.locale,
                    ),
                    style: AppTextStyles.amountDisplay.copyWith(
                      fontSize: 18,
                      fontFamily: 'Serif',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              'Your average spending is stable compared to last month. Great job on staying within budget!',
              style: AppTextStyles.body.copyWith(
                fontSize: 13,
                color: isDark ? Colors.white60 : Colors.black54,
                fontStyle: FontStyle.italic,
                height: 1.3,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primarySelected.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.trending_down,
                  color: AppColors.successGreen,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  '-12% vs last month',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.successGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
