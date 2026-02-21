import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/custom_snackbar.dart';
import '../../models/expense.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/expense_controller.dart';
import '../../l10n/app_localizations.dart';

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
  late bool _isExpense;

  final List<Map<String, String>> _displayCategories = [
    {'name': 'Transport', 'icon': 'asstes/icons/transport-light-icon.png'},
    {'name': 'Food', 'icon': 'asstes/icons/food-light-icon.png'},
    {'name': 'Rent', 'icon': 'asstes/icons/rent-light-icon.png'},
    {'name': 'Bills', 'icon': 'asstes/icons/bills-light-icon.png'},
    {'name': 'Fun', 'icon': 'asstes/icons/fun-light-icon.png'},
    {'name': 'Shopping', 'icon': 'asstes/icons/shopping-light-icon.png'},
    {'name': 'Dinning', 'icon': 'asstes/icons/dinning-light-icon.png'},
    {'name': 'Health', 'icon': 'asstes/icons/health-light-icon.png'},
    {'name': 'Grocerry', 'icon': 'asstes/icons/grocerry-light-icon.png'},
    {'name': 'Add new', 'icon': 'asstes/icons/add-new-light-icon.png'},
  ];

  @override
  void initState() {
    super.initState();
    _isExpense = widget.isExpense;
    if (widget.expense != null) {
      _amountController.text = widget.expense!.amount.toString();
      _noteController.text = widget.expense!.note;
      _selectedCategory = widget.expense!.category;
      _selectedDate = widget.expense!.date;
      _isExpense = widget.expense!.isExpense;
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
      isExpense: _isExpense,
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
        _isExpense ? l10n.expenseSaved : l10n.incomeSaved,
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
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE4CB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isExpense = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isExpense
                                ? AppColors.primarySelected
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            l10n.addIncome,
                            style: TextStyle(
                              color: !_isExpense
                                  ? Colors.white
                                  : AppColors.charcoal,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isExpense = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isExpense
                                ? AppColors.primarySelected
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            l10n.addExpense,
                            style: TextStyle(
                              color: _isExpense
                                  ? Colors.white
                                  : AppColors.charcoal,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Date Display
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Text(
                        DateFormat(
                          'MMM dd, yyyy',
                        ).format(_selectedDate).toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primarySelected,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Amount Input
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '$currencySymbol',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.charcoal.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white70
                                  : const Color(0xFFCAD1E0),
                            ),
                            decoration: const InputDecoration(
                              hintText: '0',
                              hintStyle: TextStyle(color: Color(0xFFCAD1E0)),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 1.5,
                          color: const Color(0xFFCAD1E0),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        const Text(
                          '.00',
                          style: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFCAD1E0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),

                    // Categories
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 8,
                            childAspectRatio: 0.75,
                          ),
                      itemCount: _displayCategories.length,
                      itemBuilder: (context, index) {
                        final cat = _displayCategories[index];
                        final isSelected = _selectedCategory == cat['name'];
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedCategory = cat['name']!),
                          child: Column(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.cardDark
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 5),
                                    ),
                                    if (isSelected)
                                      BoxShadow(
                                        color: AppColors.primarySelected
                                            .withValues(alpha: 0.6),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                  ],
                                  border: isSelected
                                      ? Border.all(
                                          color: AppColors.primarySelected,
                                          width: 2,
                                        )
                                      : null,
                                ),
                                child: Image.asset(cat['icon']!),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                cat['name']!,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? const Color(0xFF4C5E7F)
                                      : const Color(0xFF8D99AE),
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),

                    // Note Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Add Note',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7F0),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFFE4CB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextField(
                            controller: _noteController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'Write here..',
                              hintStyle: TextStyle(color: Color(0xFFB0B8C1)),
                              border: InputBorder.none,
                            ),
                          ),
                          const Text(
                            'Optional',
                            style: TextStyle(
                              color: Color(0xFFB0B8C1),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Save Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _handleSave(l10n),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primarySelected,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    shadowColor: AppColors.primarySelected.withValues(
                      alpha: 0.5,
                    ),
                  ),
                  child: const Text(
                    'Save Transaction',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
