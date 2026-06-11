import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/settings/app_settings_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/primary_hero.dart';
import '../../../../core/l10n/l10n.dart';
import 'home_decorations.dart';

class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: PrimaryHero.zakatHeroGradient,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            top: 0,
            right: 0,
            child: IslamicOrnamentDecoration(),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: PopupMenuButton<AppMode>(
                      tooltip: 'Change mode',
                      icon: const Icon(
                        TablerIcons.switch_horizontal,
                        color: AppColors.mintGreenMuted,
                        size: 22,
                      ),
                      color: AppColors.forestGreen,
                      onSelected: (mode) async {
                        if (mode != AppMode.awqaf) return;
                        final controller =
                            context.read<AppSettingsController>();
                        await controller.setAppMode(AppMode.awqaf);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Switched to Awqaf mode'),
                          ),
                        );
                        context.go('/awqaf');
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: AppMode.awqaf,
                          child: Text('Switch to Awqaf'),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    l10n.homeGreeting.toUpperCase(),
                    style: AppTypography.label(
                      fontSize: 11,
                      color: AppColors.mintGreen,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.homeCommissionTitle,
                    style: AppTypography.displayHeading(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _LiveImpactPill(),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: l10n.thisMonth.toUpperCase(),
                          value: 'ETB 1.12M',
                          subtext: '↑ Growing strong',
                          goldAccent: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          label: l10n.totalBeneficiariesSupported
                              .toUpperCase(),
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
    );
  }
}

class _LiveImpactPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.forestGreen.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.warmGold),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.warmGold,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'LIVE · ETB 12,842,300 collected',
            style: AppTypography.label(
              fontSize: 11,
              color: AppColors.warmGold,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.subtext,
    this.goldAccent = false,
  });

  final String label;
  final String value;
  final String subtext;
  final bool goldAccent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: goldAccent
              ? AppColors.warmGold.withValues(alpha: 0.6)
              : Colors.white.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.label(
              fontSize: 9,
              color: AppColors.mintGreen,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.body(
              fontSize: 16,
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtext,
            style: AppTypography.body(
              fontSize: 10,
              color: AppColors.mintGreenMuted,
            ),
          ),
        ],
      ),
    );
  }
}
