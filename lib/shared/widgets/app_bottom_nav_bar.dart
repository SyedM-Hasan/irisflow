import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/theme/app_theme_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({super.key, required this.currentIndex});

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home', route: AppRoutes.home),
    _NavItem(
      icon: Icons.bar_chart_rounded,
      label: 'Stats',
      route: AppRoutes.analytics,
    ),
    _NavItem(icon: Icons.timer_rounded, label: 'Modes', route: AppRoutes.modes),
    _NavItem(
      icon: Icons.person_rounded,
      label: 'Profile',
      route: AppRoutes.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.themeColors;
    return Container(
      decoration: BoxDecoration(
        color: c.navBackground,
        border: Border(top: BorderSide(color: c.navBorder, width: 1)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _buildNavItem(context, _items[0], 0, c),
              _buildNavItem(context, _items[1], 1, c),
              _buildCenterButton(context, c),
              _buildNavItem(context, _items[2], 2, c),
              _buildNavItem(context, _items[3], 3, c),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    _NavItem item,
    int index,
    AppThemeColors c,
  ) {
    final selected = index == currentIndex;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!selected) context.go(item.route);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: selected ? c.accentSubtle : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                item.icon,
                color: selected ? c.navActive : c.navInactive,
                size: 24,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: AppTextStyles.labelMedium.copyWith(
                color: selected ? c.navActive : c.navInactive,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context, AppThemeColors c) {
    return GestureDetector(
      onTap: () => context.go(AppRoutes.strainAnalysis),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: c.accent,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: c.accentGlow, blurRadius: 12, spreadRadius: 2),
          ],
        ),
        child: const Icon(
          Icons.remove_red_eye_rounded,
          color: Colors.black,
          size: 24,
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String route;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
