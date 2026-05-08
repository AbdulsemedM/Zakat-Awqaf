import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../settings/app_settings_controller.dart';
import '../../core/l10n/l10n.dart';
import '../theme/app_colors.dart';

class MainNavShellPage extends StatelessWidget {
  const MainNavShellPage({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final appMode = context.watch<AppSettingsController>().appMode;
    final isAwqaf = appMode == AppMode.awqaf;
    final selectedIndex = navigationShell.currentIndex % 4;
    final selectedBgColor = isAwqaf
        ? AppColors.awqafSecondary.withValues(alpha: 0.34)
        : AppColors.primary.withValues(alpha: 0.16);
    final selectedFgColor = isAwqaf
        ? AppColors.awqafPrimary
        : AppColors.primary;
    final unselectedFgColor = isAwqaf
        ? AppColors.awqafSecondary
        : AppColors.primary.withValues(alpha: 0.66);
    final items = <_NavItem>[
      _NavItem(
        label: l10n.navHome,
        activeIcon: Icons.home_rounded,
        inactiveIcon: Icons.home_outlined,
      ),
      _NavItem(
        label: isAwqaf ? 'Create' : l10n.navCalculator,
        activeIcon: isAwqaf ? Icons.add_circle_rounded : Icons.calculate_rounded,
        inactiveIcon: isAwqaf ? Icons.add_circle_outline_rounded : Icons.calculate_outlined,
      ),
      _NavItem(
        label: l10n.navImpact,
        activeIcon: Icons.auto_graph_rounded,
        inactiveIcon: Icons.auto_graph_outlined,
      ),
      _NavItem(
        label: isAwqaf ? 'Portfolio' : l10n.navProfile,
        activeIcon: isAwqaf ? Icons.workspaces_rounded : Icons.person_rounded,
        inactiveIcon: isAwqaf ? Icons.workspaces_outline : Icons.person_outline_rounded,
      ),
    ];

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: scheme.surface.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.shadow.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    for (var i = 0; i < items.length; i++)
                      Expanded(
                        child: _NavButton(
                          item: items[i],
                          selected: selectedIndex == i,
                          textTheme: textTheme,
                          selectedBgColor: selectedBgColor,
                          selectedFgColor: selectedFgColor,
                          unselectedFgColor: unselectedFgColor,
                          onTap: () => context.go(
                            _destinationFor(
                              itemIndex: i,
                              appMode: appMode,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _destinationFor({
    required int itemIndex,
    required AppMode appMode,
  }) {
    if (appMode == AppMode.awqaf) {
      return switch (itemIndex) {
        0 => '/awqaf',
        1 => '/awqaf/create',
        2 => '/awqaf/impact',
        3 => '/awqaf/portfolio',
        _ => '/awqaf',
      };
    }
    return switch (itemIndex) {
      0 => '/',
      1 => '/calculator',
      2 => '/impact',
      3 => '/profile',
      _ => '/',
    };
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.activeIcon,
    required this.inactiveIcon,
  });

  final String label;
  final IconData activeIcon;
  final IconData inactiveIcon;
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.textTheme,
    required this.selectedBgColor,
    required this.selectedFgColor,
    required this.unselectedFgColor,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final TextTheme textTheme;
  final Color selectedBgColor;
  final Color selectedFgColor;
  final Color unselectedFgColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? selectedBgColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? item.activeIcon : item.inactiveIcon,
              color: selected ? selectedFgColor : unselectedFgColor,
              size: 21,
            ),
            const SizedBox(height: 1),
            Text(
              item.label,
              style: (textTheme.labelSmall ?? const TextStyle(fontSize: 11)).copyWith(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? selectedFgColor : unselectedFgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
