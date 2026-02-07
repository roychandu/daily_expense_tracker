import 'package:flutter/material.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isExpenseSelected = true;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _initPages();
  }

  void _initPages() {
    _pages = [
      _TodayView(
        isExpenseSelected: _isExpenseSelected,
        onToggle: (val) {
          setState(() {
            _isExpenseSelected = val;
            _onDataChanged();
          });
        },
      ),
      const MonthlySummaryScreen(),
      const InsightsScreen(),
      const SettingsScreen(),
    ];
  }

  void _onDataChanged() {
    setState(() {
      _pages[0] = _TodayView(
        isExpenseSelected: _isExpenseSelected,
        onToggle: (val) {
          setState(() {
            _isExpenseSelected = val;
            _onDataChanged();
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
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
              _onDataChanged();
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
            _buildNavItem(0, Icons.home_filled, 'Home'),
            _buildNavItem(1, Icons.query_stats, 'Summary'),
            const SizedBox(width: 48), // Space for FAB
            _buildNavItem(2, Icons.assessment_outlined, 'Insights'),
            _buildNavItem(3, Icons.settings_outlined, 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    final color = isSelected
        ? AppColors.primaryDeepBlue
        : AppColors.softGray.withOpacity(0.8);

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
  final ValueChanged<bool> onToggle;

  const _TodayView({required this.isExpenseSelected, required this.onToggle});

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
    if (oldWidget.isExpenseSelected != widget.isExpenseSelected) {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
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
            _buildToggle(),
            const SizedBox(height: 24),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              _buildTotalCard(),
              const SizedBox(height: 24),

              Text(
                'RECENT',
                style: AppTextStyles.h2Section.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 12),
              _recentExpenses.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'No ${widget.isExpenseSelected ? 'expenses' : 'income'} yet',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.softGray,
                          ),
                        ),
                      ),
                    )
                  : _buildRecentTransactions(),
            ],

            const SizedBox(height: 16),
            SecondaryButton(
              title: 'View All History',
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

  Widget _buildToggle() {
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
                  'Expense',
                  style: AppTextStyles.body.copyWith(
                    color: widget.isExpenseSelected
                        ? Colors.white
                        : (isDark
                              ? AppColors.textDark.withOpacity(0.6)
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
                  'Income',
                  style: AppTextStyles.body.copyWith(
                    color: !widget.isExpenseSelected
                        ? Colors.white
                        : (isDark
                              ? AppColors.textDark.withOpacity(0.6)
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

  Widget _buildTotalCard() {
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
                '\$${_totalAmount.toStringAsFixed(2)}',
                style: AppTextStyles.amountDisplay.copyWith(fontSize: 32),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${_recentExpenses.length} ${widget.isExpenseSelected ? 'expenses' : 'items'}',
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
                ' Total ${widget.isExpenseSelected ? 'Expenses' : 'Income'} for today',
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

  Widget _buildRecentTransactions() {
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
                  '\$${tx.amount.toStringAsFixed(2)}',
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
    switch (category) {
      case 'Food':
        return '🍔';
      case 'Transport':
        return '🚗';
      case 'Home':
        return '🏠';
      case 'Fun':
        return '🎮';
      case 'Health':
        return '💊';
      default:
        return '💰';
    }
  }
}
