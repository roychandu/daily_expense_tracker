import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double scrollOpacity;
  final bool showBackButton;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.scrollOpacity = 0.0,
    this.showBackButton = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // isFirst == true means this is the root/bottom-tab route → hide back button.
    // isFirst == false means it was pushed onto the navigator → show back button.
    final isRootRoute = ModalRoute.of(context)?.isFirst ?? true;
    final shouldShowBack =
        showBackButton && !isRootRoute && Navigator.canPop(context);

    // Always use the scaffold's background as base so content never bleeds behind the AppBar.
    // Then overlay a premium-orange tint that fades in as user scrolls.
    final baseColor = isDark
        ? const Color(0xFF121212) // same as scaffolds' backgroundDark
        : const Color(0xFFF8F9FA); // same as AppColors.backgroundLight

    final tintColor = isDark
        ? AppColors.primarySelected.withValues(alpha: 0.18 * scrollOpacity)
        : AppColors.primarySelected.withValues(alpha: 0.10 * scrollOpacity);

    final bgColor = Color.alphaBlend(tintColor, baseColor);

    return AppBar(
      title:
          titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: AppTextStyles.h1Display.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                    fontFamily: 'Serif',
                    color: isDark ? AppColors.textDark : AppColors.charcoal,
                  ),
                )
              : null),
      automaticallyImplyLeading: false,
      leading:
          leading ??
          (shouldShowBack
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: () => Navigator.pop(context),
                )
              : null),
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: bgColor,
      surfaceTintColor: Colors.transparent,
      elevation: scrollOpacity > 0 ? 3 : 0,
      iconTheme: IconThemeData(
        color: isDark ? AppColors.textDark : AppColors.charcoal,
      ),
      bottom: bottom,
      titleSpacing: shouldShowBack || leading != null ? 0 : 20,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
