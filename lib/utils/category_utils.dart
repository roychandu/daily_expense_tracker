import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../services/database_service.dart';
import '../common_widgets/app_colors.dart';

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

  static const List<IconData> commonMaterialIcons = [
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

  static const List<IconData> commonCupertinoIcons = [
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

  static final Map<int, IconData> materialIconMap = {
    for (var icon in commonMaterialIcons) icon.codePoint: icon,
  };

  static final Map<int, IconData> cupertinoIconMap = {
    for (var icon in commonCupertinoIcons) icon.codePoint: icon,
  };

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
        final code = int.parse(info['iconData'] as String);
        return materialIconMap[code] ?? Icons.category;
      } else if (info['iconKind'] == 'cupertino') {
        final code = int.parse(info['iconData'] as String);
        return cupertinoIconMap[code] ?? CupertinoIcons.square_grid_2x2;
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
        return AppColors.categoryBlue;
      case 'food':
        return AppColors.accentOrange;
      case 'rent':
        return AppColors.categoryPurple;
      case 'bills':
        return AppColors.softCoral;
      case 'fun':
        return AppColors.categoryPink;
      case 'shopping':
        return AppColors.accentTeal;
      case 'dinning':
        return AppColors.categoryAmber;
      case 'health':
        return AppColors.successGreen;
      case 'grocerry':
        return AppColors.categoryLime;
      case 'salary income':
        return AppColors.successGreen;
      case 'freelance/side hustle':
        return AppColors.categoryCyanAccent;
      case 'business income':
        return AppColors.categoryIndigo;
      case 'investment return':
        return AppColors.categoryDeepPurple;
      case 'gif/bonus':
        return AppColors.categoryYellow;
      case 'refund/cashback':
        return AppColors.categoryLightGreen;
      default:
        return AppColors.primarySelected;
    }
  }
}
