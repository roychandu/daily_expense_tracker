import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _dailyReminder = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('PREFERENCES'),
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (context, currentMode, child) {
                final isDarkMode = currentMode == ThemeMode.dark;
                return _buildSettingsCard([
                  _buildRow('Language', 'English', hasNav: true),
                  const Divider(height: 1),
                  _buildRow('Currency', 'USD (\$)', hasNav: true),
                  const Divider(height: 1),
                  _buildSwitchRow('Dark Mode', isDarkMode, (val) {
                    themeNotifier.value = val
                        ? ThemeMode.dark
                        : ThemeMode.light;
                  }),
                  const Divider(height: 1),
                  _buildSwitchRow(
                    'Daily Reminder',
                    _dailyReminder,
                    (val) => setState(() => _dailyReminder = val),
                  ),
                ]);
              },
            ),

            const SizedBox(height: 24),

            _buildSectionHeader('DATA'),
            _buildSettingsCard([
              _buildRow('Export CSV', 'Watch Ad', isBonus: true),
              const Divider(height: 1),
              _buildRow('Export PDF', 'Watch Ad', isBonus: true),
            ]),

            const SizedBox(height: 24),

            _buildSectionHeader('PREMIUM'),
            _buildSettingsCard([
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'Remove Ads - \$3.99',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.accentTeal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ]),

            const SizedBox(height: 24),
            _buildSectionHeader('ABOUT'),
            _buildSettingsCard([
              _buildRow('Privacy Policy', '', hasNav: true),
              const Divider(height: 1),
              _buildRow('Terms of Service', '', hasNav: true),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text('Version 1.0.0', style: AppTextStyles.caption),
                ),
              ),
            ]),
          ],
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
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                      color: AppColors.accentTeal,
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
      onTap: () {},
    );
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
      activeColor: AppColors.accentTeal,
    );
  }
}
