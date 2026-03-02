import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../controllers/settings_controller.dart';
import '../../utils/formatters.dart';
import '../../utils/category_utils.dart';
import 'dart:ui';

Widget buildLockedInsightsBody({
  required BuildContext context,
  required bool isDark,
  required double netBalance,
  required double totalMonthlyIncome,
  required double totalMonthlyExpense,
  required SettingsController settings,
  required DateTime selectedDate,
  required VoidCallback onSelectMonth,
  required int transactionCount,
  required List<MapEntry<String, double>> sortedCategories,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _summarySection(
        isDark: isDark,
        netBalance: netBalance,
        totalMonthlyIncome: totalMonthlyIncome,
        totalMonthlyExpense: totalMonthlyExpense,
        settings: settings,
        selectedDate: selectedDate,
        onSelectMonth: onSelectMonth,
        transactionCount: transactionCount,
        isPremium: false,
      ),
      const SizedBox(height: 32),
      _spendingBreakdownSection(
        sortedCategories: sortedCategories,
        totalMonthlyExpense: totalMonthlyExpense,
        settings: settings,
        isLocked: true,
      ),
      const SizedBox(height: 32),
      const _LockedInsightsCard(),
    ],
  );
}

Widget _summarySection({
  required bool isDark,
  required double netBalance,
  required double totalMonthlyIncome,
  required double totalMonthlyExpense,
  required SettingsController settings,
  required DateTime selectedDate,
  required VoidCallback onSelectMonth,
  required int transactionCount,
  required bool isPremium,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${DateFormat('MMMM').format(selectedDate).toUpperCase()} SUMMARY',
              style: AppTextStyles.caption.copyWith(
                letterSpacing: 1.2,
                color: isDark ? Colors.white60 : Colors.black54,
                fontSize: 11,
              ),
            ),
            GestureDetector(
              onTap: onSelectMonth,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: isDark ? 0.3 : 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            AppFormatters.formatCurrency(
              netBalance,
              settings.currency,
              settings.locale,
            ),
            style: AppTextStyles.amountDisplay.copyWith(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              fontFamily: 'Serif',
            ),
          ),
        ),
        Text(
          'Net Balance',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.successGreen,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _summaryItem(
              'Income',
              totalMonthlyIncome,
              AppColors.successGreen,
              isDark,
              settings,
            ),
            const SizedBox(width: 16),
            _summaryItem(
              'Expense',
              totalMonthlyExpense,
              AppColors.softCoral,
              isDark,
              settings,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _summaryItem(
  String label,
  double amount,
  Color color,
  bool isDark,
  SettingsController settings,
) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white60 : Colors.black54,
            fontSize: 12,
          ),
        ),
        Text(
          AppFormatters.formatCurrency(
            amount,
            settings.currency,
            settings.locale,
          ),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'Serif',
          ),
        ),
      ],
    ),
  );
}

Widget _spendingBreakdownSection({
  required List<MapEntry<String, double>> sortedCategories,
  required double totalMonthlyExpense,
  required SettingsController settings,
  required bool isLocked,
}) {
  final itemsToShow = sortedCategories.take(3).toList();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Top Spending Breakdown',
            style: AppTextStyles.h2Section.copyWith(
              fontSize: 20,
              fontFamily: 'Serif',
            ),
          ),
          Text(
            'VIEW ALL',
            style: TextStyle(
              color: Colors.orange.withValues(alpha: 0.8),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      ...List.generate(itemsToShow.length, (index) {
        final entry = itemsToShow[index];
        final percentage = totalMonthlyExpense > 0
            ? (entry.value / totalMonthlyExpense) * 100
            : 0.0;
        return _categoryProgressBar(
          category: entry.key,
          amount: entry.value,
          percentage: percentage,
          settings: settings,
          isBlurred: isLocked && index == 2,
          isDark: settings.themeMode == ThemeMode.dark, // Simplified
        );
      }),
    ],
  );
}

Widget _categoryProgressBar({
  required String category,
  required double amount,
  required double percentage,
  required SettingsController settings,
  required bool isBlurred,
  required bool isDark,
}) {
  Widget content = Padding(
    padding: const EdgeInsets.only(bottom: 20.0),
    child: Column(
      children: [
        Row(
          children: [
            Image.asset(
              CategoryUtils.getIcon(category, isDark: isDark),
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                category,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ),
            Text(
              AppFormatters.formatCurrency(
                amount,
                settings.currency,
                settings.locale,
                decimalDigits: 0,
              ),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.black12,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            FractionallySizedBox(
              widthFactor: (percentage / 100).clamp(0.01, 1.0),
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  if (isBlurred) {
    return ClipRect(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: content,
      ),
    );
  }
  return content;
}

class _LockedInsightsCard extends StatelessWidget {
  const _LockedInsightsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A),
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: AssetImage('assets/images/locked-card-bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.orange, size: 24),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Unlock to watch full Insights',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _bulletItem('Detailed spending breakdown'),
          _bulletItem('Smart tailored insights'),
          _bulletItem('Weekly Inc vs Exp trend'),
          _bulletItem('Monthly trend'),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      context.read<SettingsController>().updatePremium(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Upgrade Now',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      context.read<SettingsController>().unlockInsightsViaAd(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Watch Ads',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: Colors.white70),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
