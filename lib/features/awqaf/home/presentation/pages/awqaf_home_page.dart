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
        title: const Text('Mejlis Awqaf'),
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
            _PortfolioOverviewHero(theme: theme),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Endowment Spheres',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  'BROWSE ALL',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: AppColors.awqafPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _sphereChips
                  .map((item) => _SphereChip(item: item, theme: theme))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Featured Waqf Projects',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            ..._featuredProjects.map(
              (project) => _FeaturedProjectCard(
                project: project,
                theme: theme,
              ),
            ),
            _MapCtaCard(theme: theme),
            const SizedBox(height: 12),
            _MilestonesCard(theme: theme),
          ],
        ),
      ),
    );
  }
}

class _PortfolioOverviewHero extends StatelessWidget {
  const _PortfolioOverviewHero({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0D2E6F),
            Color(0xFF1D4C9C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PORTFOLIO OVERVIEW',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.textOnPrimary.withValues(alpha: 0.75),
                letterSpacing: 0.9,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Perpetual\nImpact',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.w800,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 10),
            Divider(color: Colors.white.withValues(alpha: 0.25), height: 1),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final metric in _heroMetrics) ...[
                  _HeroMetricRow(metric: metric, theme: theme),
                  if (metric != _heroMetrics.last) const SizedBox(height: 8),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroMetricRow extends StatelessWidget {
  const _HeroMetricRow({required this.metric, required this.theme});

  final _HeroMetric metric;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            metric.label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.textOnPrimary.withValues(alpha: 0.86),
            ),
          ),
        ),
        Text(
          metric.value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _SphereChip extends StatelessWidget {
  const _SphereChip({required this.item, required this.theme});

  final _SphereChipData item;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: item.highlighted
            ? AppColors.awqafSecondary.withValues(alpha: 0.22)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.icon,
            size: 14,
            color: item.highlighted
                ? AppColors.awqafPrimary
                : theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            item.label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: item.highlighted
                  ? AppColors.awqafPrimary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedProjectCard extends StatelessWidget {
  const _FeaturedProjectCard({
    required this.project,
    required this.theme,
  });

  final _FeaturedProject project;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              height: 118,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    project.imageGradientStart,
                    project.imageGradientEnd,
                  ],
                ),
              ),
              child: const Center(
                child: Icon(Icons.account_balance_rounded, size: 36),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: Colors.green.withValues(alpha: 0.15),
                  ),
                  child: Text(
                    project.status,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  project.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  project.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      project.metricLeft,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      project.metricRight,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapCtaCard extends StatelessWidget {
  const _MapCtaCard({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.map_outlined, size: 18, color: AppColors.awqafPrimary),
              const SizedBox(width: 8),
              Text(
                'View National Waqf Map',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Explore the city-level footprint of institutional legacy across the nation.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.awqafPrimary,
            ),
            child: const Text('OPEN INTERACTIVE MAP'),
          ),
        ],
      ),
    );
  }
}

class _MilestonesCard extends StatelessWidget {
  const _MilestonesCard({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Legacy Milestones',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          ..._milestones.map((item) => _MilestoneRow(item: item, theme: theme)),
        ],
      ),
    );
  }
}

class _MilestoneRow extends StatelessWidget {
  const _MilestoneRow({required this.item, required this.theme});

  final _Milestone item;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 7,
                backgroundColor: item.dotColor.withValues(alpha: 0.16),
                child: CircleAvatar(
                  radius: 3,
                  backgroundColor: item.dotColor,
                ),
              ),
              if (item != _milestones.last)
                Container(
                  width: 1.4,
                  height: 26,
                  color: theme.colorScheme.outlineVariant,
                ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.date,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.text,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric {
  const _HeroMetric(this.label, this.value);
  final String label;
  final String value;
}

class _SphereChipData {
  const _SphereChipData({
    required this.label,
    required this.icon,
    this.highlighted = false,
  });

  final String label;
  final IconData icon;
  final bool highlighted;
}

class _FeaturedProject {
  const _FeaturedProject({
    required this.status,
    required this.title,
    required this.description,
    required this.metricLeft,
    required this.metricRight,
    required this.imageGradientStart,
    required this.imageGradientEnd,
  });

  final String status;
  final String title;
  final String description;
  final String metricLeft;
  final String metricRight;
  final Color imageGradientStart;
  final Color imageGradientEnd;
}

class _Milestone {
  const _Milestone({
    required this.date,
    required this.text,
    required this.dotColor,
  });

  final String date;
  final String text;
  final Color dotColor;
}

const _heroMetrics = [
  _HeroMetric('Active Endowments', '12'),
  _HeroMetric('Beneficiaries Served Daily', '4.2k'),
  _HeroMetric('Total Baraka Score', '94/100'),
];

const _sphereChips = [
  _SphereChipData(
    label: 'All Waqfs',
    icon: Icons.water_drop_outlined,
    highlighted: true,
  ),
  _SphereChipData(
    label: 'Education',
    icon: Icons.school_outlined,
  ),
  _SphereChipData(
    label: 'Health',
    icon: Icons.favorite_outline,
  ),
  _SphereChipData(
    label: 'Agriculture',
    icon: Icons.eco_outlined,
  ),
];

const _featuredProjects = [
  _FeaturedProject(
    status: 'PERPETUAL LAND',
    title: 'Al-Hidayah Learning\nComplex',
    description:
        'Providing sustainable higher education for 500 students annually through a 25% endowment.',
    metricLeft: '12.5% RESERVED',
    metricRight: 'Goal: 2.5M OMR',
    imageGradientStart: Color(0xFFD9BFA6),
    imageGradientEnd: Color(0xFF7A8EA5),
  ),
  _FeaturedProject(
    status: 'PRODUCTIVE TREE',
    title: 'Olive Grove Legacy Project',
    description:
        'Sustaining arid-zone farming with proceeds funding local scholarship grants.',
    metricLeft: '78% RESERVED',
    metricRight: 'Goal: 832K BIRR',
    imageGradientStart: Color(0xFFB6A170),
    imageGradientEnd: Color(0xFF6A7F4A),
  ),
];

const _milestones = [
  _Milestone(
    date: 'OCT 24, 2023',
    text: 'Audit complete for Masjid Al-Noor maintenance fund.',
    dotColor: Colors.green,
  ),
  _Milestone(
    date: 'OCT 18, 2023',
    text: 'Contribution of 5,000 OMR to Education Waqf.',
    dotColor: Color(0xFF1D4C9C),
  ),
  _Milestone(
    date: 'PENDING',
    text: 'Legal certification for Salah Orchard Endowment.',
    dotColor: Colors.grey,
  ),
];
