import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_text_field.dart';
import '../../common_widgets/primary_button.dart';
import '../../common_widgets/custom_app_bar.dart';
import 'package:daily_expense_tracker/l10n/app_localizations.dart';
import 'reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.forgotPasswordTitle,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.forgotPasswordDesc,
                style: AppTextStyles.body.copyWith(
                  color: isDark ? AppColors.textDark : AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                controller: _emailController,
                hintText: AppLocalizations.of(context)!.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 120),
              PrimaryButton(
                title: AppLocalizations.of(context)!.sendEmail,
                onPressed: () {
                  // For demo purposes, we'll navigate to ResetPasswordScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordScreen(email: _emailController.text.isEmpty ? 'alexsmit@gmail.com' : _emailController.text),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.weWillSendResetEmail,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.softGray,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

