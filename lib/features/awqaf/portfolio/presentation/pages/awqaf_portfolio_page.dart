import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';

class AwqafPortfolioPage extends StatelessWidget {
  const AwqafPortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Awqaf Portfolio')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Portfolio (Mock)',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Track endowment allocations, projected return, and social coverage.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          const _PortfolioCard(
            asset: 'Commercial Building Waqf',
            allocation: '45%',
            yield: 'ETB 2.1M / year',
          ),
          const _PortfolioCard(
            asset: 'Agricultural Land Waqf',
            allocation: '30%',
            yield: 'ETB 1.4M / year',
          ),
          const _PortfolioCard(
            asset: 'Sukuk-Backed Reserve',
            allocation: '25%',
            yield: 'ETB 1.3M / year',
          ),
        ],
      ),
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  const _PortfolioCard({
    required this.asset,
    required this.allocation,
    required this.yield,
  });

  final String asset;
  final String allocation;
  final String yield;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(asset, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.pie_chart_rounded, color: AppColors.awqafPrimary, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Allocation: $allocation',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.awqafPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('Projected Yield: $yield', style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
