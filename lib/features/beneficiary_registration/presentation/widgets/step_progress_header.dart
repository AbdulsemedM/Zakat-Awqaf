import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../bloc/beneficiary_registration_state.dart';

class StepProgressHeader extends StatelessWidget {
  const StepProgressHeader({
    required this.step,
    required this.method,
    super.key,
  });

  final BeneficiaryRegistrationStep step;
  final RegistrationMethod method;

  static int _activeIndex(BeneficiaryRegistrationStep step, RegistrationMethod method) {
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
    final scheme = Theme.of(context).colorScheme;

    if (step == BeneficiaryRegistrationStep.welcome ||
        (method != RegistrationMethod.institution &&
            step == BeneficiaryRegistrationStep.setPassword)) {
      return const SizedBox(height: 8);
    }

    final labels = switch (method) {
      RegistrationMethod.fastTrack => ['Needs', 'Disburse'],
      RegistrationMethod.institution => ['Details', 'Password', 'Documents'],
      RegistrationMethod.manual => ['Identity', 'Needs', 'Verify'],
    };
    final activeIndex = _activeIndex(step, method);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.55)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final hasFiniteWidth = constraints.maxWidth.isFinite;
          final indicatorWidth = hasFiniteWidth ? constraints.maxWidth : 240.0;

          return Center(
            child: SizedBox(
              width: indicatorWidth,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (var index = 0; index < labels.length; index++) ...[
                        _StepCircle(
                          index: index,
                          activeIndex: activeIndex,
                          scheme: scheme,
                        ),
                        if (index < labels.length - 1)
                          Expanded(
                            child: Container(
                              height: 2,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              color: index < activeIndex
                                  ? AppColors.primary
                                  : scheme.outlineVariant,
                            ),
                          ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var index = 0; index < labels.length; index++)
                        Expanded(
                          child: Text(
                            labels[index],
                            textAlign: index == 0
                                ? TextAlign.left
                                : index == labels.length - 1
                                    ? TextAlign.right
                                    : TextAlign.center,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  fontWeight: index <= activeIndex
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: index <= activeIndex
                                      ? AppColors.primary
                                      : scheme.onSurfaceVariant,
                                ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.index,
    required this.activeIndex,
    required this.scheme,
  });

  final int index;
  final int activeIndex;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final isActive = activeIndex >= 0 && index <= activeIndex;
    return CircleAvatar(
      radius: 12,
      backgroundColor:
          isActive ? AppColors.primary : scheme.surfaceContainerHighest,
      child: Text(
        '${index + 1}',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 11,
              color: isActive
                  ? AppColors.textOnPrimary
                  : scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
