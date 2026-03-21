import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_icons.dart';
import '../../theme/app_typography.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.showRadarDot = false,
    this.feedBadgeCount = 0,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool showRadarDot;
  final int feedBadgeCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              _NavItem(
                icon: AppIcons.radar,
                activeIcon: AppIcons.radarFill,
                label: 'Radar',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
                showDot: showRadarDot,
              ),
              _NavItem(
                icon: AppIcons.feed,
                activeIcon: AppIcons.feedFill,
                label: 'Feed',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
                badgeCount: feedBadgeCount,
              ),
              _NavItem(
                icon: AppIcons.profile,
                activeIcon: AppIcons.profileFill,
                label: 'Profile',
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.showDot = false,
    this.badgeCount = 0,
  });

  final PhosphorIconData icon;
  final PhosphorIconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool showDot;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.textMeta;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  PhosphorIcon(
                    isActive ? activeIcon : icon,
                    size: AppIcons.md,
                    color: color,
                  ),
                  if (showDot)
                    Positioned(
                      right: -4,
                      top: -2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  if (badgeCount > 0)
                    Positioned(
                      right: -10,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          badgeCount > 99 ? '99+' : '$badgeCount',
                          style: AppTypography.caption.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: color,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
