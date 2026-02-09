import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_card.dart';
import '../../common_widgets/primary_button.dart';
import 'package:intl/intl.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/expense_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/formatters.dart';
import '../../utils/category_utils.dart';

class MonthlySummaryScreen extends StatefulWidget {
  const MonthlySummaryScreen({super.key});

  @override
  State<MonthlySummaryScreen> createState() => _MonthlySummaryScreenState();
}

class _MonthlySummaryScreenState extends State<MonthlySummaryScreen> {
  bool _isUnlocked = false;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsController>();
    final expenseController = context.watch<ExpenseController>();

    final monthName = DateFormat(
      'MMMM yyyy',
      settings.locale.toString(),
    ).format(_selectedDate);

    // Filter and calculate data
    final allExpenses = expenseController.expenses;
    final thisMonthExpenses = allExpenses.where((e) {
      return e.date.month == _selectedDate.month &&
          e.date.year == _selectedDate.year &&
          e.isExpense;
    }).toList();

    double totalAmount = 0;
    Map<String, double> categoryTotals = {};
    Map<String, double> dailyTotals = {};
    for (var e in thisMonthExpenses) {
      totalAmount += e.amount;
      categoryTotals[e.category] = (categoryTotals[e.category] ?? 0) + e.amount;
      final dateStr = DateFormat('yyyy-MM-dd').format(e.date);
      dailyTotals[dateStr] = (dailyTotals[dateStr] ?? 0) + e.amount;
    }

    String topCategory = l10n.all; // Fallback to All or None
    double maxCatAmount = 0;
    categoryTotals.forEach((cat, amt) {
      if (amt > maxCatAmount) {
        maxCatAmount = amt;
        topCategory = cat;
      }
    });

    String highestSpendDay = '';
    double highestSpendAmount = 0;
    dailyTotals.forEach((day, amt) {
      if (amt > highestSpendAmount) {
        highestSpendAmount = amt;
        highestSpendDay = day;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => _showMonthPicker(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(monthName),
              const Icon(Icons.arrow_drop_down, color: AppColors.accentTeal),
            ],
          ),
        ),
      ),
      body: expenseController.isLoading
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
                            l10n.monthlyTotal,
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppFormatters.formatCurrency(
                              totalAmount,
                              settings.currency,
                              settings.locale,
                            ),
                            style: AppTextStyles.amountDisplay.copyWith(
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${thisMonthExpenses.length} ${l10n.expenses}',
                            style: AppTextStyles.body,
                          ),
                          if (!_isUnlocked && thisMonthExpenses.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  '${l10n.topCategory}: ',
                                  style: AppTextStyles.caption,
                                ),
                                Text(
                                  '${_getCategoryIcon(topCategory)} $topCategory',
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
                    _buildLockedState(l10n)
                  else
                    _buildUnlockedState(
                      settings,
                      l10n,
                      totalAmount,
                      categoryTotals,
                      highestSpendDay,
                      highestSpendAmount,
                      dailyTotals,
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildLockedState(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.details,
          style: AppTextStyles.h2Section.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 12),
        CustomCard(
          child: Column(
            children: [
              const Icon(Icons.lock, size: 48, color: AppColors.accentTeal),
              const SizedBox(height: 16),
              Text(l10n.unlockFullBreakdown, style: AppTextStyles.h2Section),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ${l10n.categoryBreakdown}',
                      style: AppTextStyles.body,
                    ),
                    Text(
                      '• ${l10n.dailyAverageSpend}',
                      style: AppTextStyles.body,
                    ),
                    Text(
                      '• ${l10n.highestSpendDay}',
                      style: AppTextStyles.body,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                title: l10n.watchAd,
                onPressed: () {
                  setState(() => _isUnlocked = true);
                },
              ),
              const SizedBox(height: 12),
              Text(l10n.or, style: AppTextStyles.caption),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {},
                child: Text(
                  l10n.removeAds,
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

  Widget _buildUnlockedState(
    SettingsController settings,
    AppLocalizations l10n,
    double totalAmount,
    Map<String, double> categoryTotals,
    String highestSpendDay,
    double highestSpendAmount,
    Map<String, double> dailyTotals,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.categoryBreakdownTitle,
          style: AppTextStyles.h2Section.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 12),
        ...categoryTotals.entries.map((entry) {
          final percentage = totalAmount > 0 ? entry.value / totalAmount : 0.0;
          return _buildCategoryRow(
            '${_getCategoryIcon(entry.key)} ${entry.key}',
            AppFormatters.formatCurrency(
              entry.value,
              settings.currency,
              settings.locale,
            ),
            percentage,
          );
        }),
        const SizedBox(height: 24),
        Text(
          l10n.insights.toUpperCase(),
          style: AppTextStyles.h2Section.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CustomCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.dailyAvg, style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Text(
                      AppFormatters.formatCurrency(
                        totalAmount /
                            DateUtils.getDaysInMonth(
                              _selectedDate.year,
                              _selectedDate.month,
                            ),
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
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.highestSpendDay, style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Text(
                      highestSpendDay.isEmpty
                          ? 'N/A'
                          : '${DateFormat('MMM dd', settings.locale.toString()).format(DateTime.parse(highestSpendDay))} (${AppFormatters.formatCurrency(highestSpendAmount, settings.currency, settings.locale)})',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          l10n.dateWiseLog,
          style: AppTextStyles.h2Section.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 12),
        ...(dailyTotals.entries.toList()
              ..sort((a, b) => b.key.compareTo(a.key)))
            .map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CustomCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat(
                          'MMMM dd, yyyy',
                          settings.locale.toString(),
                        ).format(DateTime.parse(entry.key)),
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        AppFormatters.formatCurrency(
                          entry.value,
                          settings.currency,
                          settings.locale,
                        ),
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.softCoral,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })
            .toList(),
      ],
    );
  }

  void _showMonthPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null &&
        (picked.month != _selectedDate.month ||
            picked.year != _selectedDate.year)) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month);
      });
    }
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
                      color: AppColors.softGray.withValues(alpha: 0.2),
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
    return CategoryUtils.getIcon(category);
  }
}
