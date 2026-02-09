import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._prefs) {
    _loadSettings();
  }

  final SharedPreferences _prefs;

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');
  String _currency = 'USD';
  bool _isDailyReminderEnabled = true;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  String get currency => _currency;
  bool get isDailyReminderEnabled => _isDailyReminderEnabled;

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

  void _loadSettings() {
    final themeIndex = _prefs.getInt('themeMode') ?? 0;
    _themeMode = ThemeMode.values[themeIndex];

    final languageCode = _prefs.getString('languageCode') ?? 'en';
    _locale = Locale(languageCode);

    _currency = _prefs.getString('currency') ?? 'USD';
    _isDailyReminderEnabled = _prefs.getBool('isDailyReminderEnabled') ?? true;

    // Auto-schedule if enabled
    if (_isDailyReminderEnabled) {
      NotificationService().scheduleDailyReminder();
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
        title: title,
        body: body,
      );
    } else {
      await NotificationService().cancelAllNotifications();
    }
  }

  Future<void> rescheduleReminder({
    required String title,
    required String body,
  }) async {
    if (_isDailyReminderEnabled) {
      await NotificationService().scheduleDailyReminder(
        title: title,
        body: body,
      );
    }
  }
}
