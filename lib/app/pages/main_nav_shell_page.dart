import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../settings/app_settings_controller.dart';
import '../../core/l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/zakat_themed.dart';

class MainNavShellPage extends StatelessWidget {
  const MainNavShellPage({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final appMode = context.watch<AppSettingsController>().appMode;
    final isAwqaf = appMode == AppMode.awqaf;

    return Scaffold(
      body: isAwqaf
          ? navigationShell
          : ZakatThemed(child: navigationShell),
      bottomNavigationBar: isAwqaf
          ? _AwqafBottomNav(
              navigationShell: navigationShell,
              appMode: appMode,
            )
          : _ZakatBottomNav(
              navigationShell: navigationShell,
              appMode: appMode,
            ),
    );
  }
}

class _ZakatBottomNav extends StatelessWidget {
  const _ZakatBottomNav({
    required this.navigationShell,
    required this.appMode,
  });

  final StatefulNavigationShell navigationShell;
  final AppMode appMode;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selectedIndex = navigationShell.currentIndex % 4;
    final items = <_NavItem>[
      _NavItem(
        label: l10n.navHome,
        icon: TablerIcons.home,
      ),
      _NavItem(
        label: l10n.navCalculator,
        icon: TablerIcons.calculator,
      ),
      _NavItem(
        label: l10n.navImpact,
        icon: TablerIcons.trending_up,
      ),
      _NavItem(
        label: l10n.navProfile,
        icon: TablerIcons.user,
      ),
    ];

    return Container(
      color: AppColors.forestGreen,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _ZakatNavButton(
                    item: items[i],
                    selected: selectedIndex == i,
                    onTap: () => context.go(
                      _destinationFor(itemIndex: i, appMode: appMode),
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

class _ZakatNavButton extends StatelessWidget {
  const _ZakatNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? AppColors.warmGold : AppColors.mintGreenMuted;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: AppTypography.label(
                fontSize: 9,
                color: color,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AwqafBottomNav extends StatelessWidget {
  const _AwqafBottomNav({
    required this.navigationShell,
    required this.appMode,
  });

  final StatefulNavigationShell navigationShell;
  final AppMode appMode;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final selectedIndex = navigationShell.currentIndex % 4;
    final items = <_NavItem>[
      const _NavItem(label: 'Home', icon: Icons.home_rounded),
      const _NavItem(label: 'Create', icon: Icons.add_circle_rounded),
      const _NavItem(label: 'Portfolio', icon: Icons.workspaces_rounded),
      const _NavItem(label: 'Profile', icon: Icons.person_rounded),
    ];

    return SafeArea(
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
                      child: _AwqafNavButton(
                        item: items[i],
                        selected: selectedIndex == i,
                        textTheme: textTheme,
                        onTap: () => context.go(
                          _destinationFor(itemIndex: i, appMode: appMode),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AwqafNavButton extends StatelessWidget {
  const _AwqafNavButton({
    required this.item,
    required this.selected,
    required this.textTheme,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final TextTheme textTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selectedFgColor = AppColors.awqafPrimary;
    final unselectedFgColor = AppColors.awqafSecondary;
    final selectedBgColor = AppColors.awqafSecondary.withValues(alpha: 0.34);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: selected ? selectedBgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              color: selected ? selectedFgColor : unselectedFgColor,
              size: 21,
            ),
            const SizedBox(height: 1),
            Text(
              item.label,
              style: (textTheme.labelSmall ?? const TextStyle(fontSize: 11))
                  .copyWith(
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

class _NavItem {
  const _NavItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

String _destinationFor({
  required int itemIndex,
  required AppMode appMode,
}) {
  if (appMode == AppMode.awqaf) {
    return switch (itemIndex) {
      0 => '/awqaf',
      1 => '/awqaf/create',
      2 => '/awqaf/portfolio',
      3 => '/awqaf/profile',
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
