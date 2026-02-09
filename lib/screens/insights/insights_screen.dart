import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_card.dart';
import '../../controllers/expense_controller.dart';
import '../../l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../controllers/settings_controller.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsController>();
    final expenseController = context.watch<ExpenseController>();

    if (expenseController.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final all = expenseController.expenses;

    // Calculate Streak
    final Set<String> loggedDates = all
        .map((e) => DateFormat('yyyy-MM-dd').format(e.date))
        .toSet();

    int streak = 0;
    DateTime checkDate = DateTime.now();
    while (loggedDates.contains(DateFormat('yyyy-MM-dd').format(checkDate))) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    // Weekly Activity (Current Week)
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    List<Map<String, dynamic>> weeklyActivity = [];
    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      final label = DateFormat.E(settings.locale.toString()).format(date)[0];
      weeklyActivity.add({
        'label': label,
        'isLogged': loggedDates.contains(DateFormat('yyyy-MM-dd').format(date)),
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.insights)),
      body: RefreshIndicator(
        onRefresh: () => expenseController.refreshExpenses(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Logging Streak
              CustomCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      l10n.loggingStreak,
                      style: AppTextStyles.h2Section.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '🔥 $streak ${streak == 1 ? l10n.day : l10n.days}',
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
                      streak > 0 ? l10n.keepItGoing : l10n.startLoggingToday,
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
                            color: AppColors.softGray.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: (streak / 30).clamp(0.01, 1.0),
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
                        Text('$streak', style: AppTextStyles.caption),
                        const Text('30', style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Weekly Activity
              Text(
                l10n.weeklyActivity,
                style: AppTextStyles.h2Section.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 12),
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: weeklyActivity.map((day) {
                          return _DayCircle(
                            label: day['label'],
                            isLogged: day['isLogged'],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${weeklyActivity.where((e) => e['isLogged'] as bool).length} ${l10n.daysLogged}',
                        style: AppTextStyles.body,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Insights
              Text(
                l10n.insights.toUpperCase(),
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
                        streak > 5 ? l10n.consistentInsight : l10n.startInsight,
                        style: AppTextStyles.body,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
                : Border.all(color: AppColors.softGray.withValues(alpha: 0.5)),
          ),
          child: isLogged
              ? const Icon(Icons.check, color: Colors.white, size: 20)
              : null,
        ),
      ],
    );
  }
}
