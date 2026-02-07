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
import '../../services/database_service.dart';
import '../../models/expense.dart';
import '../../controllers/settings_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/formatters.dart';
import '../../utils/category_utils.dart';

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
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 20),
        child: FloatingActionButton(
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
          elevation: 8,
          backgroundColor: const Color(0xFF00FFEA),
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.black, size: 32),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        padding: EdgeInsets.zero,
        height: 80,
        color: isDark ? AppColors.cardDark : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_filled, l10n.home),
            _buildNavItem(1, Icons.query_stats, l10n.summary),
            const SizedBox(width: 48), // Space for FAB
            _buildNavItem(2, Icons.assessment_outlined, l10n.insights),
            _buildNavItem(3, Icons.settings_outlined, l10n.settings),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    final color = isSelected
        ? AppColors.primaryDeepBlue
        : AppColors.softGray.withValues(alpha: 0.8);

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
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
  List<Expense> _recentExpenses = [];
  double _totalAmount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(_TodayView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isExpenseSelected != widget.isExpenseSelected ||
        oldWidget.refreshCount != widget.refreshCount) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final expenses = await DatabaseService.instance.readExpensesByDay(
      DateTime.now(),
    );

    final filtered = expenses
        .where((e) => e.isExpense == widget.isExpenseSelected)
        .toList();

    double total = 0;
    for (var e in filtered) {
      total += e.amount;
    }

    setState(() {
      _recentExpenses = filtered.take(5).toList();
      _totalAmount = total;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.today),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExpenseHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildToggle(l10n),
            const SizedBox(height: 24),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              _buildTotalCard(l10n, settings),
              const SizedBox(height: 24),

              Text(
                l10n.recent,
                style: AppTextStyles.h2Section.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 12),
              _recentExpenses.isEmpty
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
                  : _buildRecentTransactions(settings),
            ],

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.warmCream,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.softGray),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onToggle(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: widget.isExpenseSelected
                      ? AppColors.accentTeal
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.center,
                child: Text(
                  l10n.expense,
                  style: AppTextStyles.body.copyWith(
                    color: widget.isExpenseSelected
                        ? Colors.white
                        : (isDark
                              ? AppColors.textDark.withValues(alpha: 0.6)
                              : AppColors.softGray),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onToggle(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: !widget.isExpenseSelected
                      ? AppColors.accentTeal
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.center,
                child: Text(
                  l10n.income,
                  style: AppTextStyles.body.copyWith(
                    color: !widget.isExpenseSelected
                        ? Colors.white
                        : (isDark
                              ? AppColors.textDark.withValues(alpha: 0.6)
                              : AppColors.softGray),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(AppLocalizations l10n, SettingsController settings) {
    return CustomCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MonthlySummaryScreen()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppFormatters.formatCurrency(
                  _totalAmount,
                  settings.currency,
                  settings.locale,
                ),
                style: AppTextStyles.amountDisplay.copyWith(fontSize: 32),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${_recentExpenses.length} ${widget.isExpenseSelected ? l10n.expenses : l10n.items}',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.accentTeal,
                size: 16,
              ),
              Text(
                ' ${widget.isExpenseSelected ? l10n.totalExpensesToday : l10n.totalIncomeToday}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.accentTeal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(SettingsController settings) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: _recentExpenses.map((tx) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: CustomCard(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.backgroundDark
                        : AppColors.warmCream,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getCategoryIcon(tx.category),
                    style: const TextStyle(fontSize: 20),
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        tx.note.isEmpty ? 'Logged' : tx.note,
                        style: AppTextStyles.caption,
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
