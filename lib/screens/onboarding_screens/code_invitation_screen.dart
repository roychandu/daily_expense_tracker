import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import 'activated_screen.dart';
import '../../services/app_flow_service.dart';
import 'package:provider/provider.dart';

class CodeInvitationScreen extends StatefulWidget {
  const CodeInvitationScreen({super.key});

  @override
  State<CodeInvitationScreen> createState() => _CodeInvitationScreenState();
}

class _CodeInvitationScreenState extends State<CodeInvitationScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

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
                Image.asset(
                  'assets/icons/gift-icon.png',
                  height: 200,
                ),
                const SizedBox(height: 32),
                Text(
                  'You\'ve been Invited',
                  style: AppTextStyles.h1Display.copyWith(
                    color: AppColors.charcoal,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'A friend shared this app with you...',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.softGray,
                  ),
                ),
                const SizedBox(height: 40),
                _buildReferralInput(),
                const SizedBox(height: 24),
                _buildBenefitsCard(),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => _validateAndClaim(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primarySelected,
                    foregroundColor: AppColors.white,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Claim your Premium',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    // Navigate to home or wherever "Skip" leads
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text(
                    'Skip',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.softGray,
                      fontWeight: FontWeight.w600,
                    ),
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

  Widget _buildReferralInput() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primarySelected.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            'ENTER REFERRAL CODE',
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.softGray,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 150,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.primarySelected, width: 2),
              ),
            ),
            child: TextField(
              controller: _codeController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'A B C 1 2 3',
                hintStyle: AppTextStyles.h2Section.copyWith(
                  color: AppColors.softGray.withOpacity(0.5),
                  letterSpacing: 4,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: AppTextStyles.h2Section.copyWith(
                color: AppColors.charcoal,
                letterSpacing: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8), // Light bluish gray from image
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _buildBenefitRow('15 days premium access'),
          const SizedBox(height: 12),
          _buildBenefitRow('All insights unlocked'),
          const SizedBox(height: 12),
          _buildBenefitRow('Unlimited exports'),
          const SizedBox(height: 12),
          _buildBenefitRow('Ad-free experience'),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(String text) {
    return Row(
      children: [
        const Icon(Icons.check, color: AppColors.accentTeal, size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: AppTextStyles.body.copyWith(
            color: AppColors.charcoal,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _validateAndClaim(BuildContext context) {
    final appFlow = Provider.of<AppFlowService>(context, listen: false);
    if (appFlow.validateReferralCode(_codeController.text)) {
      appFlow.clearReferralCode(); // Clear after successful use
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ActivatedScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid referral code. Please try again.'),
          backgroundColor: AppColors.softCoral,
        ),
      );
    }
  }
}
