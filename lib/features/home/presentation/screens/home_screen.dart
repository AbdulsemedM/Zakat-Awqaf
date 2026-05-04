import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/home_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final urgentNeeds = homeUrgentNeeds;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Zakat and Awqaf Commission',
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              child: Icon(
                Icons.person,
                size: 18,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Assalamu\'alaikum',
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
                onPressed: () => context.go('/beneficiary-registration'),
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Register to Accept Zakat'),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Urgent Beneficiary Needs',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 96,
                  child: TextButton(
                    onPressed: () => context.go('/beneficiary-registration'),
                    child: const Text('View All'),
                  ),
                ),
              ],
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
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => context.go('/calculator'),
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calculate'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/awqaf'),
                    icon: const Icon(Icons.account_balance),
                    label: const Text('Awqaf'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
