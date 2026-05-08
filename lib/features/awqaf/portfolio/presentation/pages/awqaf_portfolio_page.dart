import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';

class AwqafPortfolioPage extends StatelessWidget {
  const AwqafPortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Mejlis Awqaf')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'My Waqf\nPortfolio',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'A perpetual legacy of social finance. Manage your endowments and witness the real-time institutional impact of your generational contributions.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          _KpiCard(theme: theme),
          const SizedBox(height: 10),
          _AggregateImpactCard(theme: theme),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                'Active Endowments',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              _MiniFilterChip(label: "DON'T DATE", theme: theme),
              const SizedBox(width: 6),
              _MiniFilterChip(label: 'FILTER IMPACT', theme: theme),
            ],
          ),
          const SizedBox(height: 10),
          ..._sampleEndowments.map(
            (e) => _PortfolioCard(
              data: e,
              theme: theme,
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          Text(
            'TOTAL ASSET VALUE',
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 0.9,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$1,240,500',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  '+4.2%',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Diversified across 8 institutional projects.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _AggregateImpactCard extends StatelessWidget {
  const _AggregateImpactCard({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            AppColors.awqafPrimary,
            AppColors.awqafPrimary.withValues(alpha: 0.88),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AGGREGATE DAILY IMPACT',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.textOnPrimary.withValues(alpha: 0.8),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _ImpactMetric(
                  label: 'Students Supported',
                  value: '14,200',
                  theme: theme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ImpactMetric(
                  label: 'Liters of Clean Water',
                  value: '450K',
                  theme: theme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImpactMetric extends StatelessWidget {
  const _ImpactMetric({
    required this.label,
    required this.value,
    required this.theme,
  });

  final String label;
  final String value;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.textOnPrimary.withValues(alpha: 0.82),
          ),
        ),
      ],
    );
  }
}

class _MiniFilterChip extends StatelessWidget {
  const _MiniFilterChip({required this.label, required this.theme});

  final String label;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  const _PortfolioCard({
    required this.data,
    required this.theme,
  });

  final _EndowmentCardData data;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              height: 128,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.surfaceContainerHighest,
                    theme.colorScheme.surfaceContainerHigh,
                  ],
                ),
              ),
              child: const Center(
                child: Icon(Icons.apartment_rounded, size: 44),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.verified_rounded, size: 14, color: Colors.green.shade700),
                    const SizedBox(width: 4),
                    Text(
                      data.status,
                      style: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 0.7,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      data.contributed,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  data.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.locationType,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _MetricLine(
                        label: data.metric1Label,
                        value: data.metric1Value,
                        theme: theme,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MetricLine(
                        label: data.metric2Label,
                        value: data.metric2Value,
                        theme: theme,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _MetricLine(
                  label: data.impactLabel,
                  value: data.impactValue,
                  theme: theme,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.event_note_outlined, size: 15, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      data.deedMeta,
                      style: theme.textTheme.labelSmall,
                    ),
                    const Spacer(),
                    Text(
                      'LIVE ASSET REPORT  ->',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.awqafPrimary,
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

class _MetricLine extends StatelessWidget {
  const _MetricLine({
    required this.label,
    required this.value,
    required this.theme,
  });

  final String label;
  final String value;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _EndowmentCardData {
  const _EndowmentCardData({
    required this.status,
    required this.title,
    required this.locationType,
    required this.contributed,
    required this.metric1Label,
    required this.metric1Value,
    required this.metric2Label,
    required this.metric2Value,
    required this.impactLabel,
    required this.impactValue,
    required this.deedMeta,
  });

  final String status;
  final String title;
  final String locationType;
  final String contributed;
  final String metric1Label;
  final String metric1Value;
  final String metric2Label;
  final String metric2Value;
  final String impactLabel;
  final String impactValue;
  final String deedMeta;
}

const List<_EndowmentCardData> _sampleEndowments = [
  _EndowmentCardData(
    status: 'ACTIVE DEED',
    title: 'Al-Hidayah\nEducational Complex',
    locationType: 'Zanzibar, TZ • Infrastructure Waqf',
    contributed: '\$450,000\nCONTRIBUTED',
    metric1Label: 'RENTAL INCOME',
    metric1Value: '\$2,450 / mo',
    metric2Label: 'MAINTENANCE',
    metric2Value: 'Optimal',
    impactLabel: "TODAY'S IMPACT",
    impactValue: '1,240 students attended today',
    deedMeta: 'Deed issued: Jan 2023',
  ),
  _EndowmentCardData(
    status: 'STABILIZING',
    title: 'Noble Residences\nEndowment',
    locationType: 'London, UK • Commercial Waqf',
    contributed: '\$790,500\nCONTRIBUTED',
    metric1Label: 'RENTAL INCOME',
    metric1Value: '\$5,100 / mo',
    metric2Label: 'OCCUPANCY',
    metric2Value: '94%',
    impactLabel: "TODAY'S IMPACT",
    impactValue: 'Funding 15 scholarships today',
    deedMeta: 'Deed issued: Jan 2023',
  ),
];
