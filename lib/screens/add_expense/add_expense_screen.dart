import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../services/database_service.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/custom_snackbar.dart';
import '../../models/expense.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/expense_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/app_layout.dart';
import '../../common_widgets/category_icon.dart';
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
  late bool _isExpense;

  List<Map<String, dynamic>> get _displayCategories {
    final List<Map<String, dynamic>> standard = _isExpense
        ? List.from(CategoryUtils.expenseCategories)
        : List.from(CategoryUtils.incomeCategories);

    final saved = CategoryUtils.getSavedCategories(isExpense: _isExpense);

    final List<Map<String, dynamic>> filtered = standard
        .where((cat) => cat['name'] != 'Add new')
        .toList();

    return [
      ...filtered,
      ...saved,
      standard.firstWhere((cat) => cat['name'] == 'Add new'),
    ];
  }

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

  String _getLocalizedCategoryName(String name, AppLocalizations l10n) {
    switch (name.toLowerCase()) {
      case 'transport':
        return l10n.transport;
      case 'food':
        return l10n.food;
      case 'rent':
        return l10n.rent;
      case 'bills':
        return l10n.bills;
      case 'fun':
        return l10n.fun;
      case 'shopping':
        return l10n.shopping;
      case 'dinning':
        return l10n.dinning;
      case 'health':
        return l10n.health;
      case 'grocerry':
        return l10n.grocerry;
      case 'add new':
        return l10n.addNew;
      case 'salary income':
        return l10n.salaryIncome;
      case 'freelance/side hustle':
        return l10n.freelanceSideHustle;
      case 'business income':
        return l10n.businessIncome;
      case 'investment return':
        return l10n.investmentReturn;
      case 'gif/bonus':
        return l10n.gifBonus;
      case 'refund/cashback':
        return l10n.refundCashback;
      default:
        return name;
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
              padding: EdgeInsets.symmetric(
                horizontal: AppLayout.horizontalPadding(context),
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE4CB),
                  borderRadius: BorderRadius.circular(6),
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
                            borderRadius: BorderRadius.circular(6),
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
                            borderRadius: BorderRadius.circular(6),
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
                padding: EdgeInsets.symmetric(
                  horizontal: AppLayout.horizontalPadding(context),
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Date Display
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Text(
                        DateFormat.yMMMd(
                          Localizations.localeOf(context).toString(),
                        ).format(_selectedDate).toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primarySelected,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

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
                            fontFamily: 'Serif',
                            color: isDark
                                ? Colors.white70
                                : const Color(0xFF4A4A4A),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IntrinsicWidth(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Serif',
                              color: isDark
                                  ? Colors.white70
                                  : const Color(0xFF4A4A4A),
                            ),
                            decoration: InputDecoration(
                              hintText: '0',
                              hintStyle: TextStyle(
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xFF4A4A4A),
                                fontSize: 48,
                                fontFamily: 'Serif',
                                fontWeight: FontWeight.bold,
                              ),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '.00',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Serif',
                            color: isDark
                                ? Colors.white70
                                : const Color(0xFF4A4A4A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),

                    // Categories
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.selectCategoryTitle,
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
                            childAspectRatio: 0.7,
                          ),
                      itemCount: _displayCategories.length,
                      itemBuilder: (context, index) {
                        final cat = _displayCategories[index];
                        final isSelected = _selectedCategory == cat['name'];

                        return GestureDetector(
                          onTap: () {
                            if (cat['name'] == 'Add new') {
                              _showCreateCategorySheet(context);
                            } else {
                              setState(() => _selectedCategory = cat['name']!);
                            }
                          },
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
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
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
                                child: CategoryIcon(
                                  category: cat['name']!,
                                  isDark: isDark,
                                  isSelected: isSelected,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _getLocalizedCategoryName(cat['name']!, l10n),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.primarySelected
                                      : (isDark
                                            ? Colors.white54
                                            : const Color(0xFF8D99AE)),
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
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
                        l10n.addNoteTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _noteController,
                      maxLines: 3,
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.charcoal,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.writeHere,
                        hintStyle: const TextStyle(color: Color(0xFFB0B8C1)),
                        filled: true,
                        fillColor: isDark
                            ? AppColors.cardDark
                            : const Color(0xFFFFF7F0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : const Color(0xFFFFE4CB),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primarySelected,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 12, top: 24),
                          child: Text(
                            l10n.optionalField,
                            style: const TextStyle(
                              color: Color(0xFFB0B8C1),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Save Button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppLayout.horizontalPadding(context),
                vertical: 16,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _handleSave(l10n),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primarySelected,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    shadowColor: AppColors.primarySelected.withValues(
                      alpha: 0.5,
                    ),
                  ),
                  child: Text(
                    l10n.saveTransaction,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateCategorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _CreateCategoryBottomSheet(
          onSaved: (categoryData) async {
            final icon = categoryData['iconData'];
            String kind = 'asset';
            String data = icon.toString();

            if (icon is IconData) {
              kind = icon.fontFamily == 'CupertinoIcons'
                  ? 'cupertino'
                  : 'material';
              data = icon.codePoint.toString();
            }

            await DatabaseService.instance.createCategory({
              'name': categoryData['name'],
              'iconKind': kind,
              'iconData': data,
              'color': (categoryData['color'] as Color).toARGB32(),
              'isExpense': _isExpense ? 1 : 0,
            });

            await CategoryUtils.loadCustomCategories();

            setState(() {
              _selectedCategory = categoryData['name'] as String;
            });
          },
        );
      },
    );
  }
}

class _CreateCategoryBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onSaved;
  const _CreateCategoryBottomSheet({required this.onSaved});

  @override
  State<_CreateCategoryBottomSheet> createState() =>
      _CreateCategoryBottomSheetState();
}

class _CreateCategoryBottomSheetState
    extends State<_CreateCategoryBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  dynamic _selectedIcon = 'assets/icons/add-new-icon.png';
  Color _selectedColor = const Color(0xFFF98D25);

  final List<Color> _colors = [
    const Color(0xFFE57373),
    const Color(0xFFFFF176),
    const Color(0xFF81C784),
    const Color(0xFF4DD0E1),
    const Color(0xFF5C6BC0),
    const Color(0xFFCE93D8),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 12,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              l10n.createNewCategory,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Serif',
                color: isDark ? Colors.white : AppColors.charcoal,
              ),
            ),
          ),
          const SizedBox(height: 32),
          _buildLabel(l10n.categoryName, isDark),
          const SizedBox(height: 12),
          _buildTextField(_nameController, l10n.enterName, isDark),
          const SizedBox(height: 24),
          _buildLabel(l10n.selectIcon, isDark),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _showIconPicker(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : const Color(0xFFD1D1D1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _selectedIcon is String
                      ? Image.asset(
                          _selectedIcon as String,
                          width: 28,
                          height: 28,
                        )
                      : Icon(
                          _selectedIcon as IconData,
                          size: 28,
                          color: _selectedColor,
                        ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.chooseAnIcon,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : const Color(0xFF4A4A4A),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_drop_down,
                    color: isDark ? Colors.white38 : Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildLabel(l10n.selectColor, isDark),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ..._colors.map((color) {
                  final isSelected = _selectedColor == color;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: color.withValues(alpha: 0.4),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                          ],
                          border: isSelected
                              ? Border.all(
                                  color: isDark ? Colors.white : Colors.black,
                                  width: 2,
                                )
                              : null,
                        ),
                      ),
                    ),
                  );
                }),
                GestureDetector(
                  onTap: () => _pickCustomColor(context),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const SweepGradient(
                        colors: [
                          Colors.red,
                          Colors.orange,
                          Colors.yellow,
                          Colors.green,
                          Colors.blue,
                          Colors.indigo,
                          Colors.purple,
                          Colors.red,
                        ],
                      ),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      color: isDark ? Colors.white : Colors.white,
                      shadows: const [
                        Shadow(color: Colors.black26, blurRadius: 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  widget.onSaved({
                    'name': _nameController.text,
                    'iconData': _selectedIcon,
                    'color': _selectedColor,
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primarySelected,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: AppColors.primarySelected.withValues(alpha: 0.4),
              ),
              child: Text(
                l10n.createCategory,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickCustomColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.pickAColor),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) => setState(() => _selectedColor = color),
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.done),
            ),
          ],
        );
      },
    );
  }

  void _showIconPicker(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final List<String> assetIcons = [
      ...CategoryUtils.expenseCategories
          .map((e) => e['lightUnselected']!)
          .where((e) => e.isNotEmpty),
      ...CategoryUtils.incomeCategories
          .map((e) => e['lightUnselected']!)
          .where((e) => e.isNotEmpty),
      'assets/icons/add-new-icon.png',
    ].toSet().toList();

    final List<IconData> commonMaterial = [
      Icons.shopping_cart,
      Icons.restaurant,
      Icons.directions_car,
      Icons.home,
      Icons.work,
      Icons.school,
      Icons.fitness_center,
      Icons.movie,
      Icons.pets,
      Icons.local_gas_station,
      Icons.flight,
      Icons.hotel,
      Icons.card_giftcard,
      Icons.receipt_long,
      Icons.sports_esports,
      Icons.medical_services,
      Icons.laptop,
      Icons.coffee,
      Icons.shopping_bag,
      Icons.account_balance,
      Icons.attach_money,
      Icons.brush,
      Icons.build,
      Icons.camera_alt,
      Icons.child_friendly,
      Icons.cleaning_services,
      Icons.computer,
      Icons.devices,
      Icons.edit,
      Icons.event,
      Icons.fastfood,
      Icons.favorite,
      Icons.flash_on,
      Icons.headset,
      Icons.lightbulb,
      Icons.local_hospital,
      Icons.music_note,
      Icons.phone,
      Icons.print,
      Icons.security,
      Icons.star,
      Icons.tablet,
      Icons.videogame_asset,
      Icons.vpn_key,
      Icons.wallet,
      Icons.watch,
      Icons.wifi,
    ];

    final List<IconData> commonCupertino = [
      CupertinoIcons.cart,
      CupertinoIcons.bag,
      CupertinoIcons.house,
      CupertinoIcons.lightbulb,
      CupertinoIcons.music_note,
      CupertinoIcons.paw,
      CupertinoIcons.person,
      CupertinoIcons.phone,
      CupertinoIcons.settings,
      CupertinoIcons.star,
      CupertinoIcons.tag,
      CupertinoIcons.trash,
      CupertinoIcons.wrench,
      CupertinoIcons.airplane,
      CupertinoIcons.alarm,
      CupertinoIcons.ant,
      CupertinoIcons.bandage,
      CupertinoIcons.barcode,
      CupertinoIcons.bell,
      CupertinoIcons.briefcase,
      CupertinoIcons.bus,
      CupertinoIcons.camera,
      CupertinoIcons.car,
      CupertinoIcons.clock,
      CupertinoIcons.cloud,
      CupertinoIcons.creditcard,
      CupertinoIcons.device_laptop,
      CupertinoIcons.device_phone_landscape,
      CupertinoIcons.device_phone_portrait,
      CupertinoIcons.flame,
      CupertinoIcons.gamecontroller,
      CupertinoIcons.gift,
      CupertinoIcons.hammer,
      CupertinoIcons.heart,
      CupertinoIcons.infinite,
      CupertinoIcons.info,
      CupertinoIcons.keyboard,
      CupertinoIcons.link,
      CupertinoIcons.lock,
      CupertinoIcons.mail,
      CupertinoIcons.map,
      CupertinoIcons.mic,
      CupertinoIcons.moon,
      CupertinoIcons.paintbrush,
      CupertinoIcons.pencil,
      CupertinoIcons.printer,
      CupertinoIcons.scissors,
      CupertinoIcons.search,
      CupertinoIcons.smiley,
      CupertinoIcons.snow,
      CupertinoIcons.speaker,
      CupertinoIcons.sun_max,
      CupertinoIcons.ticket,
      CupertinoIcons.timer,
      CupertinoIcons.train_style_one,
      CupertinoIcons.tv,
      CupertinoIcons.umbrella,
      CupertinoIcons.video_camera,
      CupertinoIcons.waveform,
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.selectIcon,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        _sectionTitle(l10n.appAssets),
                        _iconGrid(assetIcons, true, setModalState),
                        _sectionTitle(l10n.materialIcons),
                        _iconGrid(commonMaterial, false, setModalState),
                        _sectionTitle(l10n.cupertinoIcons),
                        _iconGrid(commonCupertino, false, setModalState),
                        const SizedBox(height: 24),
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

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _iconGrid(List<dynamic> icons, bool isAsset, Function setModalState) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: icons.length,
      itemBuilder: (context, index) {
        final icon = icons[index];
        final isSelected = _selectedIcon == icon;
        return GestureDetector(
          onTap: () {
            setState(() => _selectedIcon = icon);
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primarySelected.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.primarySelected
                    : Colors.grey.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: isAsset
                ? Image.asset(icon as String)
                : Icon(
                    icon as IconData,
                    size: 24,
                    color: isSelected
                        ? AppColors.primarySelected
                        : (_selectedIcon == icon ? _selectedColor : null),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white70 : const Color(0xFF4A4A4A),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : const Color(0xFFD1D1D1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: isDark ? Colors.white : AppColors.charcoal),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: isDark ? Colors.white24 : const Color(0xFF9E9E9E),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
}
