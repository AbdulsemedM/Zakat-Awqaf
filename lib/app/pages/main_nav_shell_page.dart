import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class MainNavShellPage extends StatelessWidget {
  const MainNavShellPage({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final tabs = <PersistentRouterTabConfig>[
      PersistentRouterTabConfig(
        item: ItemConfig(
          icon: const Icon(Icons.home_rounded),
          inactiveIcon: const Icon(Icons.home_outlined),
          title: 'Home',
          activeForegroundColor: scheme.primary,
          inactiveForegroundColor: scheme.onSurfaceVariant,
          activeColorSecondary: scheme.primaryContainer,
          textStyle: textTheme.labelMedium ?? const TextStyle(fontSize: 12),
        ),
      ),
      PersistentRouterTabConfig(
        item: ItemConfig(
          icon: const Icon(Icons.calculate_rounded),
          inactiveIcon: const Icon(Icons.calculate_outlined),
          title: 'Calculator',
          activeForegroundColor: scheme.primary,
          inactiveForegroundColor: scheme.onSurfaceVariant,
          activeColorSecondary: scheme.primaryContainer,
          textStyle: textTheme.labelMedium ?? const TextStyle(fontSize: 12),
        ),
      ),
      PersistentRouterTabConfig(
        item: ItemConfig(
          icon: const Icon(Icons.auto_graph_rounded),
          inactiveIcon: const Icon(Icons.auto_graph_outlined),
          title: 'Impact',
          activeForegroundColor: scheme.secondary,
          inactiveForegroundColor: scheme.onSurfaceVariant,
          activeColorSecondary: scheme.secondaryContainer,
          textStyle: textTheme.labelMedium ?? const TextStyle(fontSize: 12),
        ),
      ),
      PersistentRouterTabConfig(
        item: ItemConfig(
          icon: const Icon(Icons.person_rounded),
          inactiveIcon: const Icon(Icons.person_outline_rounded),
          title: 'Profile',
          activeForegroundColor: scheme.secondary,
          inactiveForegroundColor: scheme.onSurfaceVariant,
          activeColorSecondary: scheme.secondaryContainer,
          textStyle: textTheme.labelMedium ?? const TextStyle(fontSize: 12),
        ),
      ),
    ];

    return PersistentTabView.router(
      tabs: tabs,
      navigationShell: navigationShell,
      navBarBuilder: (navBarConfig) => Style8BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: scheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
      ),
    );
  }
}
