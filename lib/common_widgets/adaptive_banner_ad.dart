import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../controllers/settings_controller.dart';
import '../services/ad_service.dart';

class AdaptiveBannerAd extends StatefulWidget {
  const AdaptiveBannerAd({super.key});

  @override
  State<AdaptiveBannerAd> createState() => _AdaptiveBannerAdState();
}

class _AdaptiveBannerAdState extends State<AdaptiveBannerAd> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isLoading = false;
  int? _lastWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  Future<void> _loadAd() async {
    // Only load if not premium and no active ad-unlock
    final settings = context.read<SettingsController>();
    if (settings.isPremium || settings.isInsightsUnlockedViaAd) return;

    final width = MediaQuery.sizeOf(context).width.toInt();

    // Prevent multiple loads or reloading if width hasn't changed
    if (_isLoading || (_isLoaded && _lastWidth == width)) return;

    _isLoading = true;
    _lastWidth = width;

    final AdSize? adSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);

    if (adSize == null) {
      _isLoading = false;
      return;
    }

    // Dispose old ad before creating new one
    _bannerAd?.dispose();

    _bannerAd = BannerAd(
      adUnitId: AdService().bannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
            _isLoading = false;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('AdService: Banner failed to load: $error');
          if (mounted) {
            setState(() {
              _isLoading = false;
              _isLoaded = false;
            });
          }
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We watch settings to know when to show/hide based on premium/ad-unlock status
    final settings = context.watch<SettingsController>();
    final isPremium = settings.isPremium;
    final isAdUnlocked = settings.isInsightsUnlockedViaAd;

    // Premium or Ad-unlocked users should see nothing
    if (isPremium || isAdUnlocked) {
      return const SizedBox.shrink();
    }

    // If ad is not loaded yet, show a placeholder to reserve space and look immediate
    if (!_isLoaded || _bannerAd == null) {
      return Container(
        height: 60, // Standard approximate banner height
        alignment: Alignment.center,
        child: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey),
        ),
      );
    }

    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
