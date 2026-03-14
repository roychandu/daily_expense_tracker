import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_text_field.dart';
import '../../common_widgets/primary_button.dart';
import '../../common_widgets/secondary_button.dart';
import '../../common_widgets/custom_app_bar.dart';
import 'package:daily_expense_tracker/l10n/app_localizations.dart';
import '../../services/auth_service.dart';
import 'login_screen.dart';
import '../home_screen/home_screen.dart';
import '../../services/app_flow_service.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: CustomAppBar(
            title: AppLocalizations.of(context)!.register,
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          CustomTextField(
                            controller: _emailController,
                            hintText: AppLocalizations.of(context)!.email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: AppLocalizations.of(context)!.password,
                            obscureText: !_isPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off_outlined,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.softGray,
                              ),
                              onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _confirmPasswordController,
                            hintText: AppLocalizations.of(context)!.confirmPassword,
                            obscureText: !_isConfirmPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off_outlined,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.softGray,
                              ),
                              onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(height: 24),
                          PrimaryButton(
                            title: AppLocalizations.of(context)!.register,
                            onPressed: () async {
                              if (_passwordController.text != _confirmPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Passwords do not match')),
                                );
                                return;
                              }
                              setState(() => _isLoading = true);
                              try {
                                final user = await AuthService().registerWithEmail(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                                if (user != null && context.mounted) {
                                  // Sign out after registration as requested by user to go through login flow
                                  await AuthService().signOut();
                                  if (!context.mounted) return;
                                  
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Registration successful! Please login.')),
                                  );
                                  
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                } else if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Registration failed. Please check your details.')),
                                  );
                                }
                              } finally {
                                if (mounted) setState(() => _isLoading = false);
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.alreadyHaveAccount,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.softGray,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.logInSmall,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primarySelected,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "OR",
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.softGray,
                                  ),
                                ),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SecondaryButton(
                            title: 'Continue Offline',
                            textColor: AppColors.primarySelected,
                            borderColor: AppColors.primarySelected,
                            onPressed: () async {
                              // Mark login prompt as seen and skip for now
                              await context.read<AppFlowService>().setHasSeenLoginPrompt();
                              if (!mounted) return;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          SecondaryButton(
                            title: AppLocalizations.of(context)!.signUpWithGoogle,
                            icon: Image.asset('assets/icons/google-icon.png'),
                            onPressed: () async {
                              setState(() => _isLoading = true);
                                try {
                                  final user = await AuthService().signInWithGoogle();
                                  if (user != null && context.mounted) {
                                    // Sign out and go to Login as requested
                                    await AuthService().signOut();
                                    if (!context.mounted) return;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Google Registration successful! Please login.')),
                                    );

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginScreen(),
                                      ),
                                    );
                                  } else if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Google Sign-In failed or was cancelled.')),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Google Sign-In Error: $e')),
                                    );
                                  }
                                } finally {
                                  if (mounted) setState(() => _isLoading = false);
                                }
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primarySelected,
              ),
            ),
          ),
      ],
    );
  }
}

