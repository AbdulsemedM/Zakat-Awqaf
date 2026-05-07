import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../app/settings/app_settings_controller.dart';
import '../../../../../app/theme/app_colors.dart';

class AwqafHomePage extends StatelessWidget {
  const AwqafHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Awqaf Home'),
            Text(
              'Mode: Awqaf',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<AppMode>(
            tooltip: 'Change mode',
            icon: const Icon(Icons.swap_horiz),
            onSelected: (mode) async {
              if (mode != AppMode.zakat) return;
              final controller = context.read<AppSettingsController>();
              await controller.setAppMode(AppMode.zakat);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Switched to Zakat mode')),
              );
              context.go('/');
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: AppMode.zakat,
                child: Text('Switch to Zakat'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.awqafPrimary, AppColors.awqafSecondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sustainable Endowments',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Build long-term impact through Awqaf projects in education, health, and livelihoods.',
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const _AwqafMetricCard(
              title: 'Active Endowments',
              value: '12',
              icon: Icons.account_balance_rounded,
            ),
            const SizedBox(height: 10),
            const _AwqafMetricCard(
              title: 'Communities Served',
              value: '31',
              icon: Icons.groups_2_rounded,
            ),
            const SizedBox(height: 10),
            const _AwqafMetricCard(
              title: 'Projected Annual Yield',
              value: 'ETB 4.8M',
              icon: Icons.trending_up_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class _AwqafMetricCard extends StatelessWidget {
  const _AwqafMetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.awqafPrimary.withValues(alpha: 0.12),
              foregroundColor: AppColors.awqafPrimary,
              child: Icon(icon),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.awqafPrimary,
                      fontWeight: FontWeight.w800,
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
}
