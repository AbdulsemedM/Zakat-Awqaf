part of '../pages/impact_page.dart';

/// Emerald header: title row plus the funds summary. [summary] is null
/// while loading or on error, in which case only the title row is shown.
class _ImpactHeader extends StatelessWidget {
  const _ImpactHeader({required this.summary});

  final ImpactSummary? summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final m = summary;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: PrimaryHero.zakatHeroGradient,
        ),
        child: Stack(
          children: [
            const IslamicPatternLayer(
              opacity: 0.13,
              fadeTo: Alignment.bottomLeft,
            ),
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
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.10,
                            ),
                            side: BorderSide(
                              color: AppColors.goldLight.withValues(
                                alpha: 0.45,
                              ),
                            ),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.profileNoNewNotifications),
                              ),
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
                        child: _LiveFundsSummary(summary: m),
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

/// Live / as-of pill, distributed funds and the two metric panels. Each
/// figure is hidden while it is `null`.
class _LiveFundsSummary extends StatelessWidget {
  const _LiveFundsSummary({required this.summary});

  final ImpactSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final asOf = summary.asOf;
    final live = summary.isLive(DateTime.now());
    final funds = summary.distributedFundsEtb;
    final lives = summary.livesTouched;
    final projects = summary.activeProjects;
    final panels = [
      if (lives != null)
        _MetricPanel(
          icon: Icons.groups_2_rounded,
          title: l10n.impactLivesTouched,
          value: formatThousands(lives),
        ),
      if (projects != null)
        _MetricPanel(
          icon: Icons.account_balance_rounded,
          title: l10n.impactActiveProjects,
          value: formatThousands(projects),
        ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (live || asOf != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.emeraldNight.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: AppColors.warmGold.withValues(alpha: 0.8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (live) ...[const _PulsingDot(), const SizedBox(width: 8)],
                Text(
                  live
                      ? l10n.impactLiveImpactStream
                      : l10n.impactAsOf(
                          DateFormat.yMMMd(
                            context.contentLocale.toString(),
                          ).format(asOf!.toLocal()),
                        ),
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
        if (funds != null) ...[
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
            l10n.impactEtbAmount(formatThousands(funds)),
            style: AppTypography.body(
              fontSize: 34,
              color: AppColors.goldLight,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),
        ],
        if (panels.isNotEmpty) ...[
          const SizedBox(height: 18),
          Row(
            children: [
              for (final (index, panel) in panels.indexed) ...[
                if (index > 0) const SizedBox(width: 12),
                Expanded(child: panel),
              ],
            ],
          ),
        ],
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
    _scale = Tween<double>(
      begin: 0.6,
      end: 2.4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacity = Tween<double>(
      begin: 0.6,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
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

/// The area the figures cover; with [onClear], tapping it goes back to
/// national.
class _RegionChip extends StatelessWidget {
  const _RegionChip({required this.label, this.loading = false, this.onClear});

  final String label;
  final bool loading;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.tagGoldBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.tagGoldBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (loading)
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.tagGoldText,
              ),
            )
          else
            const Icon(
              Icons.place_outlined,
              size: 14,
              color: AppColors.tagGoldText,
            ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.body(
              fontSize: 12,
              color: AppColors.tagGoldText,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (onClear != null) ...[
            const SizedBox(width: 4),
            const Icon(
              Icons.close_rounded,
              size: 14,
              color: AppColors.tagGoldText,
            ),
          ],
        ],
      ),
    );
    if (onClear == null) return chip;
    return Tooltip(
      message: context.l10n.impactShowNational,
      child: InkWell(
        onTap: onClear,
        borderRadius: BorderRadius.circular(999),
        child: chip,
      ),
    );
  }
}

/// Map with one marker per region; tapping a marker shows that region's
/// figures (tap it again to go back to national).
class _ImpactMapCard extends StatelessWidget {
  const _ImpactMapCard({required this.state});

  final ImpactState state;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final bloc = context.read<ImpactBloc>();
    final selected = state.selectedRegion;
    final overlayLabel = selected?.name ?? state.summary?.regionName;
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
                          for (final region in state.regions)
                            Marker(
                              point: LatLng(region.latitude, region.longitude),
                              width: 48,
                              height: 48,
                              child: _MapPin(
                                active: selected == region,
                                onTap: () => bloc.add(
                                  ImpactRegionSelected(
                                    selected == region ? null : region.code,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  if (overlayLabel != null)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.forestGreen.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: AppColors.goldLight.withValues(alpha: 0.6),
                          ),
                        ),
                        child: Text(
                          overlayLabel,
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
                Icon(
                  selected == null
                      ? Icons.touch_app_outlined
                      : Icons.insights_rounded,
                  size: 16,
                  color: scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    selected == null
                        ? l10n.impactTapRegionHint
                        : _regionStats(l10n, selected),
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

  /// "12,000,000 ETB · 40,210 beneficiaries · 21 projects", skipping
  /// missing figures; the hint when there are none.
  static String _regionStats(AppLocalizations l10n, ImpactRegion region) {
    final funds = region.distributedFundsEtb;
    final beneficiaries = region.beneficiaries;
    final projects = region.activeProjects;
    final parts = [
      if (funds != null) l10n.impactEtbAmount(formatThousands(funds)),
      if (beneficiaries != null)
        l10n.impactRegionBeneficiaries(formatThousands(beneficiaries)),
      if (projects != null)
        l10n.impactRegionProjects(formatThousands(projects)),
    ];
    return parts.isEmpty ? l10n.impactTapRegionHint : parts.join(' · ');
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

/// One bar per asnaf, scaled to the largest count.
class _AsnafBreakdownCard extends StatelessWidget {
  const _AsnafBreakdownCard({required this.rows});

  final List<AsnafCount> rows;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sorted = [...rows]..sort((a, b) => b.count.compareTo(a.count));
    final max = sorted.first.count;
    return PremiumCard(
      child: Column(
        children: [
          for (final (index, row) in sorted.indexed) ...[
            if (index > 0) const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    row.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body(
                      fontSize: 13,
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  formatThousands(row.count),
                  style: AppTypography.body(
                    fontSize: 13,
                    color: AppColors.goldDeep,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            GoldProgressBar(value: max == 0 ? 0 : row.count / max),
          ],
        ],
      ),
    );
  }
}

class _StoriesRow extends StatelessWidget {
  const _StoriesRow({required this.stories});

  final List<ImpactStory> stories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) =>
            SizedBox(width: 92, child: _StoryAvatar(story: stories[index])),
      ),
    );
  }
}

class _StoryAvatar extends StatelessWidget {
  const _StoryAvatar({required this.story});

  final ImpactStory story;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final imageUrl = story.imageUrl;
    return InkWell(
      onTap: () =>
          context.push('/impact/stories/${Uri.encodeComponent(story.id)}'),
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
                child: ClipOval(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: story.category.bannerColors,
                          ),
                        ),
                        child: Icon(
                          story.category.icon,
                          color: AppColors.goldLight,
                          size: 26,
                        ),
                      ),
                      if (imageUrl != null)
                        Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const SizedBox.shrink(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              story.title,
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
