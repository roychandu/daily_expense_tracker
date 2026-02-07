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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _TodayView(),
    const ExpenseHistoryScreen(),
    const MonthlySummaryScreen(),
    const InsightsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.accentTeal,
        unselectedItemColor: AppColors.softGray,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Summary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Insights',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddExpenseScreen(),
                  ),
                );
              },
              backgroundColor: AppColors.accentTeal,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}

class _TodayView extends StatefulWidget {
  const _TodayView();

  @override
  State<_TodayView> createState() => _TodayViewState();
}

class _TodayViewState extends State<_TodayView> {
  bool _isExpenseSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
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
            // Toggle
            _buildToggle(),
            const SizedBox(height: 24),

            // Total Card
            _buildTotalCard(),
            const SizedBox(height: 24),

            // Recent Transactions
            Text(
              'RECENT',
              style: AppTextStyles.h2Section.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 12),
            _buildRecentTransactions(),

            const SizedBox(height: 16),
            SecondaryButton(
              title: 'View All History',
              onPressed: () {
                // In a real app, you might want to switch the tab instead of pushing
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExpenseHistoryScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 70), // Space for FAB
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
              onTap: () => setState(() => _isExpenseSelected = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: _isExpenseSelected
                      ? AppColors.accentTeal
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Expense',
                  style: AppTextStyles.body.copyWith(
                    color: _isExpenseSelected
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
              onTap: () => setState(() => _isExpenseSelected = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: !_isExpenseSelected
                      ? AppColors.accentTeal
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Income',
                  style: AppTextStyles.body.copyWith(
                    color: !_isExpenseSelected
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
                r'$247.50',
                style: AppTextStyles.amountDisplay.copyWith(fontSize: 32),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('8 expenses', style: AppTextStyles.caption),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.arrow_upward,
                color: AppColors.softCoral,
                size: 16,
              ),
              Text(
                r' $15 more than yesterday',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.softCoral,
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
    final transactions = [
      {'title': 'Coffee', 'amount': r'$4.50', 'time': '9:30am', 'icon': '☕'},
      {'title': 'Lunch', 'amount': r'$12.00', 'time': '1:15pm', 'icon': '🍔'},
      {
        'title': 'Groceries',
        'amount': r'$45.00',
        'time': '6:20pm',
        'icon': '🛒',
      },
    ];

    return Column(
      children: transactions.map((tx) {
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
                    tx['icon']!,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx['title']!,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(tx['time']!, style: AppTextStyles.caption),
                    ],
                  ),
                ),
                Text(
                  tx['amount']!,
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
}
