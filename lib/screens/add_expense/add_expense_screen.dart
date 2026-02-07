import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_text_field.dart';
import '../../common_widgets/primary_button.dart';
import '../../common_widgets/custom_snackbar.dart';
import '../../models/expense.dart';
import '../../services/database_service.dart';

class AddExpenseScreen extends StatefulWidget {
  final bool isExpense;
  const AddExpenseScreen({super.key, this.isExpense = true});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedCategory = '';

  final List<Map<String, String>> _categories = [
    {'icon': '🍔', 'name': 'Food'},
    {'icon': '🚗', 'name': 'Transport'},
    {'icon': '🏠', 'name': 'Home'},
    {'icon': '🎮', 'name': 'Fun'},
    {'icon': '💊', 'name': 'Health'},
    {'icon': '➕', 'name': 'Add'},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_amountController.text.isEmpty ||
        double.tryParse(_amountController.text) == null ||
        double.parse(_amountController.text) <= 0) {
      showCustomSnackBar(context, 'Please enter a valid amount', isError: true);
      return;
    }
    if (_selectedCategory.isEmpty) {
      showCustomSnackBar(context, 'Please select a category', isError: true);
      return;
    }

    final expense = Expense(
      amount: double.parse(_amountController.text),
      category: _selectedCategory,
      note: _noteController.text,
      date: DateTime.now(),
      isExpense: widget.isExpense,
    );

    await DatabaseService.instance.create(expense);

    if (mounted) {
      showCustomSnackBar(
        context,
        '${widget.isExpense ? 'Expense' : 'Income'} saved ✓',
      );
      Navigator.pop(
        context,
        true,
      ); // Return true to indicate something was saved
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Amount Input
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      autofocus: true,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.amountDisplay.copyWith(fontSize: 48),
                      decoration: InputDecoration(
                        hintText: '0.00',
                        prefixText: '\$ ',
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
                      child: Text('Category', style: AppTextStyles.caption),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
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
                                            color: AppColors.accentTeal,
                                            width: 2,
                                          )
                                        : Border.all(
                                            color: AppColors.softGray
                                                .withOpacity(0.3),
                                          ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: AppColors.accentTeal
                                                  .withOpacity(0.2),
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
                                    fontSize: 12,
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
                      hintText: 'Add note (optional)',
                    ),
                  ],
                ),
              ),
            ),

            // Save Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: PrimaryButton(
                title: 'Save Expense',
                onPressed: _handleSave,
              ),
            ),
            // Padding for keyboard would be handled by scaffold/scroll view usually,
            // but for now this is fixed at bottom
          ],
        ),
      ),
    );
  }
}
