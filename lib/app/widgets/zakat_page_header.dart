import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/primary_hero.dart';
import 'app_logo.dart';
import 'islamic_ornaments.dart';

/// Emerald page header for pushed Zakat-side screens: back button, logo,
/// Playfair title, optional subtitle, and an optional [bottom] slot.
class ZakatPageHeader extends StatelessWidget {
  const ZakatPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.leadingIcon,
    this.bottom,
  });

  final String title;
  final String? subtitle;

  /// Defaults to [Navigator.maybePop].
  final VoidCallback? onBack;

  /// Optional emblem shown beside the title (e.g. a globe for international).
  final IconData? leadingIcon;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      child: DecoratedBox(
        decoration: const BoxDecoration(gradient: PrimaryHero.zakatHeroGradient),
        child: Stack(
          children: [
            const IslamicPatternLayer(opacity: 0.12, fadeTo: Alignment.bottomLeft),
            const Positioned(
              top: 84,
              right: -48,
              child: CrescentOrnament(size: 130, opacity: 0.12),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 16, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                          onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.10),
                            side: BorderSide(
                              color: AppColors.goldLight.withValues(alpha: 0.4),
                            ),
                          ),
                          icon: const BackButtonIcon(),
                          color: AppColors.goldLight,
                        ),
                        const Spacer(),
                        const AppLogo(height: 30),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (leadingIcon != null) ...[
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.10),
                                    border: Border.all(
                                      color: AppColors.goldLight.withValues(alpha: 0.55),
                                    ),
                                  ),
                                  child: Icon(leadingIcon, color: AppColors.goldLight, size: 20),
                                ),
                                const SizedBox(width: 12),
                              ],
                              Expanded(
                                child: Text(
                                  title,
                                  style: AppTypography.displayHeading(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    height: 1.15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const GoldOrnamentDivider(width: 56),
                          if (subtitle != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              subtitle!,
                              style: AppTypography.body(
                                fontSize: 13,
                                color: AppColors.mintGreen,
                                height: 1.5,
                              ),
                            ),
                          ],
                          if (bottom != null) ...[
                            const SizedBox(height: 16),
                            bottom!,
                          ],
                        ],
                      ),
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

/// Section title inside a form card: gold-ringed icon plus a label.
class ZakatFormSectionTitle extends StatelessWidget {
  const ZakatFormSectionTitle({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.tagGreenBg,
            border: Border.all(color: AppColors.goldHairline),
          ),
          child: Icon(icon, size: 16, color: AppColors.forestMid),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: AppTypography.body(
              fontSize: 15,
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

/// Gold full-width primary action with an optional busy state.
class GoldActionButton extends StatelessWidget {
  const GoldActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.busy = false,
    this.busyLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool busy;
  final String? busyLabel;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !busy;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: enabled || busy ? 1 : 0.5,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: PrimaryHero.sadaqahGradient,
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.goldDeep.withValues(alpha: 0.28),
                    blurRadius: 16,
                    spreadRadius: -4,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: FilledButton(
          onPressed: enabled ? onPressed : null,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: AppColors.emeraldNight,
            disabledForegroundColor: AppColors.emeraldNight,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (busy)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.emeraldNight,
                  ),
                )
              else if (icon != null)
                Icon(icon, size: 20),
              if (busy || icon != null) const SizedBox(width: 10),
              Flexible(
                child: Text(
                  busy ? (busyLabel ?? label) : label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.body(
                    fontSize: 16,
                    color: AppColors.emeraldNight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
