import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/primary_hero.dart';
import '../../../../core/utils/number_format.dart';
import '../../bloc/impact_bloc.dart';
import '../../bloc/impact_event.dart';
import '../../bloc/impact_state.dart';
import '../../data/models/impact_model.dart';

class ImpactPage extends StatelessWidget {
  const ImpactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('National Impact'),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 14,
              child: Icon(Icons.person, size: 16),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ImpactBloc, ImpactState>(
        builder: (context, state) {
          return switch (state) {
            ImpactInitial() || ImpactLoading() =>
              const Center(child: CircularProgressIndicator()),
            ImpactError(:final message) => _ErrorView(message: message),
            ImpactLoaded(:final model) => RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<ImpactBloc>()
                      .add(const ImpactRefreshRequested());
                },
                child: _ImpactContent(model: model),
              ),
          };
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              'Could not load national impact',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context
                  .read<ImpactBloc>()
                  .add(const ImpactRefreshRequested()),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImpactContent extends StatelessWidget {
  const _ImpactContent({required this.model});

  final ImpactModel model;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LiveImpactCard(theme: theme, model: model),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Text(
                  'Geographic Reach',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  model.regionName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _GeographicCard(theme: theme, model: model),
          const SizedBox(height: 14),
          Text(
            'Baraka Stories',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          _StoriesRow(stories: model.barakaStories),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Text(
                  'Active Awqaf Projects',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All projects coming soon')),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Text(
                      'View All',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          for (var i = 0; i < model.awqafProjects.length; i++) ...[
            _ProjectCard(theme: theme, project: model.awqafProjects[i]),
            if (i != model.awqafProjects.length - 1)
              const SizedBox(height: 12),
          ],
          const SizedBox(height: 14),
          _PersonalBarakaCard(theme: theme),
        ],
      ),
    );
  }
}

class _LiveImpactCard extends StatelessWidget {
  const _LiveImpactCard({required this.theme, required this.model});

  final ThemeData theme;
  final ImpactModel model;

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: PrimaryHero.gradient(scheme),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _PulsingDot(),
                    const SizedBox(width: 6),
                    Text(
                      'LIVE IMPACT STREAM',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.onSecondary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Icon(
                Icons.auto_graph_rounded,
                size: 18,
                color: AppColors.secondary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'DISTRIBUTED FUNDS',
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.textOnPrimary.withValues(alpha: 0.84),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${formatThousands(model.distributedFundsEtb)} ETB',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _MetricColumn(
                title: 'LIVES TOUCHED',
                value: formatThousands(model.livesTouched),
                theme: theme,
              ),
              const SizedBox(width: 26),
              _MetricColumn(
                title: 'ACTIVE PROJECTS',
                value: formatThousands(model.activeProjects),
                theme: theme,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _scale = Tween<double>(begin: 0.6, end: 2.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _opacity = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 12,
      height: 12,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Opacity(
                opacity: _opacity.value,
                child: Transform.scale(
                  scale: _scale.value,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  const _MetricColumn({
    required this.title,
    required this.value,
    required this.theme,
  });

  final String title;
  final String value;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.textOnPrimary.withValues(alpha: 0.82),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _GeographicCard extends StatelessWidget {
  const _GeographicCard({required this.theme, required this.model});

  final ThemeData theme;
  final ImpactModel model;

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                const mapHeight = 170.0;
                final width = constraints.maxWidth;
                return Container(
                  width: double.infinity,
                  height: mapHeight,
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: scheme.outlineVariant),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 10,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.28),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            model.regionName,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Icon(
                          Icons.map_outlined,
                          size: 88,
                          color: scheme.outline.withValues(alpha: 0.4),
                        ),
                      ),
                      for (final region in model.regions)
                        _RegionPin(
                          region: region,
                          left: region.xPercent * width - 24,
                          top: region.yPercent * mapHeight - 24,
                          color: scheme.primary,
                          labelColor: scheme.onSurface,
                        ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  'Tap a region to see local impact',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
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

class _RegionPin extends StatelessWidget {
  const _RegionPin({
    required this.region,
    required this.left,
    required this.top,
    required this.color,
    required this.labelColor,
  });

  final MapRegion region;
  final double left;
  final double top;
  final Color color;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${region.name} impact coming soon')),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            if (region.isLabeled) ...[
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 1,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  region.name,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: labelColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StoriesRow extends StatelessWidget {
  const _StoriesRow({required this.stories});

  final List<BarakaStory> stories;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final story in stories)
          Expanded(child: _StoryAvatar(story: story)),
      ],
    );
  }
}

class _StoryAvatar extends StatelessWidget {
  const _StoryAvatar({required this.story});

  final BarakaStory story;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${story.name} story coming soon')),
        );
      },
      borderRadius: BorderRadius.circular(40),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.shade300,
                    Colors.amber.shade600,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        story.accent,
                        Color.lerp(story.accent, Colors.black, 0.3) ??
                            story.accent,
                      ],
                    ),
                    image: story.imageAsset != null
                        ? DecorationImage(
                            image: AssetImage(story.imageAsset!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: story.imageAsset == null
                      ? Icon(
                          story.fallbackIcon,
                          color: Colors.white,
                          size: 26,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              story.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.theme, required this.project});

  final ThemeData theme;
  final AwqafProject project;

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    final statusColor = _statusColor(project.status, scheme);
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${project.title} details coming soon'),
            ),
          );
        },
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 110,
              decoration: BoxDecoration(
                gradient: project.imageAsset == null
                    ? PrimaryHero.gradient(scheme)
                    : null,
                image: project.imageAsset != null
                    ? DecorationImage(
                        image: AssetImage(project.imageAsset!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  if (project.imageAsset == null)
                    Positioned(
                      left: 12,
                      bottom: 10,
                      child: Icon(
                        _statusIcon(project.status),
                        size: 36,
                        color: AppColors.textOnPrimary.withValues(alpha: 0.65),
                      ),
                    ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        project.status.label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: project.status == AwqafStatus.construction
                              ? AppColors.onSecondary
                              : project.status == AwqafStatus.completed
                                  ? scheme.onSurface
                                  : AppColors.textOnPrimary,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${(project.fundedPercent * 100).toStringAsFixed(0)}% Funded',
                        style: theme.textTheme.bodySmall,
                      ),
                      const Spacer(),
                      Text(
                        '${formatThousands(project.etbLeft)} ETB Left',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: project.fundedPercent,
                      minHeight: 6,
                      color: scheme.primary,
                      backgroundColor: scheme.surfaceContainerHighest,
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

  Color _statusColor(AwqafStatus status, ColorScheme scheme) {
    switch (status) {
      case AwqafStatus.construction:
        return AppColors.secondary;
      case AwqafStatus.planning:
        return Colors.blue.shade500;
      case AwqafStatus.completed:
        return scheme.outline;
    }
  }

  IconData _statusIcon(AwqafStatus status) {
    switch (status) {
      case AwqafStatus.construction:
        return Icons.construction_rounded;
      case AwqafStatus.planning:
        return Icons.architecture_rounded;
      case AwqafStatus.completed:
        return Icons.check_circle_rounded;
    }
  }
}

class _PersonalBarakaCard extends StatelessWidget {
  const _PersonalBarakaCard({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFF4DEB9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'See Your Personal Baraka',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Track every cent of your stewardship.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => context.go('/profile'),
            icon: const Icon(Icons.show_chart_rounded, size: 18),
            label: const Text('View My History'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(170, 42),
            ),
          ),
        ],
      ),
    );
  }
}
