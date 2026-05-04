import 'package:flutter/material.dart';

import '../../bloc/beneficiary_registration_state.dart';

class StepProgressHeader extends StatelessWidget {
  const StepProgressHeader({required this.step, super.key});

  final BeneficiaryRegistrationStep step;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final labels = ['Identity', 'Needs', 'Verify'];
    final activeIndex = switch (step) {
      BeneficiaryRegistrationStep.welcome => 0,
      BeneficiaryRegistrationStep.identity => 0,
      BeneficiaryRegistrationStep.needs => 1,
      BeneficiaryRegistrationStep.disbursement => 2,
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasFiniteWidth = constraints.maxWidth.isFinite;
        final indicatorWidth = hasFiniteWidth
            ? constraints.maxWidth
            : 240.0;

        return Center(
          child: SizedBox(
            width: indicatorWidth,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (var index = 0; index < labels.length; index++) ...[
                  _StepCircle(index: index, activeIndex: activeIndex, scheme: scheme),
                  if (index < labels.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        color: index < activeIndex
                            ? scheme.primary
                            : scheme.outlineVariant,
                      ),
                    ),
                ],
              ],
            ),
          ),
        );
      },
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
    final isActive = index <= activeIndex;
    return CircleAvatar(
      radius: 12,
      backgroundColor: isActive ? scheme.primary : scheme.surfaceContainerHighest,
      child: Text(
        '${index + 1}',
        style: TextStyle(
          fontSize: 11,
          color: isActive ? scheme.onPrimary : scheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
