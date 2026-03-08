import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';

class PremiumUnlockedScreen extends StatelessWidget {
  const PremiumUnlockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? AppColors.textDark : AppColors.charcoal,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Premium Unlocked',
          style: AppTextStyles.h2Section.copyWith(
            color: isDark ? AppColors.textDark : AppColors.charcoal,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Premium Icon
              Center(
                child: Image.asset(
                  isDark
                      ? 'assets/icons/premium_icon-darkmode.png'
                      : 'assets/icons/premium_icon-lightmode.png',
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              // Welcome Text
              Text(
                'Welcome to\nPremium',
                textAlign: TextAlign.center,
                style: AppTextStyles.h1Display.copyWith(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColors.textDark : AppColors.deepBlue,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your upgrade is now active',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.orange[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              // Features Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2C2418)
                      : const Color(0xFFFFFDE7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? AppColors.primarySelected
                        : const Color(0xFFFFD54F),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    _buildFeatureItem('All ads Removed', isDark),
                    _buildFeatureItem('All insights unlocked', isDark),
                    _buildFeatureItem('Unlimited exports activated', isDark),
                    _buildFeatureItem('Premium features ready', isDark),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Explore Button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primarySelected,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size.fromHeight(60),
                  elevation: 4,
                ),
                child: const Text(
                  'Explore premium features',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 32),
              // Footer
              _buildFooter(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFFA5D6A7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              size: 16,
              color: AppColors.successGreen,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyLarge.copyWith(
                color: isDark ? AppColors.textDark : AppColors.charcoal,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.bodySmall.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
              children: [
                const TextSpan(text: 'By purchasing, you agree to our '),
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: isDark ? AppColors.textDark : AppColors.charcoal,
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: isDark ? AppColors.textDark : AppColors.charcoal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
