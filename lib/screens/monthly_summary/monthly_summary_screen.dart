import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_card.dart';
import '../../common_widgets/primary_button.dart';
import '../../services/database_service.dart';
import '../../models/expense.dart';
import 'package:intl/intl.dart';

class MonthlySummaryScreen extends StatefulWidget {
  const MonthlySummaryScreen({super.key});

  @override
  State<MonthlySummaryScreen> createState() => _MonthlySummaryScreenState();
}

class _MonthlySummaryScreenState extends State<MonthlySummaryScreen> {
  bool _isUnlocked = false;
  List<Expense> _monthlyExpenses = [];
  double _totalAmount = 0;
  Map<String, double> _categoryTotals = {};
  bool _isLoading = true;
  String _topCategory = 'None';

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    setState(() => _isLoading = true);
    final all = await DatabaseService.instance.readAllExpenses();
    final now = DateTime.now();
    final thisMonthExpenses = all
        .where(
          (e) =>
              e.date.month == now.month &&
              e.date.year == now.year &&
              e.isExpense,
        )
        .toList();

    double total = 0;
    Map<String, double> catTotals = {};
    for (var e in thisMonthExpenses) {
      total += e.amount;
      catTotals[e.category] = (catTotals[e.category] ?? 0) + e.amount;
    }

    String topCat = 'None';
    double maxAmount = 0;
    catTotals.forEach((cat, amt) {
      if (amt > maxAmount) {
        maxAmount = amt;
        topCat = cat;
      }
    });

    setState(() {
      _monthlyExpenses = thisMonthExpenses;
      _totalAmount = total;
      _categoryTotals = catTotals;
      _topCategory = topCat;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthName = DateFormat('MMMM yyyy').format(now);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(monthName),
            const Icon(Icons.arrow_drop_down, color: AppColors.accentTeal),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CustomCard(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MONTHLY TOTAL',
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${_totalAmount.toStringAsFixed(2)}',
                            style: AppTextStyles.amountDisplay.copyWith(
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_monthlyExpenses.length} expenses',
                            style: AppTextStyles.body,
                          ),
                          if (!_isUnlocked && _monthlyExpenses.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  'Top category: ',
                                  style: AppTextStyles.caption,
                                ),
                                Text(
                                  '${_getCategoryIcon(_topCategory)} $_topCategory',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (!_isUnlocked)
                    _buildLockedState()
                  else
                    _buildUnlockedState(),
                ],
              ),
            ),
    );
  }

  Widget _buildLockedState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('DETAILS', style: AppTextStyles.h2Section.copyWith(fontSize: 18)),
        const SizedBox(height: 12),
        CustomCard(
          child: Column(
            children: [
              const Icon(Icons.lock, size: 48, color: AppColors.accentTeal),
              const SizedBox(height: 16),
              Text('Unlock Full Breakdown', style: AppTextStyles.h2Section),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• Category breakdown', style: AppTextStyles.body),
                    Text('• Daily average spend', style: AppTextStyles.body),
                    Text('• Highest spend day', style: AppTextStyles.body),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                title: 'Watch Ad to Unlock',
                onPressed: () {
                  setState(() => _isUnlocked = true);
                },
              ),
              const SizedBox(height: 12),
              Text('or', style: AppTextStyles.caption),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Remove Ads - \$3.99',
                  style: AppTextStyles.body.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.accentTeal
                        : AppColors.primaryDeepBlue,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUnlockedState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CATEGORY BREAKDOWN',
          style: AppTextStyles.h2Section.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 12),
        ..._categoryTotals.entries.map((entry) {
          final percentage = _totalAmount > 0
              ? entry.value / _totalAmount
              : 0.0;
          return _buildCategoryRow(
            '${_getCategoryIcon(entry.key)} ${entry.key}',
            '\$${entry.value.toStringAsFixed(2)}',
            percentage,
          );
        }),

        const SizedBox(height: 24),

        Text('INSIGHTS', style: AppTextStyles.h2Section.copyWith(fontSize: 18)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CustomCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Daily Avg', style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Text(
                      '\$${(_totalAmount / DateTime.now().day).toStringAsFixed(2)}',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Items', style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Text(
                      '${_monthlyExpenses.length}',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryRow(String title, String amount, double percentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  amount,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: (percentage * 100).toInt().clamp(1, 100),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.accentTeal,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Expanded(
                  flex: (100 - (percentage * 100).toInt()).clamp(0, 100),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.softGray.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(percentage * 100).toInt()}%',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ],
        ),
      ),
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
