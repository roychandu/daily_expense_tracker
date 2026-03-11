import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common_widgets/app_colors.dart';
import '../common_widgets/app_text_styles.dart';
import '../services/app_flow_service.dart';
import 'onboarding_screens/onboarding_screen.dart';
import 'onboarding_screens/code_invitation_screen.dart';
import 'home_screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final appFlow = Provider.of<AppFlowService>(context, listen: false);
    
    Widget nextScreen;
    if (appFlow.isFirstLaunch) {
      nextScreen = const OnboardingScreen();
    } else if (appFlow.getReferralCode() != null) {
      nextScreen = const CodeInvitationScreen();
    } else {
      nextScreen = const HomeScreen();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/splash-icon.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 32),
            Text(
              'Tracksy',
              style: AppTextStyles.h1Display.copyWith(
                color: const Color(0xFF914C1D), // Brownish color from image
                fontSize: 48,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Expense Tracking App',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.charcoal,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
