import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../l10n/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          l10n.aboutNeelStudio,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            fontFamily: 'Serif',
          ),
        ),
        titleSpacing: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.neelStudioSlogan1,
              style: AppTextStyles.h2Section.copyWith(
                fontSize: 22,
                fontFamily: 'Serif',
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.neelStudioSlogan2,
              style: AppTextStyles.body.copyWith(
                fontSize: 16,
                height: 1.6,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              l10n.productStandard,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            _buildBulletPoint(l10n.fastActions, isDark),
            _buildBulletPoint(l10n.clearOutcomes, isDark),
            _buildBulletPoint(l10n.calmDesign, isDark),
            _buildBulletPoint(l10n.respectForTime, isDark),
            _buildBulletPoint(l10n.continuousImprovement, isDark),
            const SizedBox(height: 32),
            Text(
              l10n.buildForRepeatValue,
              style: AppTextStyles.body.copyWith(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: AppColors.primarySelected,
              ),
            ),
            const SizedBox(height: 48),
            Center(
              child: Column(
                children: [
                  Text(
                    l10n.realProblemsRealPeople,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 14,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.durableSolutions,
                    style: AppTextStyles.h2Section.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primarySelected,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Icon(
              Icons.circle,
              size: 6,
              color: AppColors.primarySelected,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body.copyWith(
                fontSize: 16,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
