import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../app/widgets/zakat_page_header.dart';
import '../../../../core/common/utils/money_formatter.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../causes/presentation/screens/causes_screen.dart';
import '../../../home/presentation/widgets/home_shared.dart';
import '../../data/data_provider/device_payments_store.dart';
import '../../data/models/zakat_payment_models.dart';
import '../../data/repository/zakat_payment_repository.dart';
import '../open_payment.dart';
import '../widgets/device_payments_section.dart';
import 'payment_history_screen.dart';
import 'zakat_certificate_screen.dart';

/// Payments started on this device (mainly for guests, who have no server
/// history). Unfinished ones are refreshed on open; tapping a row resumes
/// it or shows its result and certificate.
class DevicePaymentsScreen extends StatefulWidget {
  const DevicePaymentsScreen({super.key});

  @override
  State<DevicePaymentsScreen> createState() => _DevicePaymentsScreenState();
}

class _DevicePaymentsScreenState extends State<DevicePaymentsScreen> {
  final _store = getIt<DevicePaymentsStore>();
  final _repository = getIt<ZakatPaymentRepository>();

  @override
  void initState() {
    super.initState();
    _refreshPending();
  }

  /// Reloads payments still `pending` here: they may have been paid,
  /// expired or settled since. Responses update the store.
  Future<void> _refreshPending() async {
    final pending = _store.payments
        .where((p) => p.status == PaymentStatus.pending)
        .map((p) => p.paymentId)
        .toList();
    await Future.wait([
      for (final id in pending)
        _repository
            .fetchPayment(id)
            .then<void>((_) {})
            .catchError((Object _) {}, test: (e) => e is ApiException),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: ListenableBuilder(
        listenable: _store,
        builder: (context, _) {
          final payments = _store.payments;
          final unfinished = _store.unfinished(DateTime.now());
          return RefreshIndicator(
            onRefresh: _refreshPending,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: ZakatPageHeader(
                    title: l10n.recentPaymentsTitle,
                    subtitle: l10n.recentPaymentsSubtitle,
                    leadingIcon: Icons.receipt_long_outlined,
                  ),
                ),
                if (payments.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: CausesMessage(
                      icon: Icons.receipt_long_outlined,
                      message: l10n.recentPaymentsEmpty,
                    ),
                  )
                else ...[
                  if (unfinished != null)
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      sliver: SliverToBoxAdapter(
                        child: UnfinishedPaymentCard(payment: unfinished),
                      ),
                    ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    sliver: SliverList.separated(
                      itemCount: payments.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) =>
                          _DevicePaymentRow(payment: payments[index]),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DevicePaymentRow extends StatelessWidget {
  const _DevicePaymentRow({required this.payment});

  final DevicePayment payment;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final subtitle = [
      zakatTypeLabel(l10n, payment.zakatType),
      payment.causeTitle,
      DateFormat.yMMMd(
        context.contentLocale.toString(),
      ).add_jm().format(payment.createdAt.toLocal()),
    ].whereType<String>().join(' · ');
    return PremiumCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        onTap: () => openPayment(context, payment.paymentId),
        title: Text(
          MoneyFormatter.etb(payment.amountEtb),
          style: AppTypography.body(
            fontSize: 16,
            color: scheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.body(
            fontSize: 12,
            color: scheme.onSurfaceVariant,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TagPill(
              label: paymentStatusLabel(l10n, payment.status),
              style: payment.status == PaymentStatus.succeeded
                  ? TagStyle.green
                  : TagStyle.gold,
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: AppColors.goldDeep),
          ],
        ),
      ),
    );
  }
}
