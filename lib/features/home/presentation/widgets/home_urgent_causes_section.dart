import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../causes/data/models/cause.dart';
import '../../../causes/presentation/widgets/cause_card.dart';

/// Horizontal row of urgent causes; the caller hides it when there are none.
class UrgentCausesSection extends StatelessWidget {
  const UrgentCausesSection({super.key, required this.causes});

  final List<Cause> causes;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ZakatSectionHeader(
          title: l10n.urgentBeneficiaryNeeds,
          actionLabel: l10n.viewAll,
          onAction: () => context.push('/causes'),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 268,
          child: ListView.separated(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: causes.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) =>
                SizedBox(width: 236, child: CauseCard(cause: causes[index])),
          ),
        ),
      ],
    );
  }
}
