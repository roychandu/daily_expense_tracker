import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_text_field.dart';
import '../../common_widgets/primary_button.dart';
import '../../common_widgets/secondary_button.dart';
import '../../common_widgets/custom_app_bar.dart';
import 'package:daily_expense_tracker/l10n/app_localizations.dart';
import 'registration_screen.dart';
import 'forgot_password_screen.dart';
import '../../services/auth_service.dart';
import '../home_screen/home_screen.dart';
import '../../services/app_flow_service.dart';
import 'package:provider/provider.dart';
import '../../controllers/settings_controller.dart';
import '../../services/sync_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            title: AppLocalizations.of(context)!.login,
            showBackButton: false,
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
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off_outlined,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.softGray,
                              ),
                              onPressed: () =>
                                  setState(() => _isPasswordVisible = !_isPasswordVisible),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!.forgotPassword,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primarySelected,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(height: 24),
                          PrimaryButton(
                            title: AppLocalizations.of(context)!.login,
                            onPressed: () async {
                              setState(() => _isLoading = true);
                              try {
                                final user = await AuthService().signInWithEmail(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                                if (user != null && context.mounted) {
                                  // Enable cloud backup and navigate to SettingsScreen
                                  await context.read<SettingsController>().updateCloudBackup(true);
                                  
                                  // Perform initial sync of existing local data to Firebase
                                  await SyncService.instance.syncLocalToCloud();
                                  if (!context.mounted) return;

                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Successfully logged in! Your data is being synced.')),
                                  );

                                  // Mark login prompt as seen
                                  await context.read<AppFlowService>().setHasSeenLoginPrompt();

                                  if (!context.mounted) return;
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                    (route) => false,
                                  );
                                } else if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Login failed. Please check your email and password.')),
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
                                AppLocalizations.of(context)!.dontHaveAccount,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.softGray,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const RegistrationScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.register,
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
                            title: AppLocalizations.of(context)!.signInWithGoogle,
                            icon: Image.asset('assets/icons/google-icon.png'),
                            onPressed: () async {
                              setState(() => _isLoading = true);
                              try {
                                final user = await AuthService().signInWithGoogle();
                                if (user != null && context.mounted) {
                                  // Enable cloud backup and navigate to SettingsScreen
                                  await context.read<SettingsController>().updateCloudBackup(true);
                                  
                                  // Perform initial sync of existing local data to Firebase
                                  await SyncService.instance.syncLocalToCloud();
                                  if (!context.mounted) return;

                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Successfully logged in! Your data is being synced.')),
                                  );

                                  // Mark login prompt as seen
                                  await context.read<AppFlowService>().setHasSeenLoginPrompt();

                                  if (!context.mounted) return;
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                    (route) => false,
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
