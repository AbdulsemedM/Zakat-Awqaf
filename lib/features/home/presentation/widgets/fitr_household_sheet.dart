import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/zakat_page_header.dart';
import '../../../../core/common/utils/money_formatter.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../zakat_payment/presentation/models/zakat_payment_args.dart';
import '../../data/models/zakat_al_fitr_season.dart';

/// Asks how many people the donor pays Zakat al-Fitr for, then opens the
/// payment with `householdSize × perPersonAmountEtb`.
Future<void> showFitrHouseholdSheet(
  BuildContext context,
  ZakatAlFitrSeason season,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _FitrHouseholdSheet(season: season, parent: context),
  );
}

class _FitrHouseholdSheet extends StatefulWidget {
  const _FitrHouseholdSheet({required this.season, required this.parent});

  final ZakatAlFitrSeason season;

  /// Context that opens the payment after the sheet closes.
  final BuildContext parent;

  @override
  State<_FitrHouseholdSheet> createState() => _FitrHouseholdSheetState();
}

class _FitrHouseholdSheetState extends State<_FitrHouseholdSheet> {
  /// The server sets no maximum; this only keeps the stepper sensible.
  static const _maxPeople = 50;

  int _people = 1;

  void _continue() {
    final l10n = context.l10n;
    Navigator.of(context).pop();
    widget.parent.push(
      '/zakat/payment',
      extra: ZakatPaymentArgs.forFitr(l10n, widget.season, _people),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final total = _people * widget.season.perPersonAmountEtb;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.fitrHouseholdTitle,
              style: AppTypography.displayHeading(
                fontSize: 20,
                color: scheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.fitrPerPerson(
                MoneyFormatter.etb(widget.season.perPersonAmountEtb),
              ),
              style: AppTypography.body(
                fontSize: 13,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  onPressed: _people > 1
                      ? () => setState(() => _people--)
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                SizedBox(
                  width: 140,
                  child: Text(
                    l10n.fitrHouseholdOf(_people),
                    textAlign: TextAlign.center,
                    style: AppTypography.body(
                      fontSize: 20,
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: _people < _maxPeople
                      ? () => setState(() => _people++)
                      : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              l10n.fitrTotal(MoneyFormatter.etb(total)),
              textAlign: TextAlign.center,
              style: AppTypography.body(
                fontSize: 16,
                color: AppColors.goldDeep,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 18),
            GoldActionButton(
              label: l10n.commonContinue,
              icon: Icons.arrow_forward_rounded,
              onPressed: _continue,
            ),
          ],
        ),
      ),
    );
  }
}
