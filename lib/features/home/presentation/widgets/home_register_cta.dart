import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/primary_hero.dart';
import '../../../../core/l10n/l10n.dart';

class RegisterZakatCta extends StatelessWidget {
  const RegisterZakatCta({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: PrimaryHero.sadaqahGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldDeep.withValues(alpha: 0.22),
            blurRadius: 16,
            spreadRadius: -4,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => context.go('/beneficiary-registration'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.forestGreen.withValues(alpha: 0.12),
                  ),
                  child: const Icon(
                    TablerIcons.user_plus,
                    color: AppColors.forestGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.registerAcceptZakat,
                    style: AppTypography.body(
                      fontSize: 15,
                      color: AppColors.emeraldNight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Icon(
                  TablerIcons.arrow_right,
                  color: AppColors.emeraldNight,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
