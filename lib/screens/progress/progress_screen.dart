import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../controllers/expense_controller.dart';
import '../../l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../utils/app_layout.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final expenseController = context.watch<ExpenseController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (expenseController.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final allExpenses = expenseController.expenses;
    final now = DateTime.now();

    // 1. Calculate Streaks and Logged Dates
    final Set<String> loggedDates = allExpenses
        .map((e) => DateFormat('yyyy-MM-dd').format(e.date))
        .toSet();

    // Current Streak
    int currentStreak = 0;
    DateTime checkDate = now;
    while (loggedDates.contains(DateFormat('yyyy-MM-dd').format(checkDate))) {
      currentStreak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    // Longest Streak Calculation
    int longestStreak = 0;
    if (loggedDates.isNotEmpty) {
      List<DateTime> sortedDates =
          loggedDates.map((d) => DateTime.parse(d)).toList()..sort();

      int tempStreak = 1;
      longestStreak = 1;
      for (int i = 0; i < sortedDates.length - 1; i++) {
        if (sortedDates[i + 1].difference(sortedDates[i]).inDays == 1) {
          tempStreak++;
          if (tempStreak > longestStreak) longestStreak = tempStreak;
        } else {
          tempStreak = 1;
        }
      }
    }

    // Total Days Logged
    int totalLoggedDays = loggedDates.length;

    // Accuracy Calculation (Since first log)
    double accuracy = 0;
    if (loggedDates.isNotEmpty) {
      final firstLog = loggedDates
          .map((d) => DateTime.parse(d))
          .reduce((a, b) => a.isBefore(b) ? a : b);
      final daysSinceStart = now.difference(firstLog).inDays + 1;
      accuracy = (totalLoggedDays / daysSinceStart) * 100;
    }

    // 2. Next Milestone Logic
    const thresholds = [3, 7, 15, 30, 60, 90, 180, 365];
    final nextMilestone = thresholds.firstWhere(
      (t) => t > currentStreak,
      orElse: () => thresholds.last,
    );
    final daysToNext = nextMilestone - currentStreak;
    final milestoneLabel = _getMilestoneLabel(nextMilestone);

    // 3. Weekly Activity (Current Week - Sun to Sat for chart)
    // But image shows MON TUE WED THU FRI SAT SUN
    final startOfWeek = now.subtract(Duration(days: (now.weekday - 1)));
    List<Map<String, dynamic>> weeklyActivity = [];
    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      weeklyActivity.add({
        'day': DateFormat('E').format(date).toUpperCase(),
        'isLogged': loggedDates.contains(dateStr),
        'isToday': dateStr == DateFormat('yyyy-MM-dd').format(now),
      });
    }

    // 4. Monthly Heatmap (Current Month)
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    List<int> heatmapIntensities = []; // 0 to 4 based on count

    final dayStats = <String, int>{};
    for (var e in allExpenses) {
      if (e.date.month == now.month && e.date.year == now.year) {
        final dateStr = DateFormat('yyyy-MM-dd').format(e.date);
        dayStats[dateStr] = (dayStats[dateStr] ?? 0) + 1;
      }
    }

    for (int i = 0; i < lastDayOfMonth.day; i++) {
      final date = firstDayOfMonth.add(Duration(days: i));
      final count = dayStats[DateFormat('yyyy-MM-dd').format(date)] ?? 0;
      if (count == 0)
        heatmapIntensities.add(0);
      else if (count < 3)
        heatmapIntensities.add(1);
      else if (count < 6)
        heatmapIntensities.add(2);
      else if (count < 10)
        heatmapIntensities.add(3);
      else
        heatmapIntensities.add(4);
    }

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Progress',
          style: AppTextStyles.h1Display.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 28,
            fontFamily: 'Serif',
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppLayout.horizontalPadding(context),
          vertical: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Streak Card
            _MainStreakCard(
              currentStreak: currentStreak,
              nextMilestone: nextMilestone,
              daysToNext: daysToNext,
              milestoneLabel: milestoneLabel,
            ),

            const SizedBox(height: 32),

            // Weekly Activity
            Text(
              l10n.weeklyActivity,
              style: AppTextStyles.h2Section.copyWith(
                fontSize: 20,
                fontFamily: 'Serif',
              ),
            ),
            const SizedBox(height: 16),
            _WeeklyActivityBar(activity: weeklyActivity),

            const SizedBox(height: 32),

            // Monthly Activity
            Text(
              'Monthly Activity',
              style: AppTextStyles.h2Section.copyWith(
                fontSize: 20,
                fontFamily: 'Serif',
              ),
            ),
            const SizedBox(height: 16),
            _MonthlyHeatmap(
              intensities: heatmapIntensities,
              longestStreak: longestStreak,
              totalDays: totalLoggedDays,
              accuracy: accuracy,
            ),

            const SizedBox(height: 40),

            // Achievements
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Achievements',
                  style: AppTextStyles.h2Section.copyWith(
                    fontSize: 20,
                    fontFamily: 'Serif',
                  ),
                ),
                Text(
                  l10n.viewAllHistory.toUpperCase(),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primarySelected,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _AchievementsGrid(
              currentStreak: longestStreak,
            ), // Use longest streak for achievements
          ],
        ),
      ),
    );
  }

  String _getMilestoneLabel(int threshold) {
    switch (threshold) {
      case 3:
        return 'stone badge';
      case 7:
        return 'iron badge';
      case 15:
        return 'bronze badge';
      case 30:
        return 'silver badge';
      case 60:
        return 'gold badge';
      case 90:
        return 'platinum badge';
      case 180:
        return 'titanium badge';
      case 365:
        return 'diamond badge';
      default:
        return 'next milestone';
    }
  }
}

class _MainStreakCard extends StatelessWidget {
  final int currentStreak;
  final int nextMilestone;
  final int daysToNext;
  final String milestoneLabel;

  const _MainStreakCard({
    required this.currentStreak,
    required this.nextMilestone,
    required this.daysToNext,
    required this.milestoneLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentBadgeAsset = _getBadgeAsset(currentStreak);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black45
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Image.asset('assets/progress-icons/$currentBadgeAsset', height: 100),
          const SizedBox(height: 16),
          Text(
            '$currentStreak DAYS STREAK',
            style: AppTextStyles.h2Section.copyWith(
              fontSize: 22,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3D2C1E) : const Color(0xFFFFF5ED),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STREAK PROGRESS',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white38 : Colors.black38,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${currentStreak % nextMilestone}/${nextMilestone} Days to next milestone',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.black12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: (currentStreak / nextMilestone).clamp(
                        0.01,
                        1.0,
                      ),
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.primarySelected,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  daysToNext > 0
                      ? 'You are $daysToNext days away from a $milestoneLabel!'
                      : 'Milestone reached! Log tomorrow to stay ahead.',
                  style: AppTextStyles.caption.copyWith(
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getBadgeAsset(int streak) {
    if (streak >= 365) return 'diamond.png';
    if (streak >= 180) return 'titanium.png';
    if (streak >= 90) return 'platinum.png';
    if (streak >= 60) return 'gold.png';
    if (streak >= 30) return 'silver.png';
    if (streak >= 15) return 'bronze.png';
    if (streak >= 7) return 'iron.png';
    if (streak >= 3) return 'stone.png';
    return 'stone.png'; // Fallback
  }
}

class _WeeklyActivityBar extends StatelessWidget {
  final List<Map<String, dynamic>> activity;

  const _WeeklyActivityBar({required this.activity});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtitleColor = isDark ? Colors.white38 : Colors.black38;
    final borderColor = isDark ? Colors.white24 : Colors.black12;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black45
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: activity.map((day) {
          return Column(
            children: [
              Text(
                day['day'],
                style: AppTextStyles.caption.copyWith(
                  fontSize: 10,
                  color: subtitleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: day['isLogged']
                      ? AppColors.primarySelected
                      : Colors.transparent,
                  border: day['isLogged']
                      ? null
                      : Border.all(color: borderColor),
                  boxShadow: day['isLogged']
                      ? [
                          BoxShadow(
                            color: AppColors.primarySelected.withValues(
                              alpha: 0.7,
                            ),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: day['isLogged']
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : null,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MonthlyHeatmap extends StatelessWidget {
  final List<int> intensities;
  final int longestStreak;
  final int totalDays;
  final double accuracy;

  const _MonthlyHeatmap({
    required this.intensities,
    required this.longestStreak,
    required this.totalDays,
    required this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black45
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: Column(
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(intensities.length, (index) {
              return Container(
                width: (MediaQuery.of(context).size.width - 120) / 7,
                height: (MediaQuery.of(context).size.width - 120) / 7,
                decoration: BoxDecoration(
                  color: _getHeatmapColor(intensities[index], isDark),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: intensities[index] > 0
                      ? [
                          BoxShadow(
                            color: AppColors.primarySelected.withValues(
                              alpha: intensities[index] * 0.1,
                            ),
                            blurRadius: 4,
                          ),
                        ]
                      : null,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Usage Intensity',
                style: AppTextStyles.caption.copyWith(
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
              const Spacer(),
              Text(
                'Less ',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 10,
                  color: isDark ? Colors.white24 : Colors.black26,
                ),
              ),
              ...List.generate(
                4,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: _getHeatmapColor(index + 1, isDark),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                ' More',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 10,
                  color: isDark ? Colors.white24 : Colors.black26,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(
            color: isDark
                ? Colors.white10
                : Colors.black.withValues(alpha: 0.05),
            thickness: 1,
          ),
          const SizedBox(height: 16),
          _StatsRow(
            longestStreak: longestStreak,
            totalDays: totalDays,
            accuracy: accuracy,
          ),
        ],
      ),
    );
  }

  Color _getHeatmapColor(int intensity, bool isDark) {
    if (intensity == 0)
      return isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black12;
    switch (intensity) {
      case 1:
        return AppColors.primarySelected.withValues(alpha: 0.3);
      case 2:
        return AppColors.primarySelected.withValues(alpha: 0.5);
      case 3:
        return AppColors.primarySelected.withValues(alpha: 0.8);
      case 4:
        return AppColors.primarySelected;
      default:
        return AppColors.primarySelected;
    }
  }
}

class _StatsRow extends StatelessWidget {
  final int longestStreak;
  final int totalDays;
  final double accuracy;

  const _StatsRow({
    required this.longestStreak,
    required this.totalDays,
    required this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatItem(label: 'LONGEST STREAK', value: '$longestStreak Days'),
        _StatItem(label: 'TOTAL', value: '$totalDays Days'),
        _StatItem(label: 'ACCURACY', value: '${accuracy.toStringAsFixed(0)}%'),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? Colors.white38 : Colors.black38;

    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontSize: 10,
            color: labelColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            fontFamily: 'Serif',
          ),
        ),
      ],
    );
  }
}

class _AchievementsGrid extends StatelessWidget {
  final int currentStreak;

  const _AchievementsGrid({required this.currentStreak});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final achievements = [
      {'name': 'STONE', 'days': 3, 'asset': 'stone.png'},
      {'name': 'IRON', 'days': 7, 'asset': 'iron.png'},
      {'name': 'BRONZE', 'days': 15, 'asset': 'bronze.png'},
      {'name': 'SILVER', 'days': 30, 'asset': 'silver.png'},
      {'name': 'GOLD', 'days': 60, 'asset': 'gold.png'},
      {'name': 'PLATINUM', 'days': 90, 'asset': 'platinum.png'},
      {'name': 'TITANIUM', 'days': 180, 'asset': 'titanium.png'},
      {'name': 'DIAMOND', 'days': 365, 'asset': 'diamond.png'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 20,
        crossAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final ach = achievements[index];
        final isEarned = currentStreak >= (ach['days'] as int);

        return Column(
          children: [
            Opacity(
              opacity: isEarned ? 1.0 : 0.3,
              child: Image.asset(
                'assets/progress-icons/${ach['asset']}',
                height: 60,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              ach['name'].toString(),
              style: AppTextStyles.caption.copyWith(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: isEarned
                    ? (isDark ? Colors.white : Colors.black)
                    : (isDark ? Colors.white38 : Colors.black38),
              ),
            ),
            Text(
              '${ach['days']} DAYS',
              style: AppTextStyles.caption.copyWith(
                fontSize: 7,
                color: isEarned
                    ? (isDark ? Colors.white70 : Colors.black54)
                    : (isDark ? Colors.white24 : Colors.black26),
              ),
            ),
          ],
        );
      },
    );
  }
}
