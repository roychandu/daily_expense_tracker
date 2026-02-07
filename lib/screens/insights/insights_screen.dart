import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_card.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Logging Streak
            CustomCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '🔥 LOGGING STREAK',
                    style: AppTextStyles.h2Section.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '🔥 12 Days',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textDark
                          : AppColors.primaryDeepBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Keep it going!',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.accentTeal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.softGray.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: 0.4, // 12/30
                          child: Container(
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppColors.accentTeal,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('12', style: AppTextStyles.caption),
                      Text('30', style: AppTextStyles.caption),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Weekly Activity
            Text(
              'WEEKLY ACTIVITY',
              style: AppTextStyles.h2Section.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _DayCircle(label: 'M', isLogged: true),
                      _DayCircle(label: 'T', isLogged: true),
                      _DayCircle(label: 'W', isLogged: true),
                      _DayCircle(label: 'T', isLogged: false),
                      _DayCircle(label: 'F', isLogged: true),
                      _DayCircle(label: 'S', isLogged: true),
                      _DayCircle(label: 'S', isLogged: true),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('6 of 7 days logged', style: AppTextStyles.body),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Insights
            Text(
              'INSIGHTS',
              style: AppTextStyles.h2Section.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 12),
            CustomCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb, color: Colors.orange, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "You're spending 15% more on weekends than weekdays",
                      style: AppTextStyles.body,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayCircle extends StatelessWidget {
  final String label;
  final bool isLogged;

  const _DayCircle({required this.label, required this.isLogged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isLogged ? AppColors.accentTeal : Colors.transparent,
            shape: BoxShape.circle,
            border: isLogged
                ? null
                : Border.all(color: AppColors.softGray.withOpacity(0.5)),
          ),
          child: isLogged
              ? const Icon(Icons.check, color: Colors.white, size: 20)
              : null,
        ),
      ],
    );
  }
}
