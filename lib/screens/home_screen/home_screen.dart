import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_card.dart';
import '../../common_widgets/secondary_button.dart';
import '../add_expense/add_expense_screen.dart';
import '../settings/settings_screen.dart';
import '../history/expense_history_screen.dart';
import '../monthly_summary/monthly_summary_screen.dart';
import '../insights/insights_screen.dart';

import '../../models/expense.dart';
import '../../controllers/settings_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/formatters.dart';
import '../../utils/category_utils.dart';
import 'package:intl/intl.dart';
import '../../controllers/expense_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isExpenseSelected = true;
  int _refreshCount = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Explicitly watch settings to ensure absolute reactivity for tabs
    context.watch<SettingsController>();

    final List<Widget> pages = [
      _TodayView(
        isExpenseSelected: _isExpenseSelected,
        refreshCount: _refreshCount,
        onToggle: (val) {
          setState(() {
            _isExpenseSelected = val;
          });
        },
      ),
      const MonthlySummaryScreen(),
      const InsightsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddExpenseScreen(isExpense: _isExpenseSelected),
            ),
          );
          if (result == true) {
            setState(() {
              _refreshCount++;
            });
          }
        },
        elevation: 4,
        backgroundColor: AppColors.primarySelected,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        padding: EdgeInsets.zero,
        height: 72,
        color: isDark ? AppColors.cardDark : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              0,
              Icons.home_outlined,
              Icons.home_rounded,
              l10n.home,
            ),
            _buildNavItem(
              1,
              Icons.insert_chart_outlined_rounded,
              Icons.insert_chart_rounded,
              'Insight',
            ),
            const SizedBox(width: 48), // Space for FAB
            _buildNavItem(
              2,
              Icons.auto_graph_rounded,
              Icons.auto_graph_rounded,
              'Progress',
            ),
            _buildNavItem(
              3,
              Icons.settings_outlined,
              Icons.settings_rounded,
              l10n.settings,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData outlineIcon,
    IconData filledIcon,
    String label,
  ) {
    final isSelected = _currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isSelected
        ? AppColors.primarySelected
        : (isDark ? Colors.white70 : const Color(0xFF818181));

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? filledIcon : outlineIcon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayView extends StatefulWidget {
  final bool isExpenseSelected;
  final int refreshCount;
  final ValueChanged<bool> onToggle;

  const _TodayView({
    required this.isExpenseSelected,
    required this.refreshCount,
    required this.onToggle,
  });

  @override
  State<_TodayView> createState() => _TodayViewState();
}

class _TodayViewState extends State<_TodayView> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsController>();
    final expenseController = context.watch<ExpenseController>();

    if (expenseController.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final allExpenses = expenseController.expenses;
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);
    final yesterdayStr = DateFormat(
      'yyyy-MM-dd',
    ).format(now.subtract(const Duration(days: 1)));

    final todayExpenses = allExpenses.where((e) {
      return DateFormat('yyyy-MM-dd').format(e.date) == todayStr &&
          e.isExpense == widget.isExpenseSelected;
    }).toList();

    final yesterdayExpenses = allExpenses.where((e) {
      return DateFormat('yyyy-MM-dd').format(e.date) == yesterdayStr &&
          e.isExpense == widget.isExpenseSelected;
    }).toList();

    double totalAmount = 0;
    for (var e in todayExpenses) {
      totalAmount += e.amount;
    }

    double yesterdayTotal = 0;
    for (var e in yesterdayExpenses) {
      yesterdayTotal += e.amount;
    }

    final recentExpenses = todayExpenses.take(5).toList();

    // Dynamic Streak Calculation
    int currentStreak = 0;
    DateTime checkDate = now;
    while (true) {
      final dateStr = DateFormat('yyyy-MM-dd').format(checkDate);
      final hasEntry = allExpenses.any(
        (e) => DateFormat('yyyy-MM-dd').format(e.date) == dateStr,
      );
      if (hasEntry) {
        currentStreak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    final milestone = 30; // Target milestone

    final daysToMilestone = milestone - currentStreak;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          l10n.home,
          style: AppTextStyles.h1Display.copyWith(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDark
                : AppColors.charcoal,
          ),
        ),
      ),
      extendBodyBehindAppBar: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildToggle(l10n),
            const SizedBox(height: 24),

            _buildTodayCard(
              l10n,
              settings,
              totalAmount,
              yesterdayTotal,
              todayExpenses.length,
            ),
            const SizedBox(height: 24),

            _buildStreakCard(l10n, currentStreak, milestone, daysToMilestone),
            const SizedBox(height: 24),

            Text(
              l10n.recent,
              style: AppTextStyles.h2Section.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 12),
            recentExpenses.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        widget.isExpenseSelected
                            ? l10n.noExpensesYet
                            : l10n.noIncomeYet,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.softGray,
                        ),
                      ),
                    ),
                  )
                : _buildRecentTransactions(settings, recentExpenses),

            const SizedBox(height: 16),
            SecondaryButton(
              title: l10n.viewAllHistory,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExpenseHistoryScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.primaryUnselected,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onToggle(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !widget.isExpenseSelected
                      ? AppColors.primarySelected
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  l10n.addIncome,
                  style: AppTextStyles.body.copyWith(
                    color: !widget.isExpenseSelected
                        ? Colors.white
                        : AppColors.charcoal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onToggle(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: widget.isExpenseSelected
                      ? AppColors.primarySelected
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  l10n.addExpense,
                  style: AppTextStyles.body.copyWith(
                    color: widget.isExpenseSelected
                        ? Colors.white
                        : AppColors.charcoal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayCard(
    AppLocalizations l10n,
    SettingsController settings,
    double totalAmount,
    double yesterdayTotal,
    int count,
  ) {
    final diff = totalAmount - yesterdayTotal;
    final isMore = diff > 0;
    final absDiff = diff.abs();

    return CustomCard(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'TODAY',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primarySelected,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.primarySelected,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppFormatters.formatCurrency(
              totalAmount,
              settings.currency,
              settings.locale,
            ),
            style: AppTextStyles.amountDisplay.copyWith(
              fontSize: 36,
              color: AppColors.charcoal,
            ),
          ),
          Text(
            '$count Entries today',
            style: AppTextStyles.caption.copyWith(color: AppColors.softGray),
          ),
          const SizedBox(height: 12),
          Text(
            '${AppFormatters.formatCurrency(absDiff, settings.currency, settings.locale)} ${isMore ? l10n.moreThanYesterday : l10n.lessThanYesterday}',
            style: AppTextStyles.body.copyWith(
              color: isMore ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(
    AppLocalizations l10n,
    int streak,
    int milestone,
    int daysTo,
  ) {
    return CustomCard(
      padding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 8),
                Text(
                  '$streak DAYS STREAK',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.primaryUnselected,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STREAK PROGRESS',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.softGray,
                  ),
                ),
                Text(
                  '$streak/$milestone Days to next milestone',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: (streak / milestone).clamp(0.0, 1.0),
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.primarySelected,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  daysTo > 0
                      ? 'You are $daysTo days away from a silver badge!'
                      : 'Milestone reached! Check your rewards.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.softGray,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(
    SettingsController settings,
    List<Expense> recentExpenses,
  ) {
    return Column(
      children: recentExpenses.map((tx) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: CustomCard(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    _getCategoryIcon(tx.category),
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx.category,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.charcoal,
                        ),
                      ),
                      Text(
                        '${DateFormat('dd MMM').format(tx.date)} • ${DateFormat('h:mm a').format(tx.date)}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.softGray,
                          fontSize: 12,
                        ),
                      ),
                      if (tx.note.isNotEmpty)
                        Text(
                          tx.note,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.softGray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Text(
                  AppFormatters.formatCurrency(
                    tx.amount,
                    settings.currency,
                    settings.locale,
                  ),
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.charcoal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getCategoryIcon(String category) {
    return CategoryUtils.getIcon(category);
  }
}
