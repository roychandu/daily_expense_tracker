import 'package:flutter/material.dart';
import '../services/database_service.dart';

class CategoryUtils {
  static final Map<String, Map<String, dynamic>> _customCache = {};

  static Future<void> loadCustomCategories() async {
    final categories = await DatabaseService.instance.readAllCategories();
    _customCache.clear();
    for (var cat in categories) {
      _customCache[cat['name'] as String] = cat;
    }
  }

  static List<Map<String, dynamic>> getSavedCategories({
    required bool isExpense,
  }) {
    return _customCache.values
        .where((cat) => (cat['isExpense'] as int) == (isExpense ? 1 : 0))
        .toList();
  }

  static const List<Map<String, String>> expenseCategories = [
    {
      'name': 'Transport',
      'lightUnselected': 'assets/icons/transport-light-unselectedicon.png',
      'lightSelected': 'assets/icons/transport-light-selectedicon.png',
      'darkUnselected': 'assets/icons/transport-dark-unselectedicon.png',
      'darkSelected': 'assets/icons/transport-dark-selectedicon.png',
    },
    {
      'name': 'Food',
      'lightUnselected': 'assets/icons/food-light-unselectedicon.png',
      'lightSelected': 'assets/icons/food-light-selectedicon.png',
      'darkUnselected': 'assets/icons/food-dark-unselectedicon.png',
      'darkSelected': 'assets/icons/food-dark-selectedicon.png',
    },
    {
      'name': 'Rent',
      'lightUnselected': 'assets/icons/rent-light-unselectedicon.png',
      'lightSelected': 'assets/icons/rent-light-selectedicon.png',
      'darkUnselected': 'assets/icons/rent-dark-unselectedicon.png',
      'darkSelected': 'assets/icons/rent-dark-selectedicon.png',
    },
    {
      'name': 'Bills',
      'lightUnselected': 'assets/icons/bills-light-unselectedicon.png',
      'lightSelected': 'assets/icons/bills-light-selectedicon.png',
      'darkUnselected': 'assets/icons/bills-dark-unselectedicon.png',
      'darkSelected': 'assets/icons/bills-dark-selectedicon.png',
    },
    {
      'name': 'Fun',
      'lightUnselected': 'assets/icons/fun-light-unselectedicon.png',
      'lightSelected': 'assets/icons/fun-light-selectedicon.png',
      'darkUnselected': 'assets/icons/fun-dark-unselectedicon.png',
      'darkSelected': 'assets/icons/fun-dark-selectedicon.png',
    },
    {
      'name': 'Shopping',
      'lightUnselected': 'assets/icons/shopping-light-unselectedicon.png',
      'lightSelected': 'assets/icons/shopping-light-selectedicon.png',
      'darkUnselected': 'assets/icons/shopping-dark-unselectedicon.png',
      'darkSelected': 'assets/icons/shopping-dark-selectedicon.png',
    },
    {
      'name': 'Dinning',
      'lightUnselected': 'assets/icons/dinning-light-unselectedicon.png',
      'lightSelected': 'assets/icons/dinning-light-selectedicon.png',
      'darkUnselected': 'assets/icons/dinning-dark-unselectedicon.png',
      'darkSelected': 'assets/icons/dinning-dark-selectedicon.png',
    },
    {
      'name': 'Health',
      'lightUnselected': 'assets/icons/health-light-unselectedicon.png',
      'lightSelected': 'assets/icons/health-light-selectedicon.png',
      'darkUnselected': 'assets/icons/health-dark-unselectedicon.png',
      'darkSelected': 'assets/icons/health-dark-selectedicon.png',
    },
    {
      'name': 'Grocerry',
      'lightUnselected': 'assets/icons/grocerry-light-unselectedicon.png',
      'lightSelected': 'assets/icons/grocerry-light-selectedicon.png',
      'darkUnselected': 'assets/icons/grocerry-dark-unselectedicon.png',
      'darkSelected': 'assets/icons/grocerry-dark-selectedicon.png',
    },
    {
      'name': 'Add new',
      'lightUnselected': 'assets/icons/add-new-icon.png',
      'lightSelected': 'assets/icons/add-new-icon.png',
      'darkUnselected': 'assets/icons/add-new-icon.png',
      'darkSelected': 'assets/icons/add-new-icon.png',
    },
  ];

  static const List<Map<String, String>> incomeCategories = [
    {
      'name': 'Salary Income',
      'lightUnselected': 'assets/icons/salary icome light selectedicon.png',
      'lightSelected': 'assets/icons/salary income light selectedicon.png',
      'darkUnselected': 'assets/icons/salary icome light selectedicon.png',
      'darkSelected': 'assets/icons/salary income light selectedicon.png',
    },
    {
      'name': 'Freelance/side hustle',
      'lightUnselected': 'assets/icons/freelance side light unselectedicon.png',
      'lightSelected': 'assets/icons/freelance side light selectedicon.png',
      'darkUnselected': 'assets/icons/freelance side light unselectedicon.png',
      'darkSelected': 'assets/icons/freelance side light selectedicon.png',
    },
    {
      'name': 'Business Income',
      'lightUnselected':
          'assets/icons/business income light unselectedicon.png',
      'lightSelected': 'assets/icons/business icome light selectedicon.png',
      'darkUnselected': 'assets/icons/business income light unselectedicon.png',
      'darkSelected': 'assets/icons/business icome light selectedicon.png',
    },
    {
      'name': 'Investment return',
      'lightUnselected': 'assets/icons/investment light unselectedicon.png',
      'lightSelected': 'assets/icons/investment light selectedicon.png',
      'darkUnselected': 'assets/icons/investment light unselectedicon.png',
      'darkSelected': 'assets/icons/investment light selectedicon.png',
    },
    {
      'name': 'Gif/bonus',
      'lightUnselected': 'assets/icons/gif light unselectedicon.png',
      'lightSelected': 'assets/icons/git light selectedicon.png',
      'darkUnselected': 'assets/icons/gif light unselectedicon.png',
      'darkSelected': 'assets/icons/git light selectedicon.png',
    },
    {
      'name': 'Refund/cashback',
      'lightUnselected': 'assets/icons/refund light unselected.png',
      'lightSelected': 'assets/icons/refund light selectedicon.png',
      'darkUnselected': 'assets/icons/refund light unselected.png',
      'darkSelected': 'assets/icons/refund light selectedicon.png',
    },
    {
      'name': 'Add new',
      'lightUnselected': 'assets/icons/add-new-icon.png',
      'lightSelected': 'assets/icons/add-new-icon.png',
      'darkUnselected': 'assets/icons/add-new-icon.png',
      'darkSelected': 'assets/icons/add-new-icon.png',
    },
  ];

  static dynamic getIcon(
    String category, {
    bool isDark = false,
    bool isSelected = false,
  }) {
    // Check custom cache first
    if (_customCache.containsKey(category)) {
      final info = _customCache[category]!;
      if (info['iconKind'] == 'asset') {
        return info['iconData'] as String;
      } else if (info['iconKind'] == 'material') {
        return IconData(
          int.parse(info['iconData'] as String),
          fontFamily: 'MaterialIcons',
        );
      } else if (info['iconKind'] == 'cupertino') {
        return IconData(
          int.parse(info['iconData'] as String),
          fontFamily: 'CupertinoIcons',
          fontPackage: 'cupertino_icons',
        );
      }
    }

    final allCats = [...expenseCategories, ...incomeCategories];
    for (var cat in allCats) {
      if (cat['name']!.toLowerCase() == category.toLowerCase()) {
        if (isSelected) {
          return isDark ? cat['darkSelected']! : cat['lightSelected']!;
        } else {
          return isDark ? cat['darkUnselected']! : cat['lightUnselected']!;
        }
      }
    }
    return 'assets/icons/add-new-icon.png';
  }

  static Color getColor(String category) {
    if (_customCache.containsKey(category)) {
      final colorVal = _customCache[category]!['color'];
      if (colorVal != null) return Color(colorVal as int);
    }

    // Fallback for standard categories
    switch (category.toLowerCase()) {
      case 'transport':
        return Colors.blue;
      case 'food':
        return Colors.orange;
      case 'rent':
        return Colors.purple;
      case 'bills':
        return const Color(0xFFE76F51); // AppColors.softCoral
      case 'fun':
        return Colors.pink;
      case 'shopping':
        return const Color(0xFF2A9D8F); // AppColors.accentTeal
      case 'dinning':
        return Colors.amber;
      case 'health':
        return const Color(0xFF06D6A0); // AppColors.successGreen
      case 'grocerry':
        return Colors.lime;
      case 'salary income':
        return const Color(0xFF06D6A0);
      case 'freelance/side hustle':
        return Colors.cyan;
      case 'business income':
        return Colors.indigo;
      case 'investment return':
        return Colors.deepPurple;
      case 'gif/bonus':
        return Colors.yellow;
      case 'refund/cashback':
        return Colors.lightGreen;
      default:
        return const Color(0xFFF98D25); // AppColors.primarySelected
    }
  }
}
