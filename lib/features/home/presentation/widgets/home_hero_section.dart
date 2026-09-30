import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/settings/app_settings_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/primary_hero.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../core/l10n/l10n.dart';

/// Extra bottom padding so the quick-actions card can overlap the hero.
const double kHomeHeroOverlap = 44;

class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      child: DecoratedBox(
        decoration: const BoxDecoration(gradient: PrimaryHero.zakatHeroGradient),
        child: Stack(
          children: [
            const IslamicPatternLayer(opacity: 0.13, fadeTo: Alignment.bottomLeft),
            const Positioned(top: 34, right: -26, child: CrescentOrnament(size: 150)),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 24 + kHomeHeroOverlap),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'بِسْمِ ٱللَّٰهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.start,
                            style: AppTypography.body(
                              fontSize: 14,
                              color: AppColors.goldLight.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        _ModeSwitchButton(),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      l10n.homeGreeting.toUpperCase(),
                      style: AppTypography.label(
                        fontSize: 11,
                        color: AppColors.mintGreen,
                        letterSpacing: 2.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.homeCommissionTitle,
                      style: AppTypography.displayHeading(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const GoldOrnamentDivider(width: 64),
                    const SizedBox(height: 18),
                    const _LiveImpactPill(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _StatPanel(
                            icon: TablerIcons.coin,
                            label: l10n.thisMonth.toUpperCase(),
                            value: 'ETB 1.12M',
                            subtext: '↑ Growing strong',
                            gold: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatPanel(
                            icon: TablerIcons.heart_handshake,
                            label: l10n.totalBeneficiariesSupported.toUpperCase(),
                            value: '4,982',
                            subtext: 'beneficiaries',
                          ),
                        ),
                      ],
                    ),
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

class _ModeSwitchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopupMenuButton<AppMode>(
      tooltip: l10n.changeAppModeTooltip,
      offset: const Offset(0, 44),
      onSelected: (mode) async {
        if (mode != AppMode.awqaf) return;
        final controller = context.read<AppSettingsController>();
        await controller.setAppMode(AppMode.awqaf);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.switchedToAwqafMode)),
        );
        context.go('/awqaf');
      },
      itemBuilder: (context) => [
        PopupMenuItem(value: AppMode.awqaf, child: Text(l10n.switchToAwqaf)),
      ],
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.10),
          border: Border.all(color: AppColors.goldLight.withValues(alpha: 0.45)),
        ),
        child: const Icon(
          TablerIcons.switch_horizontal,
          color: AppColors.goldLight,
          size: 19,
        ),
      ),
    );
  }
}

class _LiveImpactPill extends StatefulWidget {
  const _LiveImpactPill();

  @override
  State<_LiveImpactPill> createState() => _LiveImpactPillState();
}

class _LiveImpactPillState extends State<_LiveImpactPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.emeraldNight.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.warmGold.withValues(alpha: 0.8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: Tween(begin: 0.35, end: 1.0).animate(_pulse),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.goldLight,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.goldLight.withValues(alpha: 0.7),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              'LIVE · ETB 12,842,300 collected',
              overflow: TextOverflow.ellipsis,
              style: AppTypography.label(
                fontSize: 12,
                color: AppColors.goldLight,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPanel extends StatelessWidget {
  const _StatPanel({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtext,
    this.gold = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final String subtext;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      goldBorder: gold,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: gold ? AppColors.goldLight : AppColors.mintGreen,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.label(
                    fontSize: 10,
                    color: AppColors.mintGreen,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTypography.body(
              fontSize: 22,
              color: gold ? AppColors.goldLight : AppColors.textOnPrimary,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtext,
            style: AppTypography.body(fontSize: 11, color: AppColors.mintGreenMuted),
          ),
        ],
      ),
    );
  }
}
