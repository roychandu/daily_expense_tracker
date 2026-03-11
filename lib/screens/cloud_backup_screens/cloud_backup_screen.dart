import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/primary_button.dart';
import 'package:daily_expense_tracker/l10n/app_localizations.dart';

class CloudBackupScreen extends StatelessWidget {
  const CloudBackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: CustomAppBar(title: AppLocalizations.of(context)!.cloudBackup),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Cloud Icon
              Center(
                child: Image.asset(
                  'assets/icons/cloud Backup icon.png',
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                AppLocalizations.of(context)!.protectFinancialData,
                textAlign: TextAlign.center,
                style: AppTextStyles.h2Section.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColors.textDark : AppColors.charcoal,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),

              // Subtitle
              Text(
                AppLocalizations.of(context)!.cloudBackupDescription,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.softGray,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              // Why Cloud Backup? Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.whyCloudBackup,
                      style: AppTextStyles.h3Title.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textDark : AppColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildFeatureItem(
                      Icons.phone_iphone_outlined,
                      AppLocalizations.of(context)!.switchPhonesEasily,
                      AppLocalizations.of(context)!.switchPhonesDesc,
                      isDark,
                    ),
                    const SizedBox(height: 20),
                    _buildFeatureItem(
                      Icons.loop_outlined,
                      AppLocalizations.of(context)!.automaticSync,
                      AppLocalizations.of(context)!.automaticSyncDesc,
                      isDark,
                    ),
                    const SizedBox(height: 20),
                    _buildFeatureItem(
                      Icons.lock_outline,
                      AppLocalizations.of(context)!.automaticSync,
                      AppLocalizations.of(context)!.automaticSyncDesc,
                      isDark,
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      title: AppLocalizations.of(context)!.enableCloudBackup,
                      onPressed: () {
                        // TODO: Implement Cloud Backup activation
                      },
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!.partOfPremium,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.softGray,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Current Status Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E2827)
                      : const Color(0xFFE8F3F1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.currentStatus,
                      style: AppTextStyles.h3Title.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textDark : AppColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStatusItem(
                      Icons.check_circle,
                      AppLocalizations.of(context)!.localStorageActive,
                      isDark,
                    ),
                    const SizedBox(height: 8),
                    _buildStatusItem(
                      Icons.check_circle,
                      AppLocalizations.of(context)!.dataSafeOnDevice,
                      isDark,
                    ),
                    const SizedBox(height: 8),
                    _buildStatusItem(
                      Icons.check_circle,
                      AppLocalizations.of(context)!.expensesLogged24x7,
                      isDark,
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.statusHeader,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.softGray,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.notEnabled,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: const Color(0xFFF05151),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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

  Widget _buildFeatureItem(
    IconData icon,
    String title,
    String subtitle,
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: isDark ? AppColors.textDark : AppColors.charcoal,
          size: 28,
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
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.body.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.softGray,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusItem(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF238477)),
        const SizedBox(width: 12),
        Text(
          text,
          style: AppTextStyles.body.copyWith(
            color: isDark ? AppColors.textDark : const Color(0xFF4A605D),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
