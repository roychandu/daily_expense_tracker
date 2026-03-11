import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  RewardedAd? _rewardedAd;
  bool _isRewardedAdLoading = false;
  int _retryCount = 0;

  // Test Ad Unit IDs - These are safe to use for development and work on both real devices and emulators.
  static const String androidRewardedTestId =
      'ca-app-pub-3940256099942544/5224354917';
  static const String iosRewardedTestId =
      'ca-app-pub-3940256099942544/1712485313';
  static const String androidBannerTestId =
      'ca-app-pub-3940256099942544/9214589741';
  static const String iosBannerTestId =
      'ca-app-pub-3940256099942544/2934735716';

  String get rewardedAdUnitId =>
      Platform.isAndroid ? androidRewardedTestId : iosRewardedTestId;
  String get bannerAdUnitId =>
      Platform.isAndroid ? androidBannerTestId : iosBannerTestId;

  bool get isAdLoaded => _rewardedAd != null;
  bool get isAdLoading => _isRewardedAdLoading;

  Future<void> init() async {
    await MobileAds.instance.initialize();
    // Register as test device (Optional but helpful for real hardware)
    // On real devices, check logs for "To get test ads on this device, call:..."
    // to get the actual ID if needed, but sample IDs usually work out-of-box.
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: []),
    );
    loadRewardedAd();
  }

  void loadRewardedAd() {
    if (_isRewardedAdLoading || _rewardedAd != null) return;
    _isRewardedAdLoading = true;

    debugPrint('AdService: Loading RewardedAd ($rewardedAdUnitId)...');

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AdService: RewardedAd loaded successfully.');
          _rewardedAd = ad;
          _isRewardedAdLoading = false;
          _retryCount = 0;
        },
        onAdFailedToLoad: (error) {
          debugPrint('AdService: RewardedAd failed to load: $error');
          _rewardedAd = null;
          _isRewardedAdLoading = false;

          // Retry logic (max 3 times)
          if (_retryCount < 3) {
            _retryCount++;
            Future.delayed(
              Duration(seconds: _retryCount * 2),
              () => loadRewardedAd(),
            );
          }
        },
      ),
    );
  }

  void showRewardedAd({
    required Function() onRewardEarned,
    Function(String)? onAdFailed,
    Function()? onAdDismissed,
  }) {
    if (_rewardedAd == null) {
      debugPrint('AdService: Ad not ready.');
      loadRewardedAd();
      if (onAdFailed != null) {
        onAdFailed('Ad is still loading, please try again in a moment.');
      } else {
        // Fallback for development: if ad not ready, just reward so workflow isn't blocked.
        // On real devices with internet, it will load eventually.
        onRewardEarned();
      }
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => debugPrint('AdService: Ad showed.'),
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('AdService: Ad dismissed.');
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
        if (onAdDismissed != null) onAdDismissed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('AdService: Ad failed to show: $error.');
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
        // Fallback: Reward the user anyway if the ad failed to show after loading
        onRewardEarned();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        debugPrint('AdService: User earned reward.');
        onRewardEarned();
      },
    );
  }
}
