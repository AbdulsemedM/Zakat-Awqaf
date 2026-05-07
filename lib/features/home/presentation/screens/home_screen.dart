import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/settings/app_settings_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/urgent_beneficiary_projects.dart';
import '../../../../core/l10n/l10n.dart';
import '../widgets/home_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final urgentNeeds = homeUrgentNeeds;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.homeCommissionTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Mode: Zakat',
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
              if (mode != AppMode.awqaf) return;
              final controller = context.read<AppSettingsController>();
              await controller.setAppMode(AppMode.awqaf);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Switched to Awqaf mode')),
              );
              context.go('/awqaf');
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: AppMode.awqaf,
                child: Text('Switch to Awqaf'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.homeGreeting,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 14),
            TotalCollectedHeroCard(theme: theme),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.textOnPrimary,
                ),
                onPressed: () => context.go('/beneficiary-registration'),
                icon: const Icon(Icons.person_add_alt_1),
                label: Text(l10n.registerAcceptZakat),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.urgentBeneficiaryNeeds,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => context.go('/beneficiary-registration'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Text(
                        l10n.viewAll,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < urgentNeeds.length; i++) ...[
                    UrgentNeedCard(model: urgentNeeds[i]),
                    if (i != urgentNeeds.length - 1) const SizedBox(width: 10),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            ZakatReminderCard(theme: theme),
            const SizedBox(height: 16),
            AboutCommissionSection(theme: theme),
            const SizedBox(height: 14),
            DonateSadaqahCard(theme: theme),
            const SizedBox(height: 16),
            // Row(
            //   children: [
            //     Expanded(
            //       child: FilledButton.icon(
            //         onPressed: () => context.go('/calculator'),
            //         icon: const Icon(Icons.calculate),
            //         label: const Text('Calculate'),
            //       ),
            //     ),
            //     const SizedBox(width: 10),
            //     Expanded(
            //       child: OutlinedButton.icon(
            //         onPressed: () => context.go('/awqaf'),
            //         icon: const Icon(Icons.account_balance),
            //         label: const Text('Awqaf'),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
