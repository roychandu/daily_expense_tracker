import 'package:intl/intl.dart';

class StreakUtils {
  static const bool isTesting = false;
  static const int testingIntervalMinutes = 2;

  static String getStreakKey(DateTime date) {
    if (isTesting) {
      // Key represents a specific 2-minute interval since epoch
      final intervals =
          date.millisecondsSinceEpoch ~/ (testingIntervalMinutes * 60 * 1000);
      return intervals.toString();
    }
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static Duration getStep() {
    if (isTesting) {
      return const Duration(minutes: testingIntervalMinutes);
    }
    return const Duration(days: 1);
  }

  // Helper to get difference in units (days or 2-min intervals)
  static int getDifference(DateTime a, DateTime b) {
    if (isTesting) {
      final aInt =
          a.millisecondsSinceEpoch ~/ (testingIntervalMinutes * 60 * 1000);
      final bInt =
          b.millisecondsSinceEpoch ~/ (testingIntervalMinutes * 60 * 1000);
      return (aInt - bInt).abs();
    }
    // For days, we need to compare calendar days, not just 24h difference
    final aDate = DateTime(a.year, a.month, a.day);
    final bDate = DateTime(b.year, b.month, b.day);
    return aDate.difference(bDate).inDays.abs();
  }

  static int calculateCurrentStreak(List<DateTime> allDates) {
    if (allDates.isEmpty) return 0;

    final now = DateTime.now();
    final loggedKeys = allDates.map((d) => getStreakKey(d)).toSet();

    final currentKey = getStreakKey(now);
    final prevKey = getStreakKey(now.subtract(getStep()));

    bool hasToday = loggedKeys.contains(currentKey);
    bool hasYesterday = loggedKeys.contains(prevKey);

    // If neither today nor yesterday (last interval) has an entry, streak is broken
    if (!hasToday && !hasYesterday) return 0;

    int streak = 0;
    // Start counting from current interval if it has an entry, otherwise start from previous
    DateTime checkDate = hasToday ? now : now.subtract(getStep());

    while (loggedKeys.contains(getStreakKey(checkDate))) {
      streak++;
      checkDate = checkDate.subtract(getStep());
    }
    return streak;
  }
}
