import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_app_bar.dart';
import 'package:daily_expense_tracker/l10n/app_localizations.dart';

class CloudBackupMethodScreen extends StatelessWidget {
  const CloudBackupMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.cloudBackup,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.chooseBackupMethod,
                style: AppTextStyles.h3Title.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textDark : AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 20),
              
              // Backup Methods
              _buildMethodCard(
                icon: Icons.g_mobiledata, // Will use a generic Google icon or letter if asset not specified, but usually it's better to use something close or keep it simple. User didn't provide icons for these specifically but the image shows them.
                title: AppLocalizations.of(context)!.signInWithGoogle,
                subtitle: AppLocalizations.of(context)!.recommendedForAndroid,
                onTap: () {},
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _buildMethodCard(
                icon: Icons.apple,
                title: AppLocalizations.of(context)!.signInWithApple,
                subtitle: AppLocalizations.of(context)!.recommendedForIos,
                onTap: () {},
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _buildMethodCard(
                icon: Icons.mail_outline,
                title: AppLocalizations.of(context)!.signInWithEmail,
                subtitle: AppLocalizations.of(context)!.recommendedForIos,
                onTap: () {},
                isDark: isDark,
              ),
              
              const SizedBox(height: 32),
              
              // Privacy Guarantee Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E2827) : const Color(0xFFE8F3F1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF238477).withValues(alpha: 0.3) : const Color(0xFF238477).withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          color: Color(0xFF238477),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppLocalizations.of(context)!.privacyGuarantee,
                          style: AppTextStyles.label.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textDark : AppColors.charcoal,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildPrivacyItem(AppLocalizations.of(context)!.endToEndEncryption, isDark),
                    const SizedBox(height: 12),
                    _buildPrivacyItem(AppLocalizations.of(context)!.weNeverSeeData, isDark),
                    const SizedBox(height: 12),
                    _buildPrivacyItem(AppLocalizations.of(context)!.deleteCloudDataAnytime, isDark),
                    const SizedBox(height: 12),
                    _buildPrivacyItem(AppLocalizations.of(context)!.gdprCompliant, isDark),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.readPrivacyPolicy,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.primarySelected,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.open_in_new,
                            size: 16,
                            color: AppColors.primarySelected,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Set Up Later
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        AppLocalizations.of(context)!.setUpLater,
                        style: AppTextStyles.h3Title.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textDark : AppColors.charcoal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.softGray,
                            height: 1.4,
                          ),
                          children: [
                            TextSpan(text: AppLocalizations.of(context)!.enableBackupAnytime),
                            TextSpan(
                              text: AppLocalizations.of(context)!.settingsCloudBackup,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.textDark : AppColors.charcoal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.02),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDark ? AppColors.textDark : AppColors.charcoal,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textDark : AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.softGray,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? AppColors.textSecondaryDark : AppColors.softGray,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyItem(String text, bool isDark) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 18,
          color: Color(0xFF238477),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: AppTextStyles.body.copyWith(
            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A605D),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
