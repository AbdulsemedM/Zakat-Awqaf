import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../core/common/utils/money_formatter.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/number_format.dart';
import '../../data/models/zakat_payment_models.dart';
import '../../data/repository/zakat_payment_repository.dart';

/// A donor's giving this Hijri year and all time
/// (`GET /me/giving-summary`). Hides itself when it can't load; figures
/// that are `null` (e.g. beneficiaries helped) are left out.
class GivingSummaryCard extends StatefulWidget {
  const GivingSummaryCard({super.key});

  @override
  State<GivingSummaryCard> createState() => _GivingSummaryCardState();
}

class _GivingSummaryCardState extends State<GivingSummaryCard> {
  GivingSummary? _summary;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final summary = await getIt<ZakatPaymentRepository>()
          .fetchGivingSummary();
      if (mounted) setState(() => _summary = summary);
    } on ApiException {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = _summary;
    if (_failed) return const SizedBox.shrink();
    if (summary == null) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final total = summary.totalZakatPaidEtb;
    final stats = <(String, String)>[
      if (summary.paymentsCount != null)
        (l10n.givingPayments, formatThousands(summary.paymentsCount!)),
      if (summary.causesSupported != null)
        (l10n.givingCausesSupported, formatThousands(summary.causesSupported!)),
      if (summary.beneficiariesHelped != null)
        (
          l10n.givingBeneficiariesHelped,
          formatThousands(summary.beneficiariesHelped!),
        ),
    ];
    final allTime = summary.allTimeZakatPaidEtb;
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            summary.periodLabel == null
                ? l10n.givingTotalPaid
                : l10n.givingTotalPaidIn(summary.periodLabel!),
            style: AppTypography.body(
              fontSize: 13,
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            MoneyFormatter.etb(total ?? 0),
            style: AppTypography.body(
              fontSize: 26,
              color: AppColors.goldDeep,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (stats.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 20,
              runSpacing: 8,
              children: [
                for (final (label, value) in stats)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value,
                        style: AppTypography.body(
                          fontSize: 18,
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        label,
                        style: AppTypography.body(
                          fontSize: 12,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
          if (allTime != null) ...[
            const Divider(height: 24),
            Text(
              l10n.givingAllTime(MoneyFormatter.etb(allTime)),
              style: AppTypography.body(
                fontSize: 13,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
