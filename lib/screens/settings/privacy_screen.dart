import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../l10n/app_localizations.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          l10n.privacyAndTrust,
          style: AppTextStyles.h2Section.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        titleSpacing: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        child: Column(
          children: [
            // Top Privacy Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF2C1F14), const Color(0xFF1E1E1E)]
                      : [const Color(0xFFFFF5ED), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primarySelected.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        color: AppColors.primarySelected,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.localFirstControl,
                          style: AppTextStyles.h2Section.copyWith(
                            fontSize: 18,
                            fontFamily: 'Serif',
                            color: AppColors.primarySelected,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.recordsStayOnDevice,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 14,
                      height: 1.5,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Privacy Rows Card
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  children: [
                    _buildPrivacyRow(
                      context,
                      l10n.onDeviceStorage,
                      l10n.onDeviceStorageDesc,
                      Icons.storage_rounded,
                    ),
                    _buildDivider(isDark),
                    _buildPrivacyRow(
                      context,
                      l10n.noAccountNeeded,
                      l10n.noAccountNeededDesc,
                      Icons.no_accounts_rounded,
                    ),
                    _buildDivider(isDark),
                    _buildPrivacyRow(
                      context,
                      l10n.notificationsPrivacy,
                      l10n.notificationsPrivacyDesc,
                      Icons.notifications_none_rounded,
                    ),
                    _buildDivider(isDark),
                    _buildPrivacyRow(
                      context,
                      l10n.adsAndPremium,
                      l10n.adsAndPremiumDesc,
                      Icons.workspace_premium_outlined,
                    ),
                    _buildDivider(isDark),
                    _buildPrivacyRow(
                      context,
                      l10n.exportMyData,
                      l10n.exportMyDataDesc,
                      Icons.ios_share_rounded,
                    ),
                    _buildDivider(isDark),
                    _buildPrivacyRow(
                      context,
                      l10n.deleteMyData,
                      l10n.deleteMyDataDesc,
                      Icons.delete_outline_rounded,
                      isDestructive: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyRow(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon, {
    bool isDestructive = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 22,
            color: isDestructive ? Colors.redAccent : AppColors.primarySelected,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDestructive
                        ? Colors.redAccent
                        : (isDark ? Colors.white : Colors.black),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 13,
                    height: 1.4,
                    color: isDark ? Colors.white38 : Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark
          ? Colors.white.withValues(alpha: 0.05)
          : Colors.black.withValues(alpha: 0.02),
    );
  }
}
