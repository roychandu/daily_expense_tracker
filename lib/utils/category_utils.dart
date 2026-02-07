class CategoryUtils {
  static const List<Map<String, String>> expenseCategories = [
    {'icon': '🍔', 'name': 'Food'},
    {'icon': '🚗', 'name': 'Transport'},
    {'icon': '🏠', 'name': 'Home'},
    {'icon': '🎮', 'name': 'Fun'},
    {'icon': '💊', 'name': 'Health'},
    {'icon': '🛍️', 'name': 'Shopping'},
    {'icon': '📚', 'name': 'Education'},
  ];

  static const List<Map<String, String>> incomeCategories = [
    {'icon': '💰', 'name': 'Salary'},
    {'icon': '🎁', 'name': 'Gift'},
    {'icon': '📈', 'name': 'Investment'},
    {'icon': '🏢', 'name': 'Business'},
  ];

  static String getIcon(String category) {
    for (var cat in [...expenseCategories, ...incomeCategories]) {
      if (cat['name'] == category) {
        return cat['icon']!;
      }
    }
    return '💰'; // Default
  }
}
