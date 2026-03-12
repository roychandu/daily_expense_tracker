import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import '../services/app_config_service.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._prefs) {
    _configService = AppConfigService(_prefs);
    _loadSettings();
  }

  final SharedPreferences _prefs;
  late final AppConfigService _configService;

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');
  String _currency = 'USD';
  bool _isDailyReminderEnabled = true;
  DateTime _reminderTime = DateTime(2024, 1, 1, 20, 0); // Default 8:00 PM
  bool _isCloudBackupEnabled = false;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  String get currency => _currency;
  bool get isDailyReminderEnabled => _isDailyReminderEnabled;
  DateTime get reminderTime => _reminderTime;
  bool get isCloudBackupEnabled => _isCloudBackupEnabled;

  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'de', 'name': 'German'},
    {'code': 'pt', 'name': 'Portuguese'},
    {'code': 'hi', 'name': 'Hindi'},
    {'code': 'ar', 'name': 'Arabic'},
    {'code': 'zh', 'name': 'Mandarin Chinese'},
  ];

  static const List<Map<String, String>> supportedCurrencies = [
    {'code': 'USD', 'symbol': r'$', 'name': 'US Dollar'},
    {'code': 'EUR', 'symbol': '€', 'name': 'Euro'},
    {'code': 'GBP', 'symbol': '£', 'name': 'British Pound'},
    {'code': 'INR', 'symbol': '₹', 'name': 'Indian Rupee'},
    {'code': 'JPY', 'symbol': '¥', 'name': 'Japanese Yen'},
    {'code': 'CNY', 'symbol': '¥', 'name': 'Chinese Yuan'},
    {'code': 'BRL', 'symbol': r'R$', 'name': 'Brazilian Real'},
    {'code': 'RUB', 'symbol': '₽', 'name': 'Russian Ruble'},
    {'code': 'KRW', 'symbol': '₩', 'name': 'South Korean Won'},
    {'code': 'MXN', 'symbol': r'$', 'name': 'Mexican Peso'},
    {'code': 'AUD', 'symbol': r'$', 'name': 'Australian Dollar'},
    {'code': 'CAD', 'symbol': r'$', 'name': 'Canadian Dollar'},
    {'code': 'CHF', 'symbol': 'Fr.', 'name': 'Swiss Franc'},
    {'code': 'SEK', 'symbol': 'kr', 'name': 'Swedish Krona'},
    {'code': 'NOK', 'symbol': 'kr', 'name': 'Norwegian Krone'},
    {'code': 'DKK', 'symbol': 'kr', 'name': 'Danish Krone'},
    {'code': 'PLN', 'symbol': 'zł', 'name': 'Polish Zloty'},
    {'code': 'THB', 'symbol': '฿', 'name': 'Thai Baht'},
    {'code': 'IDR', 'symbol': 'Rp', 'name': 'Indonesian Rupiah'},
    {'code': 'TRY', 'symbol': '₺', 'name': 'Turkish Lira'},
  ];

  bool get isPremium => _configService.isPremium;

  bool get isInsightsUnlockedViaAd => _configService.isAdAccessActive;

  int get remainingAdAccessSeconds => _configService.remainingAdAccessSeconds;

  void _loadSettings() {
    final themeIndex = _prefs.getInt('themeMode') ?? 0;
    _themeMode = ThemeMode.values[themeIndex];

    final languageCode = _prefs.getString('languageCode') ?? 'en';
    _locale = Locale(languageCode);

    _currency = _prefs.getString('currency') ?? 'USD';
    _isDailyReminderEnabled = _prefs.getBool('isDailyReminderEnabled') ?? true;
    _isCloudBackupEnabled = _prefs.getBool('isCloudBackupEnabled') ?? false;

    final timeStr = _prefs.getString('reminderTime') ?? "20:00";
    final parts = timeStr.split(':');
    _reminderTime = DateTime(
      2024,
      1,
      1,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    // Auto-schedule if enabled
    if (_isDailyReminderEnabled) {
      NotificationService().scheduleDailyReminder(
        hour: _reminderTime.hour,
        minute: _reminderTime.minute,
      );
    }

    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await _prefs.setInt('themeMode', mode.index);
  }

  Future<void> updateLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    await _prefs.setString('languageCode', locale.languageCode);
  }

  Future<void> updateCurrency(String currency) async {
    if (_currency == currency) return;
    _currency = currency;
    notifyListeners();
    await _prefs.setString('currency', currency);
  }

  Future<void> updateDailyReminder(
    bool enabled, {
    String? title,
    String? body,
  }) async {
    _isDailyReminderEnabled = enabled;
    notifyListeners();
    await _prefs.setBool('isDailyReminderEnabled', enabled);

    if (enabled) {
      await NotificationService().scheduleDailyReminder(
        hour: _reminderTime.hour,
        minute: _reminderTime.minute,
        title: title,
        body: body,
      );
      // Give immediate feedback to verify it works
      await NotificationService().showInstantNotification(
        title: title ?? "Notification Test",
        body: "Daily reminders enabled successfully! 🔔",
      );
    } else {
      await NotificationService().cancelAllNotifications();
    }
  }

  Future<void> updateReminderTime(
    DateTime time, {
    String? title,
    String? body,
  }) async {
    _reminderTime = time;
    notifyListeners();
    await _prefs.setString(
      'reminderTime',
      "${time.hour}:${time.minute.toString().padLeft(2, '0')}",
    );

    if (_isDailyReminderEnabled) {
      await NotificationService().scheduleDailyReminder(
        hour: time.hour,
        minute: time.minute,
        title: title,
        body: body,
      );
    }
  }

  Future<void> rescheduleReminder({
    required String title,
    required String body,
  }) async {
    if (_isDailyReminderEnabled) {
      await NotificationService().scheduleDailyReminder(
        hour: _reminderTime.hour,
        minute: _reminderTime.minute,
        title: title,
        body: body,
      );
    }
  }

  Future<void> updatePremium(bool isPremium) async {
    await _configService.setPremium(isPremium);
    notifyListeners();
  }

  Future<void> unlockInsightsViaAd() async {
    await _configService.activateAdAccess();
    notifyListeners();
  }

  Future<void> updateCloudBackup(bool enabled) async {
    _isCloudBackupEnabled = enabled;
    notifyListeners();
    await _prefs.setBool('isCloudBackupEnabled', enabled);
  }

  // Referral / Invite System
  int get invitedFriendsCount => _configService.invitedFriendsCount;
  int get earnedPremiumDays => _configService.earnedPremiumDays;
  String get referralExpiryDate => _configService.referralExpiryDate ?? 'None';

  Future<void> simulateFriendJoined() async {
    final count = invitedFriendsCount + 1;
    await _configService.setInvitedFriendsCount(count);

    // Each friend adds 15 days
    final additionalDays = 15;
    await _configService.setEarnedPremiumDays(
      earnedPremiumDays + additionalDays,
    );

    // Update expiry date (mock: 30 days from now)
    final expiry = DateTime.now().add(const Duration(days: 30));
    await _configService.setReferralExpiryDate(
      "${expiry.day} ${_getMonthName(expiry.month)} ${expiry.year}",
    );

    // Unlock premium if not already
    await updatePremium(true);

    notifyListeners();
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
