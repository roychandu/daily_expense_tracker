import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_card.dart';
import '../../common_widgets/primary_button.dart';

class MonthlySummaryScreen extends StatefulWidget {
  const MonthlySummaryScreen({super.key});

  @override
  State<MonthlySummaryScreen> createState() => _MonthlySummaryScreenState();
}

class _MonthlySummaryScreenState extends State<MonthlySummaryScreen> {
  bool _isUnlocked = false; // Mock state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('January 2026'),
            const Icon(Icons.arrow_drop_down, color: AppColors.accentTeal),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Total Card
            CustomCard(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MONTHLY TOTAL',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      r'$1,847.50',
                      style: AppTextStyles.amountDisplay.copyWith(fontSize: 32),
                    ),
                    const SizedBox(height: 4),
                    Text('64 expenses', style: AppTextStyles.body),
                    if (!_isUnlocked) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text('Top category: ', style: AppTextStyles.caption),
                          const Text(
                            '🍔 Food',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            if (!_isUnlocked) _buildLockedState() else _buildUnlockedState(),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('DETAILS', style: AppTextStyles.h2Section.copyWith(fontSize: 18)),
        const SizedBox(height: 12),
        CustomCard(
          child: Column(
            children: [
              const Icon(Icons.lock, size: 48, color: AppColors.accentTeal),
              const SizedBox(height: 16),
              Text('Unlock Full Breakdown', style: AppTextStyles.h2Section),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• Category breakdown', style: AppTextStyles.body),
                    Text('• Daily average spend', style: AppTextStyles.body),
                    Text('• Highest spend day', style: AppTextStyles.body),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                title: 'Watch Ad to Unlock',
                onPressed: () {
                  setState(() => _isUnlocked = true);
                },
              ),
              const SizedBox(height: 12),
              Text('or', style: AppTextStyles.caption),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  // IAP flow
                },
                child: Text(
                  'Remove Ads - \$3.99',
                  style: AppTextStyles.body.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.accentTeal
                        : AppColors.primaryDeepBlue,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUnlockedState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Breakdown
        Text(
          'CATEGORY BREAKDOWN',
          style: AppTextStyles.h2Section.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 12),
        _buildCategoryRow('🍔 Food', r'$720', 0.39),
        _buildCategoryRow('🚗 Transport', r'$450', 0.24),
        _buildCategoryRow('🏠 Home', r'$380', 0.21),

        const SizedBox(height: 24),

        // Insights
        Text('INSIGHTS', style: AppTextStyles.h2Section.copyWith(fontSize: 18)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CustomCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Daily Avg', style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Text(
                      r'$61.58',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Highest Day', style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Text(
                      'Jan 15 (\$145)',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryRow(String title, String amount, double percentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  amount,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: (percentage * 100).toInt(),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.accentTeal,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Expanded(
                  flex: 100 - (percentage * 100).toInt(),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.softGray.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(percentage * 100).toInt()}%',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
