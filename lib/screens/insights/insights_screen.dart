import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_card.dart';
import '../../services/database_service.dart';
import 'package:intl/intl.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  int _streakCount = 0;
  List<bool> _weeklyLogged = List.filled(7, false);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    setState(() => _isLoading = true);
    final all = await DatabaseService.instance.readAllExpenses();

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
    List<bool> weekly = [];
    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      weekly.add(loggedDates.contains(DateFormat('yyyy-MM-dd').format(date)));
    }

    setState(() {
      _streakCount = streak;
      _weeklyLogged = weekly;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadInsights,
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
                            '🔥 LOGGING STREAK',
                            style: AppTextStyles.h2Section.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '🔥 $_streakCount ${_streakCount == 1 ? 'Day' : 'Days'}',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.textDark
                                  : AppColors.primaryDeepBlue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _streakCount > 0
                                ? 'Keep it going!'
                                : 'Start logging today!',
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
                                  widthFactor: (_streakCount / 30).clamp(
                                    0.01,
                                    1.0,
                                  ),
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
                              Text(
                                '$_streakCount',
                                style: AppTextStyles.caption,
                              ),
                              const Text('30', style: AppTextStyles.caption),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _DayCircle(
                                  label: 'M',
                                  isLogged: _weeklyLogged[0],
                                ),
                                _DayCircle(
                                  label: 'T',
                                  isLogged: _weeklyLogged[1],
                                ),
                                _DayCircle(
                                  label: 'W',
                                  isLogged: _weeklyLogged[2],
                                ),
                                _DayCircle(
                                  label: 'T',
                                  isLogged: _weeklyLogged[3],
                                ),
                                _DayCircle(
                                  label: 'F',
                                  isLogged: _weeklyLogged[4],
                                ),
                                _DayCircle(
                                  label: 'S',
                                  isLogged: _weeklyLogged[5],
                                ),
                                _DayCircle(
                                  label: 'S',
                                  isLogged: _weeklyLogged[6],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${_weeklyLogged.where((e) => e).length} of 7 days logged',
                              style: AppTextStyles.body,
                            ),
                          ],
                        ),
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
                          const Icon(
                            Icons.lightbulb,
                            color: Colors.orange,
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              _streakCount > 5
                                  ? "You've been consistent! Keep tracking to see more trends."
                                  : "Log more frequently to unlock personal spending insights.",
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
