import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../controllers/settings_controller.dart';
import '../../l10n/app_localizations.dart';
// import '../database/database_viewer_screen.dart'; // No longer used as DEBUG section is hidden
import '../../common_widgets/custom_snackbar.dart';
import '../../services/export_service.dart';
import '../../services/database_service.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // bool _dailyReminder = true; // Removed local state

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsController>();
    final currentLanguage = SettingsController.supportedLanguages.firstWhere(
      (l) => l['code'] == settings.locale.languageCode,
    )['name'];
    final currentCurrency = SettingsController.supportedCurrencies.firstWhere(
      (c) => c['code'] == settings.currency,
    )['code'];
    final currentCurrencySymbol = SettingsController.supportedCurrencies
        .firstWhere((c) => c['code'] == settings.currency)['symbol'];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(l10n.preferences),
            _buildSettingsCard([
              _buildRow(
                l10n.language,
                currentLanguage!,
                hasNav: true,
                onTap: () => _showLanguageDialog(context, settings),
              ),
              const Divider(height: 1),
              _buildRow(
                l10n.currency,
                '$currentCurrency ($currentCurrencySymbol)',
                hasNav: true,
                onTap: () => _showCurrencyDialog(context, settings),
              ),
              const Divider(height: 1),
              _buildSwitchRow(
                l10n.darkMode,
                settings.themeMode == ThemeMode.dark,
                (val) {
                  settings.updateThemeMode(
                    val ? ThemeMode.dark : ThemeMode.light,
                  );
                },
              ),
              const Divider(height: 1),
              _buildSwitchRow(
                l10n.dailyReminder,
                settings.isDailyReminderEnabled,
                (val) => _handleReminderToggle(val, settings),
              ),
            ]),

            const SizedBox(height: 24),

            _buildSectionHeader(l10n.data),
            _buildSettingsCard([
              _buildRow(
                l10n.exportCsv,
                l10n.watchAd,
                isBonus: true,
                onTap: () => _handleExport(context, true),
              ),
              const Divider(height: 1),
              _buildRow(
                l10n.exportPdf,
                l10n.watchAd,
                isBonus: true,
                onTap: () => _handleExport(context, false),
              ),
            ]),

            const SizedBox(height: 24),

            _buildSectionHeader(l10n.premium),
            _buildSettingsCard([
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    l10n.removeAds,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primarySelected,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ]),

            const SizedBox(height: 24),
            _buildSectionHeader(l10n.about),
            _buildSettingsCard([
              _buildRow(l10n.privacyPolicy, '', hasNav: true),
              const Divider(height: 1),
              _buildRow(l10n.termsOfService, '', hasNav: true),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    '${l10n.version} 1.0.0',
                    style: AppTextStyles.caption,
                  ),
                ),
              ),
            ]),

            // const SizedBox(height: 24),
            // _buildSectionHeader('DEBUG'),
            // _buildSettingsCard([
            //   _buildRow(
            //     'View Raw Database',
            //     '',
            //     hasNav: true,
            //     onTap: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => const DatabaseViewerScreen(),
            //         ),
            //       );
            //     },
            //   ),
            // ]),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsController settings) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectLanguage),
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
                    ? const Icon(Icons.check, color: AppColors.primarySelected)
                    : null,
                onTap: () async {
                  await settings.updateLocale(Locale(lang['code']!));
                  if (!mounted) return;
                  final newL10n = AppLocalizations.of(context)!;
                  await settings.rescheduleReminder(
                    title: newL10n.appTitle,
                    body: newL10n.reminderBody,
                  );
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
                    ? const Icon(Icons.check, color: AppColors.primarySelected)
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildRow(
    String title,
    String subtitle, {
    bool hasNav = false,
    bool isBonus = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title, style: AppTextStyles.body),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (subtitle.isNotEmpty)
            isBonus
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySelected,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  )
                : Text(
                    subtitle,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.softGray,
                    ),
                  ),
          if (hasNav) ...[
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppColors.softGray),
          ],
        ],
      ),
      onTap: onTap,
    );
  }

  Future<void> _handleReminderToggle(
    bool enabled,
    SettingsController settings,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    if (enabled) {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        if (mounted) {
          _showNoInternetDialog(context, l10n);
        }
        return;
      }
    }
    await settings.updateDailyReminder(
      enabled,
      title: l10n.appTitle,
      body: l10n.reminderBody,
    );
  }

  void _showNoInternetDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.wifi_off, color: Colors.orange),
            const SizedBox(width: 8),
            Text(l10n.internetRequired),
          ],
        ),
        content: Text(l10n.reminderInternetRequirement),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
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
          expLabelShort: 'Exp', // Standard abbreviations
          incLabelShort: 'Inc',
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

  Widget _buildSwitchRow(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(title, style: AppTextStyles.body),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primarySelected,
    );
  }
}
