import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../home_screen/home_screen.dart';
import '../../services/app_flow_service.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildFirstSlide(),
                  _buildSecondSlide(),
                ],
              ),
            ),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstSlide() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/onboard-icon.png',
            height: 450,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 40),
          Text(
            'Track Expenses in under\n3 seconds',
            textAlign: TextAlign.center,
            style: AppTextStyles.h1Display.copyWith(
              color: AppColors.charcoal,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No login, No bank sync\n100% Private, 100% Offline',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.softGray,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondSlide() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Why People Love\nThis App',
            textAlign: TextAlign.center,
            style: AppTextStyles.h1Display.copyWith(
              color: AppColors.charcoal,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 40),
          _buildBenefitItem(
            icon: Icons.flash_on_outlined,
            title: 'Lightning Fast',
            description: 'Log an expense in under 3 seconds. No forms, no fuss.',
          ),
          const SizedBox(height: 16),
          _buildBenefitItem(
            icon: Icons.lock_outline,
            title: '100% Private',
            description: 'Your data never leaves your phone. No accounts, no tracking.',
          ),
          const SizedBox(height: 16),
          _buildBenefitItem(
            icon: Icons.lightbulb_outline,
            title: 'Smart Insights',
            description: 'See spending patterns, build daily logging streaks.',
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.charcoal, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.softGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              2,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? AppColors.primarySelected
                      : AppColors.primaryUnselected,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              if (_currentPage < 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                _completeOnboarding(context);
              }
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
              _currentPage == 0 ? 'Next' : 'Get Started',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => _completeOnboarding(context),
            child: Text(
              'Skip',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.softGray,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _completeOnboarding(BuildContext context) async {
    final appFlow = Provider.of<AppFlowService>(context, listen: false);
    await appFlow.setFirstLaunchComplete();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }
}
