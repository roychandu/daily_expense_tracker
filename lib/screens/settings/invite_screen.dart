import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../controllers/settings_controller.dart';

class InviteScreen extends StatelessWidget {
  const InviteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = Provider.of<SettingsController>(context);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Invite & Earn Premium',
          style: AppTextStyles.h3Title.copyWith(
            color: isDark ? Colors.white : AppColors.charcoal,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : AppColors.charcoal,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopPromoCard(),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'How it works'),
            const SizedBox(height: 12),
            _buildHowItWorksCard(
              isDark,
              1,
              'Share Your Link',
              'Send to friends via any app',
            ),
            _buildHowItWorksCard(
              isDark,
              2,
              'Friend Downloads & Opens',
              'They install from Play/App Store',
            ),
            _buildHowItWorksCard(
              isDark,
              3,
              'Both Get 15 Days Premium',
              'Unlocked instantly, no catch!',
            ),
            const SizedBox(height: 24),
            _buildStatusCard(isDark, settings),
            const SizedBox(height: 24),
            _buildReferralLinkSection(isDark),
            const SizedBox(height: 24),
            _buildTermsSection(context, isDark),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPromoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/images/Go Premium Card.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),

            child: Image.asset(
              'assets/icons/gift-icon.png',
              width: 90,
              height: 90,
              fit: BoxFit.contain,
            ),
          ),
          Text(
            'Share the love, Earn Premium',
            textAlign: TextAlign.left,
            style: AppTextStyles.h2Section.copyWith(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Help friend track expense better and both get rewarded',
            textAlign: TextAlign.left,
            style: AppTextStyles.body.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: AppTextStyles.h3Title.copyWith(
        fontSize: 18,
        color: isDark ? Colors.white : AppColors.charcoal,
      ),
    );
  }

  Widget _buildHowItWorksCard(
    bool isDark,
    int step,
    String title,
    String subtitle,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$step',
              style: AppTextStyles.h3Title.copyWith(
                fontSize: 20,
                color: Colors.orange,
              ),
            ),
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
                    fontSize: 15,
                    color: isDark ? Colors.white : AppColors.charcoal,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.label.copyWith(
                    color: isDark ? Colors.white70 : AppColors.softGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(bool isDark, SettingsController settings) {
    final invitedCount = settings.invitedFriendsCount;
    final maxInvites = 3;
    final earnedDays = settings.earnedPremiumDays;
    final progress = invitedCount / maxInvites;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'STATUS',
                style: AppTextStyles.label.copyWith(
                  color: isDark ? Colors.white54 : AppColors.softGray,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$earnedDays days earned',
                    style: AppTextStyles.label.copyWith(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (settings.referralExpiryDate != 'None')
                    Text(
                      'Expires: ${settings.referralExpiryDate}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isDark ? Colors.white54 : AppColors.softGray,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Friends invited: $invitedCount / $maxInvites',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: isDark
                  ? Colors.white10
                  : Colors.black.withValues(alpha: 0.05),
              valueColor: const AlwaysStoppedAnimation(Colors.orange),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              invitedCount >= maxInvites
                  ? 'You have reached the maximum invites!'
                  : 'Invite ${maxInvites - invitedCount} more friend${maxInvites - invitedCount > 1 ? 's' : ''} to max out!',
              style: AppTextStyles.label.copyWith(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralLinkSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Your Referral Link',
            style: AppTextStyles.label.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white10
                  : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black12,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'expensetrack.app/r/USER123',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontFamily: 'monospace',
                      color: isDark ? Colors.white70 : AppColors.charcoal,
                    ),
                  ),
                ),
                Icon(
                  Icons.copy,
                  size: 20,
                  color: isDark ? Colors.white70 : AppColors.softGray,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: const Text(
              'Copy Link',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orange,
              side: const BorderSide(color: Colors.orange),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Share via...',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(Icons.share, Colors.green),
              const SizedBox(width: 20),
              _buildSocialIcon(Icons.email, Colors.blue),
              const SizedBox(width: 20),
              _buildSocialIcon(Icons.chat_bubble, Colors.deepPurple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _buildTermsSection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue, size: 18),
              const SizedBox(width: 8),
              Text(
                'Program Terms',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isDark ? Colors.white : AppColors.charcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTermBullet(
            isDark,
            'Each friend must be a new user who hasn\'t installed the app before.',
          ),
          _buildTermBullet(
            isDark,
            'Maximum of 3 successful invites allowed per user.',
          ),
          _buildTermBullet(
            isDark,
            'Premium rewards are activated immediately after the friend opens the app using your link.',
          ),
          _buildTermBullet(
            isDark,
            'We reserve the right to cancel rewards for suspicious activity.',
          ),
        ],
      ),
    );
  }

  Widget _buildTermBullet(bool isDark, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(Icons.circle, size: 6, color: AppColors.softGray),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.label.copyWith(
                color: isDark ? Colors.white70 : AppColors.softGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
