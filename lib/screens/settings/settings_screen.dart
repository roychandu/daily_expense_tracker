import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../controllers/settings_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../common_widgets/custom_snackbar.dart';
import '../../services/export_service.dart';
import '../../services/database_service.dart';
import 'package:intl/intl.dart';

import '../../utils/app_layout.dart';
import 'about_screen.dart';
import 'privacy_screen.dart';
import '../premium/unlock_premium_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final currentLanguage = SettingsController.supportedLanguages.firstWhere(
      (l) => l['code'] == settings.locale.languageCode,
    )['name'];

    final currentCurrency = SettingsController.supportedCurrencies.firstWhere(
      (c) => c['code'] == settings.currency,
    );

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: AppTextStyles.h1Display.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 28,
            fontFamily: 'Serif',
          ),
        ),
        titleSpacing: 10,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppLayout.horizontalPadding(context),
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium Card - Re-designed with a Banner approach
              _buildPremiumCard(context, settings, l10n),

              const SizedBox(height: 32),

              // Preferences Section
              _buildSectionHeader(l10n.preferencesSection),
              _buildSectionCard([
                _buildSettingsRow(
                  icon: Icons.public,
                  iconColor: Colors.indigo,
                  title: l10n.language,
                  trailingText: '$currentLanguage',
                  onTap: () => _showLanguageDialog(context, settings),
                ),
                _buildSettingsRow(
                  icon: Icons.account_balance_wallet,
                  iconColor: Colors.teal,
                  title: l10n.currency,
                  trailingText:
                      '${currentCurrency['code']} (${currentCurrency['symbol']})',
                  onTap: () => _showCurrencyDialog(context, settings),
                ),
                _buildSettingsRow(
                  icon: Icons.dark_mode,
                  iconColor: Colors.blueGrey,
                  title: l10n.darkMode,
                  isSwitch: true,
                  switchValue: settings.themeMode == ThemeMode.dark,
                  onSwitchChanged: (val) {
                    settings.updateThemeMode(
                      val ? ThemeMode.dark : ThemeMode.light,
                    );
                  },
                ),
                _buildSettingsRow(
                  icon: Icons.language_rounded,
                  iconColor: Colors.purpleAccent,
                  title: l10n.privacyPolicy,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyScreen(),
                    ),
                  ),
                ),
                _buildSettingsRow(
                  icon: Icons.layers_rounded,
                  iconColor: Colors.greenAccent,
                  title: l10n.aboutUs,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  ),
                ),
              ]),

              const SizedBox(height: 32),

              // Data Management Section
              _buildSectionHeader(l10n.dataManagementSection),
              _buildSectionCard([
                _buildSettingsRow(
                  icon: Icons.file_download,
                  iconColor: Colors.blueAccent,
                  title: l10n.exportTransactionHistory,
                  hasBadge: true,
                  badgeText: 'CSV',
                  badgeColor: AppColors.accentTeal,
                  onTap: () => _handleExport(context, true),
                ),
                _buildSettingsRow(
                  icon: Icons.picture_as_pdf,
                  iconColor: Colors.orangeAccent,
                  title: l10n.annualFinancialReport,
                  hasBadge: true,
                  badgeText: 'PDF',
                  badgeColor: AppColors.softCoral,
                  onTap: () => _handleExport(context, false),
                ),
              ]),

              const SizedBox(height: 32),

              // Notifications Section
              _buildSectionHeader(l10n.notificationsSection),
              _buildNotificationsCard(context, settings, l10n),

              const SizedBox(height: 48),
              Center(
                child: Text(
                  '${l10n.version} 1.0.0',
                  style: AppTextStyles.caption.copyWith(
                    color: isDark ? Colors.white24 : Colors.black26,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: AppTextStyles.h2Section.copyWith(
          fontSize: 20,
          fontFamily: 'Serif',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black45
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? trailingText,
    bool isSwitch = false,
    bool switchValue = false,
    ValueChanged<bool>? onSwitchChanged,
    bool hasBadge = false,
    String? badgeText,
    Color? badgeColor,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: isSwitch ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            if (isSwitch)
              Switch.adaptive(
                value: switchValue,
                onChanged: onSwitchChanged,
                activeTrackColor: AppColors.primarySelected.withValues(
                  alpha: 0.5,
                ),
                activeThumbColor: AppColors.primarySelected,
              )
            else if (hasBadge)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      badgeColor?.withValues(alpha: 0.1) ??
                      Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badgeText ?? '',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: badgeColor ?? Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else ...[
              Text(
                trailingText ?? '',
                style: AppTextStyles.caption.copyWith(
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: isDark ? Colors.white24 : Colors.black26,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumCard(
    BuildContext context,
    SettingsController settings,
    AppLocalizations l10n,
  ) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth;
            return Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/Go Premium Card.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.stars_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.premiumMember,
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.upgradeToGold,
                        style: AppTextStyles.h1Display.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          fontFamily: 'Serif',
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        child: Text(
                          l10n.premiumDescription,
                          style: AppTextStyles.body.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: cardWidth * 0.4,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const UnlockPremiumScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFFF2994A),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            l10n.upgradeNowBtn,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationsCard(
    BuildContext context,
    SettingsController settings,
    AppLocalizations l10n,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black45
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.notifications_active_rounded,
                    size: 20,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dailyReminder,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        l10n.buildConsistentHabit,
                        style: AppTextStyles.caption.copyWith(
                          color: isDark ? Colors.white38 : Colors.black38,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: settings.isDailyReminderEnabled,
                  onChanged: (val) => _handleReminderToggle(val, settings),
                  activeTrackColor: AppColors.primarySelected.withValues(
                    alpha: 0.5,
                  ),
                  activeThumbColor: AppColors.primarySelected,
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _showTimePickerDialog(context, settings),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF312419)
                      : const Color(0xFFFFF5ED),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTimeDigit(
                      DateFormat('HH').format(settings.reminderTime),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        ':',
                        style: AppTextStyles.h1Display.copyWith(
                          color: Colors.orange,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    _buildTimeDigit(
                      DateFormat('mm').format(settings.reminderTime),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        DateFormat(
                          'a',
                        ).format(settings.reminderTime).toUpperCase(),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeDigit(String digit) {
    return Text(
      digit,
      style: AppTextStyles.amountDisplay.copyWith(
        color: Colors.orange,
        fontSize: 36,
        fontWeight: FontWeight.w900,
        letterSpacing: 1,
      ),
    );
  }

  void _showTimePickerDialog(
    BuildContext context,
    SettingsController settings,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(settings.reminderTime),
    );
    if (picked != null) {
      final now = DateTime.now();
      final newDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      await settings.updateReminderTime(
        newDateTime,
        title: l10n.appTitle,
        body: l10n.reminderBody,
      );
    }
  }

  void _showLanguageDialog(BuildContext context, SettingsController settings) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectLanguage),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: SettingsController.supportedLanguages.length,
            itemBuilder: (context, index) {
              final lang = SettingsController.supportedLanguages[index];
              return ListTile(
                title: Text(lang['name']!),
                trailing: settings.locale.languageCode == lang['code']
                    ? const Icon(
                        Icons.check_circle,
                        color: AppColors.primarySelected,
                      )
                    : null,
                onTap: () async {
                  final l10n = AppLocalizations.of(context)!;
                  await settings.updateLocale(Locale(lang['code']!));
                  if (!mounted) return;
                  await settings.rescheduleReminder(
                    title: l10n.appTitle,
                    body: l10n.reminderBody,
                  );
                  if (!mounted) return;
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context, SettingsController settings) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectCurrency),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: SettingsController.supportedCurrencies.length,
            itemBuilder: (context, index) {
              final currency = SettingsController.supportedCurrencies[index];
              return ListTile(
                title: Text('${currency['name']} (${currency['symbol']})'),
                subtitle: Text(currency['code']!),
                trailing: settings.currency == currency['code']
                    ? const Icon(
                        Icons.check_circle,
                        color: AppColors.primarySelected,
                      )
                    : null,
                onTap: () {
                  settings.updateCurrency(currency['code']!);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _handleReminderToggle(
    bool enabled,
    SettingsController settings,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await settings.updateDailyReminder(
      enabled,
      title: l10n.appTitle,
      body: l10n.reminderBody,
    );
  }

  void _handleExport(BuildContext context, bool isCsv) async {
    final l10n = AppLocalizations.of(context)!;
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primarySelected),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (!mounted) return;
      showCustomSnackBar(
        context,
        isCsv ? l10n.generatingCsv : l10n.generatingPdf,
      );

      final expenses = await DatabaseService.instance.readExpensesByDateRange(
        picked.start,
        picked.end,
      );

      if (expenses.isEmpty) {
        if (!mounted) return;
        showCustomSnackBar(context, l10n.noDataFound, isError: true);
        return;
      }

      final fileName =
          'Expenses_${DateFormat('yyyyMMdd').format(picked.start)}_${DateFormat('yyyyMMdd').format(picked.end)}';

      String? result;
      if (isCsv) {
        result = await ExportService.exportToCSV(
          expenses,
          fileName,
          headers: [
            l10n.reportID,
            l10n.reportDate,
            l10n.reportCategory,
            l10n.reportAmount,
            l10n.reportType,
            l10n.reportNote,
          ],
          expenseLabel: l10n.expense,
          incomeLabel: l10n.income,
          fileSavedLabel: l10n.fileSavedTo,
          errorLabel: l10n.error,
          noDirLabel: l10n.couldNotFindExportDir,
        );
      } else {
        result = await ExportService.exportToPDF(
          expenses,
          fileName,
          picked.start,
          picked.end,
          headers: [
            l10n.reportDate,
            l10n.reportCategory,
            l10n.reportType,
            l10n.reportAmount,
            l10n.reportNote,
          ],
          reportTitle: l10n.expenseReport,
          totalExpenseLabel: l10n.totalExpenses,
          totalIncomeLabel: l10n.totalIncome,
          expLabelShort: l10n.exp,
          incLabelShort: l10n.inc,
          fileSavedLabel: l10n.fileSavedTo,
          errorLabel: l10n.error,
          noDirLabel: l10n.couldNotFindExportDir,
        );
      }

      if (!mounted) return;
      if (result != null && result.startsWith('File saved')) {
        showCustomSnackBar(context, result);
      } else {
        showCustomSnackBar(context, result ?? 'Unknown error', isError: true);
      }
    }
  }
}
