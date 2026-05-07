import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';

class AwqafImpactPage extends StatelessWidget {
  const AwqafImpactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Awqaf Impact')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Awqaf Impact (Mock)',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          const _ImpactTile(
            title: 'Education Access',
            description: '2,450 students supported with annual scholarships.',
            icon: Icons.school_rounded,
          ),
          const _ImpactTile(
            title: 'Healthcare Support',
            description: '18 rural clinics received recurring medicine grants.',
            icon: Icons.local_hospital_rounded,
          ),
          const _ImpactTile(
            title: 'Livelihood Projects',
            description: '620 households benefit from micro-enterprise tooling.',
            icon: Icons.handshake_rounded,
          ),
        ],
      ),
    );
  }
}

class _ImpactTile extends StatelessWidget {
  const _ImpactTile({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.awqafSecondary.withValues(alpha: 0.2),
          foregroundColor: AppColors.awqafPrimary,
          child: Icon(icon),
        ),
        title: Text(title),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(description, style: theme.textTheme.bodySmall),
        ),
      ),
    );
  }
}
