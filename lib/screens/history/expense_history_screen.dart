import 'package:flutter/material.dart';
import '../add_expense/add_expense_screen.dart';
import 'package:intl/intl.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_card.dart';
import '../../common_widgets/custom_text_field.dart';
import '../../services/database_service.dart';
import '../../models/expense.dart';
import '../../controllers/settings_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/formatters.dart';
import '../../utils/category_utils.dart';
import 'package:provider/provider.dart';

class ExpenseHistoryScreen extends StatefulWidget {
  const ExpenseHistoryScreen({super.key});

  @override
  State<ExpenseHistoryScreen> createState() => _ExpenseHistoryScreenState();
}

class _ExpenseHistoryScreenState extends State<ExpenseHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Expense> _allExpenses = [];
  Map<String, List<Expense>> _groupedExpenses = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterExpenses();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final expenses = await DatabaseService.instance.readAllExpenses();
    setState(() {
      _allExpenses = expenses;
      _isLoading = false;
    });
    _filterExpenses();
  }

  void _filterExpenses() {
    final l10n = AppLocalizations.of(context)!;
    final query = _searchController.text.toLowerCase();
    final filtered = _allExpenses.where((e) {
      return e.category.toLowerCase().contains(query) ||
          e.note.toLowerCase().contains(query);
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

    setState(() {
      _groupedExpenses = groups;
    });
  }

  Future<void> _deleteExpense(int id) async {
    await DatabaseService.instance.delete(id);
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final keys = _groupedExpenses.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.history),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Mock export
            },
          ),
        ],
      ),
      body: Column(
        children: [
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
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _groupedExpenses.isEmpty
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
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddExpenseScreen(
                                          isExpense: item.isExpense,
                                          expense: item,
                                        ),
                                      ),
                                    );
                                    if (result == true) {
                                      _loadHistory();
                                    }
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

  String _getCategoryIcon(String category) {
    return CategoryUtils.getIcon(category);
  }
}
