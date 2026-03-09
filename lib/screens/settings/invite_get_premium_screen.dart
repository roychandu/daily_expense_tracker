import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import 'invite_screen.dart';

class InviteGetPremiumScreen extends StatelessWidget {
  const InviteGetPremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : AppColors.backgroundLight,
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              color: isDark ? Colors.white : AppColors.charcoal,
            ),
            label: Text(
              'Close',
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.charcoal,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _buildCelebrationIcon(),
            const SizedBox(height: 32),
            Text(
              'Woohoo!\nFriend joined!',
              textAlign: TextAlign.center,
              style: AppTextStyles.h1Display.copyWith(
                color: isDark ? Colors.white : AppColors.charcoal,
                fontSize: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Sarah downloaded the app using your link. You both just earned 15 days of premium access!',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: isDark ? Colors.white70 : AppColors.softGray,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 48),
            _buildRewardCard(isDark),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              child: const Text(
                'Explore premium features',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const InviteScreen()),
                );
              },
              child: const Text(
                'Invite More Friends',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '2 INVITES USED • 1 INVITE REMAINING',
              style: AppTextStyles.label.copyWith(
                color: isDark ? Colors.white38 : Colors.black38,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCelebrationIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(Icons.celebration, color: Colors.orange, size: 80),
      ),
    );
  }

  Widget _buildRewardCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.5),
          width: 2,
        ),
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2C2C2C), const Color(0xFF1E1E1E)]
              : [const Color(0xFFFFF8F0), const Color(0xFFFFF2E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          _buildRewardItem(isDark, Icons.check_circle, 'Premium activated'),
          const SizedBox(height: 16),
          _buildRewardItem(isDark, Icons.check_circle, 'Valid for 15 days'),
          const SizedBox(height: 16),
          _buildRewardItem(isDark, Icons.check_circle, 'All features unlocked'),
        ],
      ),
    );
  }

  Widget _buildRewardItem(bool isDark, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.greenAccent, size: 24),
        const SizedBox(width: 12),
        Text(
          text,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: isDark ? Colors.white : AppColors.charcoal,
          ),
        ),
      ],
    );
  }
}
