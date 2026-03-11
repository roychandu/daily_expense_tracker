import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_text_field.dart';
import '../../common_widgets/primary_button.dart';
import '../../common_widgets/secondary_button.dart';
import '../../common_widgets/custom_app_bar.dart';
import 'package:daily_expense_tracker/l10n/app_localizations.dart';

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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.register,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
              const SizedBox(height: 40),
              PrimaryButton(
                title: AppLocalizations.of(context)!.register,
                onPressed: () {
                  // TODO: Implement registration logic
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
              const SizedBox(height: 60),
              SecondaryButton(
                title: AppLocalizations.of(context)!.continueAsGuest,
                borderColor: AppColors.primarySelected,
                textColor: AppColors.primarySelected,
                onPressed: () {
                  // TODO: Implement guest login
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: Divider(color: isDark ? AppColors.whiteOpacity20 : AppColors.borderLight)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      AppLocalizations.of(context)!.or,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.softGray,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: isDark ? AppColors.whiteOpacity20 : AppColors.borderLight)),
                ],
              ),
              const SizedBox(height: 24),
              SecondaryButton(
                title: AppLocalizations.of(context)!.signUpWithGoogle,
                icon: Image.asset('assets/icons/google-icon.png'),
                onPressed: () {
                  // TODO: Implement Google sign up
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

