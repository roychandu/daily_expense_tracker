import 'package:flutter/material.dart';
import '../../common_widgets/app_colors.dart';
import '../../common_widgets/app_text_styles.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'About Neel Studio',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            fontFamily: 'Serif',
          ),
        ),
        titleSpacing: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Neel Studio builds practical apps for real life.',
              style: AppTextStyles.h2Section.copyWith(
                fontSize: 22,
                fontFamily: 'Serif',
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'We focus on tools that help people stay organized, make better daily decisions, and build consistency — without complexity or distraction.',
              style: AppTextStyles.body.copyWith(
                fontSize: 16,
                height: 1.6,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Our product standard is simple:',
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            _buildBulletPoint('Fast actions', isDark),
            _buildBulletPoint('Clear outcomes', isDark),
            _buildBulletPoint('Calm design', isDark),
            _buildBulletPoint('Respect for your time', isDark),
            _buildBulletPoint(
              'Continuous improvement based on real feedback',
              isDark,
            ),
            const SizedBox(height: 32),
            Text(
              'We don’t build for hype. We build for repeat value.',
              style: AppTextStyles.body.copyWith(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: AppColors.primarySelected,
              ),
            ),
            const SizedBox(height: 48),
            Center(
              child: Column(
                children: [
                  Text(
                    'Real problems. Real people.',
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 14,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Durable solutions.',
                    style: AppTextStyles.h2Section.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primarySelected,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Icon(
              Icons.circle,
              size: 6,
              color: AppColors.primarySelected,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body.copyWith(
                fontSize: 16,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
