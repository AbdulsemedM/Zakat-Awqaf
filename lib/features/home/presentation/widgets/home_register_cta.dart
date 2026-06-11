import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/l10n/l10n.dart';

class RegisterZakatCta extends StatelessWidget {
  const RegisterZakatCta({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      color: AppColors.warmGold,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => context.go('/beneficiary-registration'),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                TablerIcons.user_plus,
                color: AppColors.forestGreen,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                l10n.registerAcceptZakat,
                style: AppTypography.body(
                  fontSize: 15,
                  color: AppColors.forestGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
