import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../controllers/settings_controller.dart';
import '../../common_widgets/custom_snackbar.dart';
import '../../services/ad_service.dart';
import '../settings/privacy_screen.dart';
import 'premium_unlocked_screen.dart';
import 'package:daily_expense_tracker/l10n/app_localizations.dart';

class UnlockPremiumScreen extends StatelessWidget {
  const UnlockPremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    if (settings.isPremium) {
      return const PremiumUnlockedScreen();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? AppColors.textDark : AppColors.charcoal,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.unlockPremium,
          style: AppTextStyles.h2Section.copyWith(
            color: isDark ? AppColors.textDark : AppColors.charcoal,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildPremiumCard(context, isDark),
              const SizedBox(height: 40),
              _buildFooter(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumCard(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2418) : const Color(0xFFFFFDE7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.primarySelected : const Color(0xFFFFD54F),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.diamond,
                color: Colors.lightBlueAccent,
                size: 30,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.premium,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: isDark ? AppColors.textDark : AppColors.deepBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '\$3.99',
            style: AppTextStyles.h1Display.copyWith(
              fontSize: 56,
              color: isDark ? AppColors.textDark : AppColors.deepBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.oneTimePayment,
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.noSubscriptionEver,
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          _buildFeatureRow(AppLocalizations.of(context)!.removeAdsForever, isDark),
          _buildFeatureRow(AppLocalizations.of(context)!.unlockAllInsights, isDark),
          _buildFeatureRow(AppLocalizations.of(context)!.unlimitedExports, isDark),
          _buildFeatureRow(AppLocalizations.of(context)!.advancedAnalytics, isDark),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              await context.read<SettingsController>().updatePremium(true);
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PremiumUnlockedScreen(),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primarySelected,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.unlockPremiumPrice,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: isDark ? Colors.white24 : Colors.grey[300],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  AppLocalizations.of(context)!.or,
                  style: AppTextStyles.body.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.charcoal,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: isDark ? Colors.white24 : Colors.grey[300],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              AdService().showRewardedAd(
                onRewardEarned: () async {
                  await context
                      .read<SettingsController>()
                      .unlockInsightsViaAd();
                  if (context.mounted) {
                    showCustomSnackBar(
                      context,
                      AppLocalizations.of(context)!.insightsUnlockedSnackbar,
                    );
                    Navigator.pop(context);
                  }
                },
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: AppColors.primarySelected,
                width: 2,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: isDark ? AppColors.white : AppColors.charcoal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size.fromHeight(56),
            ),
            child: Text(
              AppLocalizations.of(context)!.watchAd24h,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyLarge.copyWith(
                color: isDark ? AppColors.textDark : AppColors.charcoal,
                fontWeight: FontWeight.w500,
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
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacyScreen(),
                        ),
                      );
                    },
                ),
                TextSpan(text: ' ${AppLocalizations.of(context)!.or} '),
                TextSpan(
                  text: AppLocalizations.of(context)!.privacyPolicy,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: isDark ? AppColors.textDark : AppColors.charcoal,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacyScreen(),
                        ),
                      );
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
