part of '../pages/impact_page.dart';

/// Emerald header: title row plus the live funds summary. [model] is null
/// while loading or on error, in which case only the title row is shown.
class _ImpactHeader extends StatelessWidget {
  const _ImpactHeader({required this.model});

  final ImpactModel? model;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final m = model;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      child: DecoratedBox(
        decoration: const BoxDecoration(gradient: PrimaryHero.zakatHeroGradient),
        child: Stack(
          children: [
            const IslamicPatternLayer(opacity: 0.13, fadeTo: Alignment.bottomLeft),
            const Positioned(
              top: 70,
              right: -36,
              child: CrescentOrnament(size: 150, opacity: 0.14),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const AppBarBrandLeading(height: 30),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.impactNationalImpact,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.displayHeading(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: l10n.impactNotifications,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.10),
                            side: BorderSide(
                              color: AppColors.goldLight.withValues(alpha: 0.45),
                            ),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.profileNoNewNotifications)),
                            );
                          },
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.goldLight,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.only(start: 4, top: 4),
                      child: GoldOrnamentDivider(width: 56),
                    ),
                    if (m != null) ...[
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 4),
                        child: _LiveFundsSummary(model: m),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveFundsSummary extends StatelessWidget {
  const _LiveFundsSummary({required this.model});

  final ImpactModel model;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.emeraldNight.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.warmGold.withValues(alpha: 0.8)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _PulsingDot(),
              const SizedBox(width: 8),
              Text(
                l10n.impactLiveImpactStream,
                style: AppTypography.label(
                  fontSize: 11,
                  color: AppColors.goldLight,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          l10n.impactDistributedFunds.toUpperCase(),
          style: AppTypography.label(
            fontSize: 11,
            color: AppColors.mintGreen,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.impactEtbAmount(formatThousands(model.distributedFundsEtb)),
          style: AppTypography.body(
            fontSize: 34,
            color: AppColors.goldLight,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _MetricPanel(
                icon: Icons.groups_2_rounded,
                title: l10n.impactLivesTouched,
                value: formatThousands(model.livesTouched),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricPanel(
                icon: Icons.account_balance_rounded,
                title: l10n.impactActiveProjects,
                value: formatThousands(model.activeProjects),
              ),
            ),
          ],
        ),
      ],
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
    const dot = DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.goldLight,
      ),
      child: SizedBox(width: 8, height: 8),
    );
    return SizedBox(
      width: 12,
      height: 12,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Opacity(
              opacity: _opacity.value,
              child: Transform.scale(scale: _scale.value, child: child),
            ),
            child: dot,
          ),
          dot,
        ],
      ),
    );
  }
}

class _MetricPanel extends StatelessWidget {
  const _MetricPanel({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.mintGreen),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.label(
                    fontSize: 10,
                    color: AppColors.mintGreen,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.body(
              fontSize: 22,
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _RegionChip extends StatelessWidget {
  const _RegionChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.tagGoldBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.tagGoldBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.place_outlined, size: 14, color: AppColors.tagGoldText),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.body(
              fontSize: 12,
              color: AppColors.tagGoldText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImpactMapCard extends StatefulWidget {
  const _ImpactMapCard({required this.model});

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
    final scheme = Theme.of(context).colorScheme;
    return PremiumCard(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 220,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
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
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.forestGreen.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppColors.goldLight.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Text(
                        _selectedRegion.name,
                        style: AppTypography.body(
                          fontSize: 12,
                          color: AppColors.goldLight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 10, 6, 4),
            child: Row(
              children: [
                Icon(Icons.touch_app_outlined, size: 16, color: scheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    context.l10n.impactTapRegionHint,
                    style: AppTypography.body(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                    ),
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
          width: active ? 18 : 13,
          height: active ? 18 : 13,
          decoration: BoxDecoration(
            color: active ? AppColors.warmGold : AppColors.forestLight,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: (active ? AppColors.warmGold : AppColors.forestLight)
                    .withValues(alpha: 0.45),
                blurRadius: 12,
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
        for (final story in stories) Expanded(child: _StoryAvatar(story: story)),
      ],
    );
  }
}

class _StoryAvatar extends StatelessWidget {
  const _StoryAvatar({required this.story});

  final BarakaStory story;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
              width: 72,
              height: 72,
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    AppColors.goldLight,
                    AppColors.warmGold,
                    AppColors.goldDeep,
                    AppColors.goldLight,
                  ],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.surface,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.forestLight, AppColors.forestGreen],
                    ),
                    image: story.imageAsset != null
                        ? DecorationImage(
                            image: AssetImage(story.imageAsset!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: story.imageAsset == null
                      ? Icon(story.fallbackIcon, color: AppColors.goldLight, size: 26)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              story.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.body(
                fontSize: 12,
                color: scheme.onSurface,
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
  const _ProjectCard({required this.project});

  final AwqafProject project;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (statusBg, statusFg) = _statusColors(project.status, scheme);
    final percent = (project.fundedPercent * 100).toStringAsFixed(0);
    return PremiumCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.impactProjectDetailsComingSoon(project.title)),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 124,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (project.imageAsset != null)
                        Image.asset(project.imageAsset!, fit: BoxFit.cover)
                      else ...[
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: PrimaryHero.zakatHeroGradient,
                          ),
                        ),
                        const IslamicPatternLayer(
                          opacity: 0.18,
                          cell: 32,
                          fadeTo: Alignment.bottomLeft,
                        ),
                        Positioned(
                          left: 16,
                          bottom: 14,
                          child: Icon(
                            _statusIcon(project.status),
                            size: 38,
                            color: AppColors.goldLight.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                      Positioned(
                        right: 12,
                        top: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            project.status.label,
                            style: AppTypography.label(
                              fontSize: 11,
                              color: statusFg,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.title,
                        style: AppTypography.displayHeading(
                          fontSize: 17,
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            context.l10n.impactPercentFunded(percent),
                            style: AppTypography.body(
                              fontSize: 12,
                              color: AppColors.goldDeep,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            context.l10n.impactEtbLeft(formatThousands(project.etbLeft)),
                            style: AppTypography.body(
                              fontSize: 12,
                              color: scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: project.fundedPercent,
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  (Color, Color) _statusColors(AwqafStatus status, ColorScheme scheme) {
    switch (status) {
      case AwqafStatus.construction:
        return (AppColors.warmGold, AppColors.onSecondary);
      case AwqafStatus.planning:
        return (AppColors.waterGradientEnd, AppColors.textOnPrimary);
      case AwqafStatus.completed:
        return (AppColors.tagGreenBg, AppColors.tagGreenText);
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
  const _PersonalBarakaCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: DecoratedBox(
        decoration: const BoxDecoration(gradient: PrimaryHero.sadaqahGradient),
        child: Stack(
          children: [
            const IslamicPatternLayer(
              color: AppColors.emeraldNight,
              opacity: 0.10,
              cell: 34,
              fadeTo: Alignment.bottomRight,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.impactSeeYourPersonalBaraka,
                    style: AppTypography.displayHeading(
                      fontSize: 21,
                      color: AppColors.emeraldNight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.impactTrackStewardship,
                    style: AppTypography.body(
                      fontSize: 13,
                      color: AppColors.emeraldNight.withValues(alpha: 0.78),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => context.go('/profile'),
                    icon: const Icon(Icons.show_chart_rounded, size: 18),
                    label: Text(l10n.impactViewMyHistory),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.forestGreen,
                      foregroundColor: AppColors.goldLight,
                      minimumSize: const Size(180, 46),
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
