import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';

class ActivatedScreen extends StatelessWidget {
  const ActivatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Celebration icon/emoji as per image
                const Text(
                  '🥳', // Replace with asset if available, but image shows a party popper icon
                  style: TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 24),
                Text(
                  'Code Activated',
                  style: AppTextStyles.h1Display.copyWith(
                    color: AppColors.charcoal,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'You and Sarah both just unlocked\n15 days of premium access!',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.softGray,
                  ),
                ),
                const SizedBox(height: 40),
                _buildPremiumBenefitsCard(),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primarySelected,
                    foregroundColor: AppColors.white,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Start Tracking Expenses',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.softGray),
                    children: [
                      const TextSpan(text: 'Thank your friend who shared!\n'),
                      const TextSpan(text: 'You can invite more friends from '),
                      TextSpan(
                        text: 'Settings → Invite & Earn',
                        style: TextStyle(
                          color: AppColors.primarySelected,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumBenefitsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
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
            'Your Premium Benefits:',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.deepBlue,
            ),
          ),
          const SizedBox(height: 20),
          _buildBenefitRow('Ad-free experience'),
          const SizedBox(height: 12),
          _buildBenefitRow('All insights unlocked'),
          const SizedBox(height: 12),
          _buildBenefitRow('Unlimited\nexports'),
          const SizedBox(height: 12),
          _buildBenefitRow('Cloud backup enabled'),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFFEEEEEE)),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: AppTextStyles.body.copyWith(color: AppColors.charcoal),
              children: [
                const TextSpan(text: 'Valid until: '),
                TextSpan(
                  text: 'Feb 12, 2026',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Text(
            '(15 days from today)',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.softGray),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check, color: AppColors.accentTeal, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.body.copyWith(
              color: AppColors.charcoal,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
