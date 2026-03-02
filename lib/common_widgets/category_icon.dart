import 'package:flutter/material.dart';
import '../utils/category_utils.dart';

class CategoryIcon extends StatelessWidget {
  final String category;
  final bool isDark;
  final double size;
  final bool isSelected;

  const CategoryIcon({
    super.key,
    required this.category,
    this.isDark = false,
    this.size = 24.0,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconData = CategoryUtils.getIcon(
      category,
      isDark: isDark,
      isSelected: isSelected,
    );

    if (iconData is String) {
      return Image.asset(iconData, width: size, height: size);
    } else if (iconData is IconData) {
      final customColor = CategoryUtils.getColor(category);
      return Icon(iconData, size: size, color: customColor);
    }

    return Icon(
      Icons.help_outline,
      size: size,
      color: isDark ? Colors.white70 : Colors.black54,
    );
  }
}
