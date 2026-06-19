part of '../pages/impact_page.dart';

class _LiveImpactCard extends StatelessWidget {
  const _LiveImpactCard({required this.theme, required this.model});

  final ThemeData theme;
  final ImpactModel model;

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.1),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned.fill(
            child: BrandAtmosphereBackground(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
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
                            context.l10n.impactLiveImpactStream,
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
                const SizedBox(height: 16),
                Text(
                  context.l10n.impactDistributedFunds,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.84),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.impactEtbAmount(formatThousands(model.distributedFundsEtb)),
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                Divider(
                  color: AppColors.textOnPrimary.withValues(alpha: 0.25),
                  height: 1,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _MetricColumn(
                      title: context.l10n.impactLivesTouched,
                      value: formatThousands(model.livesTouched),
                      theme: theme,
                    ),
                    const SizedBox(width: 26),
                    _MetricColumn(
                      title: context.l10n.impactActiveProjects,
                      value: formatThousands(model.activeProjects),
                      theme: theme,
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
    return _ImpactMapCard(theme: theme, model: model);
  }
}

class _ImpactMapCard extends StatefulWidget {
  const _ImpactMapCard({required this.theme, required this.model});

  final ThemeData theme;
  final ImpactModel model;

  @override
  State<_ImpactMapCard> createState() => _ImpactMapCardState();
}

class _ImpactMapCardState extends State<_ImpactMapCard> {
  late MapRegion _selectedRegion;

  @override
  void initState() {
    super.initState();
    _selectedRegion = widget.model.regions.firstWhere(
      (region) => region.isLabeled,
      orElse: () => widget.model.regions.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final scheme = theme.colorScheme;
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 210,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    FlutterMap(
                      options: const MapOptions(
                        initialCenter: LatLng(9.145, 40.4897),
                        initialZoom: 5.5,
                        minZoom: 4.5,
                        maxZoom: 13,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'mejlis_digital_hub',
                        ),
                        MarkerLayer(
                          markers: [
                            for (final region in widget.model.regions)
                              Marker(
                                point: LatLng(region.latitude, region.longitude),
                                width: 48,
                                height: 48,
                                child: _MapPin(
                                  active: _selectedRegion == region,
                                  onTap: () {
                                    setState(() => _selectedRegion = region);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          context.l10n.impactRegionImpactComingSoon(region.name),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.surface.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          _selectedRegion.name,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                  context.l10n.impactTapRegionHint,
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

class _MapPin extends StatelessWidget {
  const _MapPin({required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: active ? 16 : 12,
          height: active ? 16 : 12,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 10,
              ),
            ],
          ),
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
          SnackBar(content: Text(context.l10n.impactStoryComingSoon(story.name))),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.impactProjectDetailsComingSoon(project.title)),
            ),
          );
        },
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 120,
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
                        context.l10n.impactPercentFunded((project.fundedPercent * 100).toStringAsFixed(0)),
                        style: theme.textTheme.bodySmall,
                      ),
                      const Spacer(),
                      Text(
                        context.l10n.impactEtbLeft(formatThousands(project.etbLeft)),
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
        borderRadius: BorderRadius.circular(24),
        color: AppColors.secondary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.impactSeeYourPersonalBaraka,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textOnPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.impactTrackStewardship,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSecondary,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => context.go('/profile'),
            icon: const Icon(Icons.show_chart_rounded, size: 18),
            label: Text(context.l10n.impactViewMyHistory),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(170, 42),
            ),
          ),
        ],
      ),
    );
  }
}
