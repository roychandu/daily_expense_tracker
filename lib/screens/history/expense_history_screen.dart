import 'package:flutter/material.dart';
import '../add_expense/add_expense_screen.dart';
import 'package:intl/intl.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_card.dart';
import '../../common_widgets/custom_text_field.dart';
import '../../models/expense.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/expense_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/formatters.dart';
import '../../utils/category_utils.dart';
import '../../common_widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';

class ExpenseHistoryScreen extends StatefulWidget {
  const ExpenseHistoryScreen({super.key});

  @override
  State<ExpenseHistoryScreen> createState() => _ExpenseHistoryScreenState();
}

class _ExpenseHistoryScreenState extends State<ExpenseHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'All';
  List<String> _selectedCategories = [];
  Map<String, List<Expense>> _groupedExpenses = {};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {}); // Re-filter on search change
  }

  void _filterAndGroupExpenses(List<Expense> allExpenses) {
    final l10n = AppLocalizations.of(context)!;
    final query = _searchController.text.toLowerCase();

    final filtered = allExpenses.where((e) {
      final matchesQuery =
          e.category.toLowerCase().contains(query) ||
          e.note.toLowerCase().contains(query);
      final matchesType =
          _selectedType == 'All' || // logic remains same for internal state
          _selectedType == l10n.all ||
          (_selectedType == l10n.expense && e.isExpense) ||
          (_selectedType == l10n.income && !e.isExpense);
      final matchesCategory =
          _selectedCategories.isEmpty ||
          _selectedCategories.contains(e.category);

      return matchesQuery && matchesType && matchesCategory;
    }).toList();

    // Grouping
    final Map<String, List<Expense>> groups = {};
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);
    final yesterdayStr = DateFormat(
      'yyyy-MM-dd',
    ).format(now.subtract(const Duration(days: 1)));

    for (var e in filtered) {
      final dateStr = DateFormat('yyyy-MM-dd').format(e.date);
      String label;
      if (dateStr == todayStr) {
        label = l10n.today.toUpperCase();
      } else if (dateStr == yesterdayStr) {
        label = l10n.yesterday;
      } else {
        label = DateFormat(
          'MMMM dd, yyyy',
          Localizations.localeOf(context).toString(),
        ).format(e.date).toUpperCase();
      }

      if (!groups.containsKey(label)) {
        groups[label] = [];
      }
      groups[label]!.add(e);
    }
    _groupedExpenses = groups;
  }

  Future<void> _deleteExpense(int id) async {
    await context.read<ExpenseController>().deleteExpense(id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsController>();
    final expenseController = context.watch<ExpenseController>();

    _filterAndGroupExpenses(expenseController.expenses);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final keys = _groupedExpenses.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.history),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              showCustomSnackBar(context, l10n.exportingCsv);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (expenseController.isLoading) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _searchController,
                    hintText: l10n.searchExpenses,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.softGray,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.softGray),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.tune,
                      color: isDark
                          ? AppColors.accentTeal
                          : AppColors.primaryDeepBlue,
                    ),
                    onPressed: () => _showFilterBottomSheet(context),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _groupedExpenses.isEmpty
                ? Center(
                    child: Text(
                      l10n.noHistoryFound,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.softGray,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: keys.length,
                    itemBuilder: (context, sectionIndex) {
                      final label = keys[sectionIndex];
                      final items = _groupedExpenses[label]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              label,
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.softGray,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          ...items.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Dismissible(
                                key: Key(item.id.toString()),
                                direction: DismissDirection.endToStart,
                                onDismissed: (_) => _deleteExpense(item.id!),
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    color: AppColors.softCoral,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                child: CustomCard(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddExpenseScreen(
                                          isExpense: item.isExpense,
                                          expense: item,
                                        ),
                                      ),
                                    );
                                  },
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? AppColors.backgroundDark
                                              : AppColors.warmCream,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          _getCategoryIcon(item.category),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.category,
                                              style: AppTextStyles.body
                                                  .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            Text(
                                              item.note.isEmpty
                                                  ? DateFormat(
                                                      'h:mm a',
                                                    ).format(item.date)
                                                  : item.note,
                                              style: AppTextStyles.caption,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        AppFormatters.formatCurrency(
                                          item.amount,
                                          settings.currency,
                                          settings.locale,
                                        ),
                                        style: AppTextStyles.body.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: item.isExpense
                                              ? AppColors.softCoral
                                              : AppColors.successGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categories = CategoryUtils.expenseCategories
        .map((c) => c['name']!)
        .toList();
    categories.addAll(CategoryUtils.incomeCategories.map((c) => c['name']!));
    categories.add(l10n.other);
    final uniqueCategories = categories.toSet().toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : AppColors.warmCream,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.softGray.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Text(l10n.filters, style: AppTextStyles.h2Section),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        Text(
                          l10n.type,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [l10n.all, l10n.expense, l10n.income].map((
                            String type,
                          ) {
                            final isSelected = _selectedType == type;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(type),
                                selected: isSelected,
                                onSelected: (val) {
                                  if (val) {
                                    setModalState(() => _selectedType = type);
                                    setState(() => _selectedType = type);
                                  }
                                },
                                selectedColor: AppColors.accentTeal,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark ? Colors.white : Colors.black),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.categories,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: uniqueCategories.map((cat) {
                            final isSelected = _selectedCategories.contains(
                              cat,
                            );
                            return ChoiceChip(
                              label: Text(cat),
                              selected: isSelected,
                              onSelected: (val) {
                                setModalState(() {
                                  if (val) {
                                    _selectedCategories.add(cat);
                                  } else {
                                    _selectedCategories.remove(cat);
                                  }
                                });
                                setState(() {});
                              },
                              selectedColor: AppColors.accentTeal,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? Colors.white : Colors.black),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setModalState(() {
                                _selectedType = l10n.all;
                                _selectedCategories.clear();
                              });
                              setState(() {
                                _selectedType = l10n.all;
                                _selectedCategories.clear();
                              });
                              Navigator.pop(context);
                            },
                            child: Text(l10n.reset),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentTeal,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(l10n.apply),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getCategoryIcon(String category) {
    return CategoryUtils.getIcon(category);
  }
}
