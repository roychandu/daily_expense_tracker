import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/primary_button.dart';

class CloudBackupScreen extends StatelessWidget {
  const CloudBackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: const CustomAppBar(title: 'Cloud Backup'),
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
                'Protect Your\nFinancial Data',
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
                'Your expenses are safely stored\non your device. Add cloud\nbackup for extra peace of mind.',
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
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Why Cloud Backup?',
                      style: AppTextStyles.h3Title.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textDark : AppColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildFeatureItem(
                      Icons.phone_iphone_outlined,
                      'Switch Phones Easily',
                      'Move to a new device without losing any data',
                      isDark,
                    ),
                    const SizedBox(height: 20),
                    _buildFeatureItem(
                      Icons.loop_outlined,
                      'Automatic Sync',
                      'Data backed up daily, no manual exports needed',
                      isDark,
                    ),
                    const SizedBox(height: 20),
                    _buildFeatureItem(
                      Icons.lock_outline,
                      'Automatic Sync',
                      'Data backed up daily, no manual exports needed',
                      isDark,
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      title: 'Enable Cloud Backup',
                      onPressed: () {
                        // TODO: Implement Cloud Backup activation
                      },
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        'PART OF PREMIUM (\$3.99 ONE-TIME)',
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
                      'Current Status',
                      style: AppTextStyles.h3Title.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textDark : AppColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStatusItem(
                      Icons.check_circle,
                      'Local storage: Active',
                      isDark,
                    ),
                    const SizedBox(height: 8),
                    _buildStatusItem(
                      Icons.check_circle,
                      'Data safe on your device',
                      isDark,
                    ),
                    const SizedBox(height: 8),
                    _buildStatusItem(
                      Icons.check_circle,
                      '24x7  expenses logged',
                      isDark,
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CLOUD BACKUP',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.softGray,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'NOT ENABLED',
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
