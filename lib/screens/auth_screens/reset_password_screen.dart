import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';
import '../../common_widgets/custom_text_field.dart';
import '../../common_widgets/primary_button.dart';
import '../../common_widgets/custom_app_bar.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({
    super.key,
    required this.email,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isRepeatPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Text(
                widget.email,
                style: AppTextStyles.body.copyWith(
                  color: isDark ? AppColors.textDark : AppColors.charcoal,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                controller: _passwordController,
                hintText: 'Password',
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
                controller: _repeatPasswordController,
                hintText: 'Repeat Password',
                obscureText: !_isRepeatPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isRepeatPasswordVisible ? Icons.visibility : Icons.visibility_off_outlined,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.softGray,
                  ),
                  onPressed: () => setState(() => _isRepeatPasswordVisible = !_isRepeatPasswordVisible),
                ),
              ),
              const SizedBox(height: 120),
              PrimaryButton(
                title: 'Reset Password',
                onPressed: () {
                  // TODO: Implement reset password logic
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

