import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_card.dart';
import '../../common_widgets/custom_text_field.dart';

class ExpenseHistoryScreen extends StatefulWidget {
  const ExpenseHistoryScreen({super.key});

  @override
  State<ExpenseHistoryScreen> createState() => _ExpenseHistoryScreenState();
}

class _ExpenseHistoryScreenState extends State<ExpenseHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _historyData = [
    {
      'date': 'TODAY',
      'items': [
        {
          'title': 'Lunch',
          'amount': r'$12.00',
          'time': '1:15pm',
          'icon': '🍔',
          'category': 'Food',
        },
        {
          'title': 'Coffee',
          'amount': r'$4.50',
          'time': '9:30am',
          'icon': '☕',
          'category': 'Food',
        },
      ],
    },
    {
      'date': 'YESTERDAY',
      'items': [
        {
          'title': 'Uber',
          'amount': r'$18.00',
          'time': '7:45pm',
          'icon': '🚗',
          'category': 'Transport',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {},
          ), // Export placeholder
        ],
      ),
      body: Column(
        children: [
          // Search & Filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _searchController,
                    hintText: 'Search expenses...',
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
                    onPressed: () {
                      // Show filter bottom sheet
                    },
                  ),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _historyData.length,
              itemBuilder: (context, sectionIndex) {
                final section = _historyData[sectionIndex];
                final items = section['items'] as List;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        section['date'],
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
                          key: Key(item['time']), // Unique key in real app
                          direction: DismissDirection.endToStart,
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
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Text(
                                  item['icon'],
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'],
                                        style: AppTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        item['time'],
                                        style: AppTextStyles.caption,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  item['amount'],
                                  style: AppTextStyles.amountDisplay.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
