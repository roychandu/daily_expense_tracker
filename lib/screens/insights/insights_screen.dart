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

    final allExpenses = expenseController.expenses
        .where((e) => e.isExpense)
        .toList();
    final monthExpenses = allExpenses.where((e) {
      return e.date.month == _selectedDate.month &&
          e.date.year == _selectedDate.year;
    }).toList();

    final totalMonthlyAmount = monthExpenses.fold(
      0.0,
      (sum, e) => sum + e.amount,
    );
    final transactionCount = monthExpenses.length;

    // Category Breakdown
    final categoryTotals = <String, double>{};
    for (final e in monthExpenses) {
      categoryTotals[e.category] =
          (categoryTotals[e.category] ?? 0.0) + e.amount;
    }
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Highest Spend Day
    final dayTotals = <String, double>{};
    for (final e in monthExpenses) {
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

    // Weekly Chart Data (Based on selected month or current week if selected month is current)
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
            fontFamily: 'Serif', // Fallback to serif for elegant look
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => expenseController.refreshExpenses(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${DateFormat('MMMM yyyy').format(_selectedDate).toUpperCase()} SUMMARY',
                      style: AppTextStyles.caption.copyWith(
                        letterSpacing: 1.2,
                        color: isDark ? Colors.white60 : Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppFormatters.formatCurrency(
                            totalMonthlyAmount,
                            settings.currency,
                            settings.locale,
                          ),
                          style: AppTextStyles.amountDisplay.copyWith(
                            fontSize: 42,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Serif',
                          ),
                        ),
                        IconButton(
                          onPressed: () => _selectMonth(context),
                          icon: const Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.primarySelected,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _TransactionChip(count: transactionCount),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Spending Breakdown Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ExpenseHistoryScreen(),
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
                    ...sortedCategories.map((entry) {
                      final percentage = totalMonthlyAmount > 0
                          ? (entry.value / totalMonthlyAmount) * 100
                          : 0.0;
                      return _CategoryProgressBar(
                        category: entry.key,
                        amount: entry.value,
                        percentage: percentage,
                        settings: settings,
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Smart Insights Section
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
                height: 180, // Reduced height
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ), // Padding here instead of parent
                  children: [
                    _HighestSpendDayCard(
                      date: highestDate,
                      amount: highestDayEntry?.value ?? 0,
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
                          _selectedDate.month == DateTime.now().month &&
                              _selectedDate.year == DateTime.now().year
                          ? totalMonthlyAmount / DateTime.now().day
                          : totalMonthlyAmount /
                                DateUtils.getDaysInMonth(
                                  _selectedDate.year,
                                  _selectedDate.month,
                                ),
                      settings: settings,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionChip extends StatelessWidget {
  final int count;
  const _TransactionChip({required this.count});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 16,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          const SizedBox(width: 8),
          Text(
            '$count Transactions',
            style: AppTextStyles.caption.copyWith(
              color: isDark ? Colors.white70 : Colors.black54,
              fontWeight: FontWeight.w500,
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

  const _CategoryProgressBar({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _getCategoryColor(category);

    return Padding(
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
              Text(
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
              const SizedBox(width: 8),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 11,
                  color: Colors.white54,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
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
                  if (primaryCategory != null)
                    Text(
                      'Primarily $primaryCategory',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 10,
                        color: isDark ? Colors.white38 : Colors.black38,
                      ),
                    ),
                ],
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
              Text(
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
