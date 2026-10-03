import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../app/widgets/zakat_page_header.dart';
import '../../../../core/common/utils/money_formatter.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../causes/presentation/screens/causes_screen.dart';
import '../../../home/presentation/widgets/home_shared.dart';
import '../../data/models/zakat_payment_models.dart';
import '../../data/repository/zakat_payment_repository.dart';
import '../open_payment.dart';
import 'zakat_certificate_screen.dart';

/// A signed-in donor's zakat payments (`GET /me/payments?type=zakat`),
/// newest first. A paid row opens its certificate.
class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final _repository = getIt<ZakatPaymentRepository>();
  final _items = <PaymentHistoryItem>[];
  int _page = 0;
  bool _hasMore = true;
  bool _loading = false;
  ApiException? _error;

  @override
  void initState() {
    super.initState();
    _loadMore();
  }

  Future<void> _reload() async {
    setState(() {
      _items.clear();
      _page = 0;
      _hasMore = true;
    });
    await _loadMore();
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasMore) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await _repository.fetchHistory(page: _page + 1);
      if (!mounted) return;
      setState(() {
        _items.addAll(page.items);
        _page = page.page;
        _hasMore = page.hasMore;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification.metrics.extentAfter < 300) _loadMore();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final error = _error;
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: RefreshIndicator(
          onRefresh: _reload,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: ZakatPageHeader(
                  title: l10n.historyTitle,
                  leadingIcon: Icons.history_rounded,
                ),
              ),
              if (_items.isEmpty && error != null)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: CausesMessage(
                    icon: Icons.cloud_off_outlined,
                    message: error.code == 'PAYER_NOT_ALLOWED'
                        ? l10n.payNotAllowedBeneficiary
                        : l10n.historyLoadError,
                    onRetry: error.code == 'PAYER_NOT_ALLOWED' ? null : _reload,
                  ),
                )
              else if (_items.isEmpty && !_loading)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: CausesMessage(
                    icon: Icons.receipt_long_outlined,
                    message: l10n.historyEmpty,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  sliver: SliverList.separated(
                    itemCount: _items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) =>
                        _HistoryRow(item: _items[index]),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _items.isNotEmpty && error != null
                      ? Center(
                          child: TextButton.icon(
                            onPressed: _loadMore,
                            icon: const Icon(Icons.refresh),
                            label: Text(l10n.commonRetry),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.item});

  final PaymentHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final certificateId = item.certificateId;
    final date = item.paidAt ?? item.createdAt;
    final subtitle = [
      zakatTypeLabel(l10n, item.zakatType),
      item.causeTitle,
      if (date != null)
        DateFormat.yMMMd(
          context.contentLocale.toString(),
        ).format(date.toLocal()),
    ].whereType<String>().join(' · ');
    final hasCertificate =
        item.status == PaymentStatus.succeeded && certificateId != null;
    // An unfinished payment can be resumed (or its result checked).
    final canResume = item.status == PaymentStatus.pending;
    final canOpen = hasCertificate || canResume;
    return PremiumCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        onTap: hasCertificate
            ? () => context.push(
                '/zakat/certificate/${Uri.encodeComponent(certificateId)}',
              )
            : canResume
            ? () => openPayment(context, item.paymentId)
            : null,
        title: Text(
          MoneyFormatter.etb(item.amountEtb),
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
              label: paymentStatusLabel(l10n, item.status),
              style: item.status == PaymentStatus.succeeded
                  ? TagStyle.green
                  : TagStyle.gold,
            ),
            if (canOpen) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.goldDeep,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String paymentStatusLabel(AppLocalizations l10n, PaymentStatus status) =>
    switch (status) {
      PaymentStatus.succeeded => l10n.payStatusSucceeded,
      PaymentStatus.pending => l10n.payStatusPending,
      PaymentStatus.failed => l10n.payStatusFailed,
      PaymentStatus.cancelled => l10n.payStatusCancelled,
      PaymentStatus.expired => l10n.payStatusExpired,
    };
