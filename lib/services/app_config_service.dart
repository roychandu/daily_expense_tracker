import 'package:shared_preferences/shared_preferences.dart';

class AppConfigService {
  static const String _isPremiumKey = 'isPremium';
  static const String _adUnlockTimeKey = 'adUnlockTime';

  final SharedPreferences _prefs;

  AppConfigService(this._prefs);

  bool get isPremium => _prefs.getBool(_isPremiumKey) ?? false;

  Future<void> setPremium(bool value) async {
    await _prefs.setBool(_isPremiumKey, value);
  }

  bool get isAdAccessActive {
    final unlockTimeStr = _prefs.getString(_adUnlockTimeKey);
    if (unlockTimeStr == null) return false;
    try {
      final unlockTime = DateTime.parse(unlockTimeStr);
      // Ad access lasts for 2 minutes (Testing)
      return DateTime.now().difference(unlockTime).inMinutes < 2;
    } catch (e) {
      return false;
    }
  }

  Future<void> activateAdAccess() async {
    await _prefs.setString(_adUnlockTimeKey, DateTime.now().toIso8601String());
  }

  int get remainingAdAccessSeconds {
    final unlockTimeStr = _prefs.getString(_adUnlockTimeKey);
    if (unlockTimeStr == null) return 0;
    try {
      final unlockTime = DateTime.parse(unlockTimeStr);
      final diffSeconds = 120 - DateTime.now().difference(unlockTime).inSeconds;
      return diffSeconds > 0 ? diffSeconds : 0;
    } catch (e) {
      return 0;
    }
  }
}
