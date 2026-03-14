import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_app_bar.dart';
import 'package:daily_expense_tracker/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../services/sync_service.dart';

class DataSyncScreen extends StatelessWidget {
  const DataSyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: CustomAppBar(title: AppLocalizations.of(context)!.dataSync),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cloud Status Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2F1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.cloud_done_outlined,
                            color: Color(0xFF238477),
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.cloudBackup.toUpperCase(),
                                style: AppTextStyles.h3Title.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.textDark
                                      : AppColors.charcoal,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline,
                                    size: 14,
                                    color: Color(0xFF238477),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.activeAndSyncing,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: const Color(0xFF238477),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              ValueListenableBuilder<DateTime?>(
                                valueListenable:
                                    SyncService.instance.lastSyncTime,
                                builder: (context, lastSync, _) {
                                  String lastSyncStr = 'Never';
                                  if (lastSync != null) {
                                    final now = DateTime.now();
                                    final diff = now.difference(lastSync);
                                    if (diff.inMinutes < 1) {
                                      lastSyncStr = 'Just now';
                                    } else if (diff.inHours < 1) {
                                      lastSyncStr =
                                          '${diff.inMinutes} minutes ago';
                                    } else if (diff.inDays < 1) {
                                      lastSyncStr = '${diff.inHours} hours ago';
                                    } else {
                                      lastSyncStr = DateFormat(
                                        'MMM d, h:mm a',
                                      ).format(lastSync);
                                    }
                                  }
                                  return Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.lastBackup(lastSyncStr),
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.softGray,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.accountEmail(
                              FirebaseAuth.instance.currentUser?.email ??
                                  'Not logged in',
                            ),
                            style: AppTextStyles.body.copyWith(
                              color: isDark
                                  ? AppColors.textDark
                                  : AppColors.charcoal,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ValueListenableBuilder<String>(
                            valueListenable: SyncService.instance.storageUsed,
                            builder: (context, storage, _) {
                              return Text(
                                AppLocalizations.of(
                                  context,
                                )!.storageUsed(storage),
                                style: AppTextStyles.body.copyWith(
                                  color: isDark
                                      ? AppColors.textDark
                                      : AppColors.charcoal,
                                  fontSize: 15,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Text(
                AppLocalizations.of(context)!.options,
                style: AppTextStyles.h3Title.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textDark : AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 16),

              // Options List Card
              Container(
                width: double.infinity,
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
                child: Column(
                  children: [
                    _buildOptionTile(
                      title: AppLocalizations.of(context)!.syncFrequency,
                      trailing: 'Every 4 Hours',
                      isDark: isDark,
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _buildOptionTile(
                      title: AppLocalizations.of(context)!.downloadAllData,
                      isDark: isDark,
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _buildOptionTile(
                      title: AppLocalizations.of(
                        context,
                      )!.disconnectDeleteCloud,
                      titleColor: const Color(0xFFF05151),
                      isDark: isDark,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Privacy Shield Decoration
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E2827)
                            : const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/icons/data sync icon.png',
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        AppLocalizations.of(context)!.cloudSecureDesc,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.softGray,
                          height: 1.4,
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

  Widget _buildOptionTile({
    required String title,
    String? trailing,
    Color? titleColor,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          color:
              titleColor ?? (isDark ? AppColors.textDark : AppColors.charcoal),
          fontSize: 17,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing,
              style: AppTextStyles.body.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.softGray,
              ),
            ),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right,
            color: isDark ? AppColors.textSecondaryDark : AppColors.softGray,
          ),
        ],
      ),
    );
  }
}
