import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../core/common/utils/money_formatter.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../home/presentation/widgets/home_shared.dart';
import '../../../zakat_payment/presentation/models/zakat_payment_args.dart';
import '../../data/models/cause.dart';
import 'cause_visuals.dart';

/// Cause summary card: banner, title, progress and a "Give Zakat" button.
/// Tapping it opens the cause detail.
class CauseCard extends StatelessWidget {
  const CauseCard({super.key, required this.cause});

  final Cause cause;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return PremiumCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () =>
                context.push('/causes/${Uri.encodeComponent(cause.id)}'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 104,
                  child: CauseBanner(cause: cause, l10n: l10n),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cause.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.displayHeading(
                            fontSize: 16,
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cause.description ?? cause.category.label(l10n),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.body(
                            fontSize: 12,
                            color: scheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                        const Spacer(),
                        CauseProgressRow(cause: cause),
                        const SizedBox(height: 10),
                        if (cause.acceptsZakat)
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () => context.push(
                                '/zakat/payment',
                                extra: ZakatPaymentArgs.forCause(cause),
                              ),
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(0, 40),
                                padding: EdgeInsets.zero,
                                textStyle: AppTypography.body(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              child: Text(l10n.payZakatCause),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Progress bar and percentage when the cause has a goal, and the amount
/// raised when it is tracked. Empty for the general fund.
class CauseProgressRow extends StatelessWidget {
  const CauseProgressRow({super.key, required this.cause});

  final Cause cause;

  /// Whether [CauseProgressRow] has anything to show for [cause].
  static bool hasContent(Cause cause) =>
      cause.progress != null || cause.raisedEtb != null;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final progress = cause.progress;
    final raisedEtb = cause.raisedEtb;
    final goal = cause.goalEtb;
    final caption = raisedEtb == null
        ? null
        : Text(
            goal != null
                ? l10n.causeRaisedOfGoal(
                    MoneyFormatter.etbCompact(raisedEtb),
                    MoneyFormatter.etbCompact(goal),
                  )
                : l10n.causeRaised(MoneyFormatter.etbCompact(raisedEtb)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.body(
              fontSize: 11,
              color: scheme.onSurfaceVariant,
            ),
          );
    if (progress == null) return caption ?? const SizedBox.shrink();
    final percent = (progress.clamp(0.0, 1.0) * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(child: GoldProgressBar(value: progress)),
            const SizedBox(width: 8),
            Text(
              '$percent%',
              style: AppTypography.body(
                fontSize: 12,
                color: AppColors.goldDeep,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        if (caption != null) ...[const SizedBox(height: 4), caption],
      ],
    );
  }
}
