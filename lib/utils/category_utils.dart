class CategoryUtils {
  static const List<Map<String, String>> expenseCategories = [
    {
      'name': 'Transport',
      'lightIcon': 'assets/icons/transport-light-icon.png',
      'darkIcon': 'assets/icons/transport-dark-icon.png',
    },
    {
      'name': 'Food',
      'lightIcon': 'assets/icons/food-light-icon.png',
      'darkIcon': 'assets/icons/food-dark-icon.png',
    },
    {
      'name': 'Rent',
      'lightIcon': 'assets/icons/rent-light-icon.png',
      'darkIcon': 'assets/icons/rent-dark-icon.png',
    },
    {
      'name': 'Bills',
      'lightIcon': 'assets/icons/bills-light-icon.png',
      'darkIcon': 'assets/icons/bills-dark-icon.png',
    },
    {
      'name': 'Fun',
      'lightIcon': 'assets/icons/fun-light-icon.png',
      'darkIcon': 'assets/icons/fun-dark-icon.png',
    },
    {
      'name': 'Shopping',
      'lightIcon': 'assets/icons/shopping-light-icon.png',
      'darkIcon': 'assets/icons/shopping-dark-icon.png',
    },
    {
      'name': 'Dinning',
      'lightIcon': 'assets/icons/dinning-light-icon.png',
      'darkIcon': 'assets/icons/dinning-dark-icon.png',
    },
    {
      'name': 'Health',
      'lightIcon': 'assets/icons/health-light-icon.png',
      'darkIcon': 'assets/icons/health-dark-icon.png',
    },
    {
      'name': 'Grocerry',
      'lightIcon': 'assets/icons/grocerry-light-icon.png',
      'darkIcon': 'assets/icons/grocerry-dark-icon.png',
    },
    {
      'name': 'Other',
      'lightIcon': 'assets/icons/add-new-light-icon.png',
      'darkIcon': 'assets/icons/add-new-dark-icon.png',
    },
  ];

  static const List<Map<String, String>> incomeCategories = [
    {
      'name': 'Salary',
      'lightIcon': 'assets/icons/add-new-light-icon.png',
      'darkIcon': 'assets/icons/add-new-dark-icon.png',
    },
    {
      'name': 'Gift',
      'lightIcon': 'assets/icons/add-new-light-icon.png',
      'darkIcon': 'assets/icons/add-new-dark-icon.png',
    },
    {
      'name': 'Other',
      'lightIcon': 'assets/icons/add-new-light-icon.png',
      'darkIcon': 'assets/icons/add-new-dark-icon.png',
    },
  ];

  static String getIcon(String category, {bool isDark = false}) {
    final allCats = [...expenseCategories, ...incomeCategories];
    for (var cat in allCats) {
      if (cat['name']!.toLowerCase() == category.toLowerCase()) {
        return isDark ? cat['darkIcon']! : cat['lightIcon']!;
      }
    }
    // Default fallback
    return isDark
        ? 'assets/icons/add-new-dark-icon.png'
        : 'assets/icons/add-new-light-icon.png';
  }
}
