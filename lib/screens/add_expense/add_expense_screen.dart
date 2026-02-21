import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_text_field.dart';
import '../../common_widgets/primary_button.dart';
import '../../common_widgets/custom_snackbar.dart';
import '../../models/expense.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/expense_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/category_utils.dart';

class AddExpenseScreen extends StatefulWidget {
  final bool isExpense;
  final Expense? expense;

  const AddExpenseScreen({super.key, this.isExpense = true, this.expense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedCategory = '';
  DateTime _selectedDate = DateTime.now();

  final List<Map<String, String>> _expenseCategories = [
    ...CategoryUtils.expenseCategories,
  ];

  final List<Map<String, String>> _incomeCategories = [
    ...CategoryUtils.incomeCategories,
  ];

  List<Map<String, String>> get _categories {
    final l10n = AppLocalizations.of(context)!;
    final base = widget.isExpense ? _expenseCategories : _incomeCategories;
    return [
      ...base,
      {'icon': '➕', 'name': l10n.other},
    ];
  }

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _amountController.text = widget.expense!.amount.toString();
      _noteController.text = widget.expense!.note;
      _selectedCategory = widget.expense!.category;
      _selectedDate = widget.expense!.date;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primarySelected,
              onPrimary: Colors.white,
              onSurface: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textDark
                  : AppColors.charcoal,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _handleSave(AppLocalizations l10n) async {
    if (_amountController.text.isEmpty ||
        double.tryParse(_amountController.text) == null ||
        double.parse(_amountController.text) <= 0) {
      showCustomSnackBar(context, l10n.pleaseEnterValidAmount, isError: true);
      return;
    }
    if (_selectedCategory.isEmpty) {
      showCustomSnackBar(context, l10n.pleaseSelectCategory, isError: true);
      return;
    }

    final expense = Expense(
      id: widget.expense?.id,
      amount: double.parse(_amountController.text),
      category: _selectedCategory,
      note: _noteController.text,
      date: _selectedDate,
      isExpense: widget.isExpense,
    );

    final controller = context.read<ExpenseController>();
    if (widget.expense != null) {
      await controller.updateExpense(expense);
    } else {
      await controller.addExpense(expense);
    }

    if (mounted) {
      showCustomSnackBar(
        context,
        widget.isExpense ? l10n.expenseSaved : l10n.incomeSaved,
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final currencySymbol = SettingsController.supportedCurrencies.firstWhere(
      (c) => c['code'] == settings.currency,
    )['symbol'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.expense != null
              ? (widget.isExpense ? l10n.editExpense : l10n.editIncome)
              : (widget.isExpense ? l10n.addExpense : l10n.addIncome),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Date Picker Trigger
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.cardDark
                              : AppColors.softGray.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: AppColors.primarySelected,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat(
                                'MMMM dd, yyyy',
                                settings.locale.toString(),
                              ).format(_selectedDate),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primarySelected,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Amount Input
                    TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      autofocus: widget.expense == null,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.amountDisplay.copyWith(fontSize: 48),
                      decoration: InputDecoration(
                        hintText: '0.00',
                        prefixText: '$currencySymbol ',
                        prefixStyle: AppTextStyles.amountDisplay.copyWith(
                          fontSize: 48,
                          color: AppColors.softGray,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Categories
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(l10n.category, style: AppTextStyles.caption),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 85,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final cat = _categories[index];
                          final isSelected = _selectedCategory == cat['name'];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = cat['name']!;
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.cardDark
                                        : Colors.white,
                                    shape: BoxShape.circle,
                                    border: isSelected
                                        ? Border.all(
                                            color: AppColors.primarySelected,
                                            width: 2,
                                          )
                                        : Border.all(
                                            color: AppColors.softGray
                                                .withValues(alpha: 0.3),
                                          ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: AppColors.primarySelected
                                                  .withValues(alpha: 0.2),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Text(
                                    cat['icon']!,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  cat['name']!,
                                  style: AppTextStyles.caption.copyWith(
                                    fontSize: 10,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? AppColors.primarySelected
                                        : AppColors.softGray,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Note
                    CustomTextField(
                      controller: _noteController,
                      hintText: l10n.addNoteOptional,
                    ),
                  ],
                ),
              ),
            ),

            // Save Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: PrimaryButton(
                title: widget.expense != null
                    ? l10n.update
                    : (widget.isExpense ? l10n.saveExpense : l10n.saveIncome),
                onPressed: () => _handleSave(l10n),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
