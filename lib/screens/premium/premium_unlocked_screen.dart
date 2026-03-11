import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_app_bar.dart';
import 'package:daily_expense_tracker/l10n/app_localizations.dart';

class PremiumUnlockedScreen extends StatefulWidget {
  const PremiumUnlockedScreen({super.key});

  @override
  State<PremiumUnlockedScreen> createState() => _PremiumUnlockedScreenState();
}

class _PremiumUnlockedScreenState extends State<PremiumUnlockedScreen> {
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final newOpacity = (offset / 50).clamp(0.0, 1.0);
    if (newOpacity != _appBarOpacity) {
      if (!mounted) return;
      setState(() {
        _appBarOpacity = newOpacity;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.premiumUnlocked,
        scrollOpacity: _appBarOpacity,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Premium Icon
              Center(
                child: Image.asset(
                  isDark
                      ? 'assets/icons/premium_icon-darkmode.png'
                      : 'assets/icons/premium_icon-lightmode.png',
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              // Welcome Text
              Text(
                AppLocalizations.of(context)!.welcomeToPremium,
                textAlign: TextAlign.center,
                style: AppTextStyles.h1Display.copyWith(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColors.textDark : AppColors.deepBlue,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.upgradeActive,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.orange[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              // Features Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2C2418)
                      : const Color(0xFFFFFDE7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? AppColors.primarySelected
                        : const Color(0xFFFFD54F),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    _buildFeatureItem(AppLocalizations.of(context)!.allAdsRemoved, isDark),
                    _buildFeatureItem(AppLocalizations.of(context)!.allInsightsUnlocked, isDark),
                    _buildFeatureItem(AppLocalizations.of(context)!.unlimitedExportsActivated, isDark),
                    _buildFeatureItem(AppLocalizations.of(context)!.premiumFeaturesReady, isDark),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Explore Button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primarySelected,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size.fromHeight(60),
                  elevation: 4,
                ),
                child: Text(
                  AppLocalizations.of(context)!.explorePremiumFeatures,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 32),
              // Footer
              _buildFooter(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFFA5D6A7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              size: 16,
              color: AppColors.successGreen,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyLarge.copyWith(
                color: isDark ? AppColors.textDark : AppColors.charcoal,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.bodySmall.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
              children: [
                TextSpan(text: AppLocalizations.of(context)!.byPurchasingAgree),
                TextSpan(
                  text: AppLocalizations.of(context)!.termsOfService,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: isDark ? AppColors.textDark : AppColors.charcoal,
                  ),
                ),
                TextSpan(text: ' ${AppLocalizations.of(context)!.or} '),
                TextSpan(
                  text: AppLocalizations.of(context)!.privacyPolicy,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: isDark ? AppColors.textDark : AppColors.charcoal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
