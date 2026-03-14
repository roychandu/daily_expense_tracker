import 'package:shared_preferences/shared_preferences.dart';

class AppFlowService {
  final SharedPreferences prefs;
  static const String _firstLaunchKey = 'is_first_launch';
  static const String _referralCodeKey = 'referral_code';
  static const String _hasSeenLoginPromptKey = 'has_seen_login_prompt';

  AppFlowService(this.prefs);

  /// Checks if it's the first time the app is launched.
  bool get isFirstLaunch => prefs.getBool(_firstLaunchKey) ?? true;

  /// Sets first launch as complete.
  Future<void> setFirstLaunchComplete() async {
    await prefs.setBool(_firstLaunchKey, false);
  }

  /// Checks if the user has already seen the login prompt.
  bool get hasSeenLoginPrompt => prefs.getBool(_hasSeenLoginPromptKey) ?? false;

  /// Sets that the user has seen the login prompt.
  Future<void> setHasSeenLoginPrompt() async {
    await prefs.setBool(_hasSeenLoginPromptKey, true);
  }

  /// Checks if the app was installed via a referral link (simulated).
  /// In a real app, this would integrate with firebase_dynamic_links or similar.
  String? getReferralCode() {
    // For simulation, we can check if a specific flag exists or just return null for now.
    // The user mentioned "if user download and install the app via a link".
    return prefs.getString(_referralCodeKey);
  }

  /// Saves a referral code (simulated detection).
  Future<void> saveReferralCode(String code) async {
    await prefs.setString(_referralCodeKey, code);
  }

  /// Clears referral code after use.
  Future<void> clearReferralCode() async {
    await prefs.remove(_referralCodeKey);
  }

  /// Validates a referral code.
  bool validateReferralCode(String code) {
    // Correct code is "ABC123" as per design
    return code.trim().toUpperCase() == 'ABC123';
  }
}
