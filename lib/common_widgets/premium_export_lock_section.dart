import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import '../l10n/app_localizations.dart';
import '../screens/premium/premium_screen.dart';

class PremiumExportLockSection extends StatelessWidget {
  const PremiumExportLockSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: isDark ? 0.4 : 0.15),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
        image: DecorationImage(
          image: AssetImage(
            isDark
                ? 'assets/images/premium-export-dark-bg.png'
                : 'assets/images/premium-export-light-bg.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.premiumExportTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.h3Title.copyWith(
              fontSize: 18,
              color: isDark ? AppColors.white : AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.unlockProfessionalDetails,
            textAlign: TextAlign.center,
            style: AppTextStyles.label.copyWith(
              color: isDark ? AppColors.whiteOpacity70 : AppColors.softGray,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PremiumScreen(),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              l10n.goPremiumBtn,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
