import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/primary_hero.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../core/l10n/l10n.dart';
import '../../bloc/beneficiary_registration_state.dart';

class StepProgressHeader extends StatelessWidget {
  const StepProgressHeader({
    required this.step,
    required this.method,
    super.key,
  });

  final BeneficiaryRegistrationStep step;
  final RegistrationMethod method;

  static int _activeIndex(
    BeneficiaryRegistrationStep step,
    RegistrationMethod method,
  ) {
    if (step == BeneficiaryRegistrationStep.welcome) {
      return -1;
    }
    if (method == RegistrationMethod.institution) {
      return switch (step) {
        BeneficiaryRegistrationStep.institutionDetails => 0,
        BeneficiaryRegistrationStep.setPassword => 1,
        BeneficiaryRegistrationStep.institutionDocuments => 2,
        BeneficiaryRegistrationStep.welcome => -1,
        BeneficiaryRegistrationStep.identity => -1,
        BeneficiaryRegistrationStep.needs => -1,
        BeneficiaryRegistrationStep.disbursement => -1,
      };
    }
    if (method == RegistrationMethod.fastTrack) {
      return switch (step) {
        BeneficiaryRegistrationStep.needs => 0,
        BeneficiaryRegistrationStep.disbursement => 1,
        BeneficiaryRegistrationStep.welcome => -1,
        BeneficiaryRegistrationStep.identity => -1,
        BeneficiaryRegistrationStep.institutionDetails => -1,
        BeneficiaryRegistrationStep.setPassword => -1,
        BeneficiaryRegistrationStep.institutionDocuments => -1,
      };
    }
    return switch (step) {
      BeneficiaryRegistrationStep.identity => 0,
      BeneficiaryRegistrationStep.needs => 1,
      BeneficiaryRegistrationStep.disbursement => 2,
      BeneficiaryRegistrationStep.welcome => -1,
      BeneficiaryRegistrationStep.institutionDetails => -1,
      BeneficiaryRegistrationStep.setPassword => -1,
      BeneficiaryRegistrationStep.institutionDocuments => -1,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    if (step == BeneficiaryRegistrationStep.welcome ||
        (method != RegistrationMethod.institution &&
            step == BeneficiaryRegistrationStep.setPassword)) {
      return const SizedBox(height: 8);
    }

    final labels = switch (method) {
      RegistrationMethod.fastTrack => [l10n.regStepNeeds, l10n.regStepPayout],
      RegistrationMethod.institution => [
        l10n.regStepDetails,
        l10n.regStepPassword,
        l10n.regStepDocuments,
      ],
      RegistrationMethod.manual => [
        l10n.regStepIdentity,
        l10n.regStepNeeds,
        l10n.regStepPayout,
      ],
    };
    final activeIndex = _activeIndex(step, method);

    return PremiumCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        children: [
          Row(
            children: [
              for (var index = 0; index < labels.length; index++) ...[
                _StepCircle(index: index, activeIndex: activeIndex),
                if (index < labels.length - 1)
                  Expanded(
                    child: Container(
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        gradient: index < activeIndex
                            ? const LinearGradient(
                                colors: [
                                  AppColors.forestLight,
                                  AppColors.warmGold,
                                ],
                              )
                            : null,
                        color: index < activeIndex
                            ? null
                            : scheme.outlineVariant,
                      ),
                    ),
                  ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var index = 0; index < labels.length; index++)
                Expanded(
                  child: Text(
                    labels[index],
                    textAlign: index == 0
                        ? TextAlign.start
                        : index == labels.length - 1
                        ? TextAlign.end
                        : TextAlign.center,
                    style: AppTypography.body(
                      fontSize: 12,
                      fontWeight: index == activeIndex
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: index == activeIndex
                          ? AppColors.goldDeep
                          : index < activeIndex
                          ? scheme.primary
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({required this.index, required this.activeIndex});

  final int index;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final done = index < activeIndex;
    final current = index == activeIndex;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: current ? 34 : 28,
      height: current ? 34 : 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: current
            ? PrimaryHero.goldButtonGradient
            : done
            ? const LinearGradient(
                colors: [AppColors.forestLight, AppColors.forestGreen],
              )
            : null,
        color: current || done ? null : scheme.surfaceContainerHigh,
        border: Border.all(
          color: current ? AppColors.goldDeep : scheme.outlineVariant,
        ),
        boxShadow: current
            ? [
                BoxShadow(
                  color: AppColors.warmGold.withValues(alpha: 0.35),
                  blurRadius: 10,
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: done
          ? const Icon(
              Icons.check_rounded,
              size: 16,
              color: AppColors.goldLight,
            )
          : Text(
              '${index + 1}',
              style: AppTypography.body(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: current
                    ? AppColors.onSecondary
                    : scheme.onSurfaceVariant,
              ),
            ),
    );
  }
}
