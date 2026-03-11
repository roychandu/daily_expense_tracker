import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/primary_button.dart';
import 'package:daily_expense_tracker/l10n/app_localizations.dart';

class InvitePremiumUnlockScreen extends StatelessWidget {
  const InvitePremiumUnlockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close,
              color: isDark ? AppColors.textDark : AppColors.deepBlue,
            ),
            label: Text(
              AppLocalizations.of(context)!.close,
              style: AppTextStyles.h3Title.copyWith(
                color: isDark ? AppColors.textDark : AppColors.deepBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Party Popper Icon
              Center(
                child: Image.asset(
                  'assets/icons/invite-premium-icon.png',
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              // Success Text
              Text(
                AppLocalizations.of(context)!.woohoo,
                style: AppTextStyles.h1Display.copyWith(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColors.textDark : AppColors.deepBlue,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.friendJoined,
                style: AppTextStyles.h1Display.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColors.textDark : AppColors.deepBlue,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.referralSuccessDesc('Sarah'),
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.softGray,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 38),
              // Activation Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFD700), Color(0xFFF97316)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  margin: const EdgeInsets.all(1.0), // 1px border
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isDark
                          ? [const Color(0xFFF97316), const Color(0xFF2A2A2A)]
                          : [const Color(0xFFFFFDE7), const Color(0xFFFFF9C4)],
                    ),
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: Column(
                    children: [
                      _buildBenefitItem(
                        Icons.check_circle,
                        AppLocalizations.of(context)!.premiumActivated,
                        isDark,
                      ),
                      const SizedBox(height: 16),
                      _buildBenefitItem(
                        Icons.check_circle,
                        AppLocalizations.of(context)!.validFor15Days,
                        isDark,
                      ),
                      const SizedBox(height: 16),
                      _buildBenefitItem(
                        Icons.check_circle,
                        AppLocalizations.of(context)!.allFeaturesUnlocked,
                        isDark,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),
              // Actions
              PrimaryButton(
                title: AppLocalizations.of(context)!.explorePremiumFeatures,
                onPressed: () {
                  // Navigate to features or close
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  // TODO: Implement invitation logic
                },
                child: Text(
                  AppLocalizations.of(context)!.inviteMoreFriends,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.primarySelected,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Status footer
              Text(
                AppLocalizations.of(context)!.invitesStatus(2, 1),
                style: AppTextStyles.labelSmall.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.softGray,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark 
                ? Colors.white.withValues(alpha: 0.2) 
                : const Color(0xFFA5D6A7).withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon, 
            size: 20, 
            color: isDark ? Colors.white : AppColors.successGreen,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          text,
          style: AppTextStyles.bodyLarge.copyWith(
            color: isDark ? AppColors.textDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
