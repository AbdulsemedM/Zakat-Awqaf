import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';

class AwqafCreatePage extends StatelessWidget {
  const AwqafCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Awqaf Create')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Create Endowment (Mock)',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Prepare a new Waqf campaign with objective, asset type, and beneficiary focus.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          const _CreateFieldTile(
            label: 'Waqf Name',
            value: 'Green Schools Endowment',
          ),
          const _CreateFieldTile(
            label: 'Endowment Type',
            value: 'Income-generating property',
          ),
          const _CreateFieldTile(
            label: 'Target Capital',
            value: 'ETB 10,000,000',
          ),
          const _CreateFieldTile(
            label: 'Primary Beneficiaries',
            value: 'Orphan students in rural areas',
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: AppColors.awqafPrimary),
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline_rounded),
            label: const Text('Publish Draft'),
          ),
        ],
      ),
    );
  }
}

class _CreateFieldTile extends StatelessWidget {
  const _CreateFieldTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(label),
        subtitle: Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
