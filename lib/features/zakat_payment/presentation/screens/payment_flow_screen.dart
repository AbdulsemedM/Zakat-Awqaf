import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gal/gal.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../app/widgets/zakat_page_header.dart';
import '../../../../core/common/utils/money_formatter.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/l10n.dart';
import '../../bloc/payment_flow_bloc.dart';
import '../../data/models/zakat_payment_models.dart';
import '../../data/repository/zakat_payment_repository.dart';
import '../qr_png.dart';
import '../widgets/payment_countdown.dart';

/// A started zakat payment and its result: the QR to scan with a bank app
/// and "I have paid", then paid (with the certificate) / expired /
/// cancelled.
class PaymentFlowScreen extends StatelessWidget {
  const PaymentFlowScreen({super.key, required this.payment});

  final ZakatPayment payment;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PaymentFlowBloc>(param1: payment),
      child: const _ResumeCheck(child: _PaymentFlowView()),
    );
  }
}

/// Checks the payment when the donor comes back to the app, usually from
/// their bank app after paying the QR.
class _ResumeCheck extends StatefulWidget {
  const _ResumeCheck({required this.child});

  final Widget child;

  @override
  State<_ResumeCheck> createState() => _ResumeCheckState();
}

class _ResumeCheckState extends State<_ResumeCheck>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    final bloc = context.read<PaymentFlowBloc>();
    if (bloc.state.payment.status == PaymentStatus.pending &&
        bloc.state.payment.canCheckPayment) {
      bloc.add(const PaymentCheckRequested(quiet: true));
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

enum _LeaveChoice { paid, notPaid }

class _PaymentFlowView extends StatelessWidget {
  const _PaymentFlowView();

  /// Leaving the QR: ask. If the donor did not pay, the payment is
  /// cancelled (the QR is not shown again); if they did, it is checked once
  /// more and stays pending (the server keeps checking for 24 hours).
  /// Leaving anything else only stops watching.
  Future<void> _onBack(BuildContext context, PaymentFlowState state) async {
    final payment = state.payment;
    final showingQr =
        payment.status == PaymentStatus.pending &&
        payment.step == PaymentStep.scanQr;
    if (!showingQr) {
      context.pop();
      return;
    }
    final l10n = context.l10n;
    final bloc = context.read<PaymentFlowBloc>();
    final choice = await showDialog<_LeaveChoice>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.payQrLeaveTitle),
        content: Text(l10n.payQrLeaveBody),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(_LeaveChoice.notPaid),
            child: Text(l10n.payQrLeaveNotPaid),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(_LeaveChoice.paid),
            child: Text(l10n.payQrIHavePaid),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.payKeepPaying),
          ),
        ],
      ),
    );
    if (!context.mounted) return;
    switch (choice) {
      case _LeaveChoice.notPaid:
        bloc.add(const PaymentCancelRequested());
      case _LeaveChoice.paid:
        // The screen's bloc closes now: check through the repository, which
        // records the answer for "Recent payments".
        unawaited(
          getIt<ZakatPaymentRepository>()
              .checkPayment(payment.paymentId)
              .then<void>((_) {}, onError: (Object _) {}),
        );
        context.pop();
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<PaymentFlowBloc, PaymentFlowState>(
      builder: (context, state) {
        final payment = state.payment;
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _onBack(context, state);
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ZakatPageHeader(
                    title: payment.isSadaqah
                        ? l10n.payTitleSadaqah
                        : l10n.payTitleZakat,
                    leadingIcon: Icons.verified_user_outlined,
                    onBack: () => _onBack(context, state),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                    child: switch ((payment.status, payment.step)) {
                      (PaymentStatus.pending, PaymentStep.scanQr) => _QrStep(
                        state: state,
                      ),
                      (PaymentStatus.pending, _) => _ProcessingStep(
                        state: state,
                      ),
                      (PaymentStatus.succeeded, _) => _SucceededResult(
                        payment: payment,
                      ),
                      _ => _EndedResult(state: state),
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Amount, project and method of the payment being made.
class _PaymentSummary extends StatelessWidget {
  const _PaymentSummary({required this.payment});

  final ZakatPayment payment;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MoneyFormatter.etb(payment.amountEtb),
            style: AppTypography.body(
              fontSize: 26,
              color: AppColors.goldDeep,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (payment.causeTitle != null) ...[
            const SizedBox(height: 4),
            Text(
              l10n.payForCause(payment.causeTitle!),
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

/// "Finish within 12:34": the time left before the QR expires (30
/// minutes). At zero, the bloc stops polling and checks one last time, so
/// a last-second payment or the server's `expired` state is shown.
class _PaymentDeadline extends StatelessWidget {
  const _PaymentDeadline({required this.payment});

  final ZakatPayment payment;

  @override
  Widget build(BuildContext context) {
    final expiresAt = payment.expiresAt;
    if (expiresAt == null) return const SizedBox.shrink();
    final l10n = context.l10n;
    final bloc = context.read<PaymentFlowBloc>();
    return PaymentCountdown(
      deadline: expiresAt,
      onFinished: () => bloc.add(const PaymentQrExpired()),
      builder: (context, remaining) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Icon(
              Icons.timer_outlined,
              size: 16,
              color: remaining.inMinutes < 2
                  ? Theme.of(context).colorScheme.error
                  : AppColors.goldDeep,
            ),
            const SizedBox(width: 6),
            Text(
              l10n.payFinishWithin(formatCountdown(remaining)),
              style: AppTypography.body(
                fontSize: 13,
                color: remaining.inMinutes < 2
                    ? Theme.of(context).colorScheme.error
                    : AppColors.goldDeep,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.text);

  final String? text;

  @override
  Widget build(BuildContext context) {
    final text = this.text;
    if (text == null || text.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        text,
        style: AppTypography.body(
          fontSize: 13,
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// "Scan to pay": the QR for any Ethiopian bank app. The bloc polls until
/// the commission confirms the payment.
class _QrStep extends StatefulWidget {
  const _QrStep({required this.state});

  final PaymentFlowState state;

  @override
  State<_QrStep> createState() => _QrStepState();
}

class _QrStepState extends State<_QrStep> {
  bool _sharing = false;
  bool _saving = false;

  /// PNG of the QR on opaque white, so it shows and scans from a gallery
  /// or chat (the server's PNG can be transparent, which shows as black).
  Future<Uint8List?> _qrPng(ZakatPayment payment) => buildQrPng(
    payload: payment.qrPayload,
    imageBase64: payment.qrImageBase64,
  );

  Future<void> _save(ZakatPayment payment) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _saving = true);
    var saved = false;
    try {
      final png = await _qrPng(payment);
      if (png != null && (await Gal.hasAccess() || await Gal.requestAccess())) {
        await Gal.putImageBytes(png, name: 'zakat-qr-${payment.paymentId}');
        saved = true;
      }
    } on GalException {
      saved = false;
    } finally {
      if (mounted) setState(() => _saving = false);
    }
    messenger.showSnackBar(
      SnackBar(content: Text(saved ? l10n.payQrSaved : l10n.payQrSaveFailed)),
    );
  }

  Future<void> _share(ZakatPayment payment) async {
    final l10n = context.l10n;
    setState(() => _sharing = true);
    try {
      final png = await _qrPng(payment);
      if (png == null) return;
      await SharePlus.instance.share(
        ShareParams(
          text: payment.isSadaqah
              ? l10n.payQrShareTextSadaqah(
                  MoneyFormatter.etb(payment.amountEtb),
                )
              : l10n.payQrShareText(MoneyFormatter.etb(payment.amountEtb)),
          files: [
            XFile.fromData(
              png,
              mimeType: 'image/png',
              name: 'zakat-qr-${payment.paymentId}.png',
            ),
          ],
        ),
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  Future<void> _confirmCancel() async {
    final l10n = context.l10n;
    final bloc = context.read<PaymentFlowBloc>();
    final cancel = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.payCancelConfirmTitle),
        content: Text(l10n.payQrCancelConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.payKeepPaying),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.payCancelPayment),
          ),
        ],
      ),
    );
    if (cancel == true) bloc.add(const PaymentCancelRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final state = widget.state;
    final payment = state.payment;
    final payload = payment.qrPayload;
    final image = payment.qrImageBase64;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepTitle(title: l10n.payQrTitle, body: l10n.payQrBody),
        const SizedBox(height: 16),
        Center(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              // Always white: bank apps read dark modules on a light
              // background, whatever the app theme.
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.goldHairline),
            ),
            child: SizedBox.square(
              dimension: 240,
              child: payload != null
                  ? QrImageView(
                      data: payload,
                      version: QrVersions.auto,
                      gapless: true,
                      backgroundColor: Colors.white,
                      semanticsLabel: l10n.payQrTitle,
                    )
                  : image != null
                  ? Image.memory(base64Decode(image), fit: BoxFit.contain)
                  : Center(
                      child: Text(
                        l10n.payQrMissing,
                        textAlign: TextAlign.center,
                        style: AppTypography.body(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _PaymentSummary(payment: payment),
        _PaymentDeadline(payment: payment),
        const SizedBox(height: 12),
        Text(
          l10n.payQrConfirmNote,
          style: AppTypography.body(
            fontSize: 12,
            color: scheme.onSurfaceVariant,
            height: 1.45,
          ),
        ),
        _ErrorText(state.notReceived ? l10n.payQrNotReceived : null),
        _ErrorText(state.errorMessage),
        const SizedBox(height: 16),
        _CheckPaymentButton(state: state, label: l10n.payQrIHavePaid),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _saving || (payload == null && image == null)
                    ? null
                    : () => _save(payment),
                icon: const Icon(Icons.download_rounded),
                label: Text(l10n.payQrSave, textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _sharing || (payload == null && image == null)
                    ? null
                    : () => _share(payment),
                icon: const Icon(Icons.share_rounded),
                label: Text(l10n.payQrShare, textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          l10n.payQrShareHint,
          textAlign: TextAlign.center,
          style: AppTypography.body(
            fontSize: 12,
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: state.busy ? null : _confirmCancel,
          child: Text(l10n.payCancelPayment),
        ),
      ],
    );
  }
}

/// "We are confirming your payment": an older Coop account payment the
/// bank has not answered. The bloc polls.
class _ProcessingStep extends StatelessWidget {
  const _ProcessingStep({required this.state});

  final PaymentFlowState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        const Center(child: CircularProgressIndicator()),
        const SizedBox(height: 20),
        _StepTitle(
          title: l10n.payProcessingTitle,
          body: l10n.payProcessingBody,
          center: true,
        ),
        const SizedBox(height: 16),
        _PaymentSummary(payment: state.payment),
        _ErrorText(state.errorMessage),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: state.busy
              ? null
              : () => context.read<PaymentFlowBloc>().add(
                  const PaymentStatusRefreshRequested(),
                ),
          icon: const Icon(Icons.refresh),
          label: Text(l10n.payCheckAgain),
        ),
      ],
    );
  }
}

class _SucceededResult extends StatelessWidget {
  const _SucceededResult({required this.payment});

  final ZakatPayment payment;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final certificateId = payment.certificateId;
    final reference = payment.providerReference;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.verified_rounded,
          size: 64,
          color: AppColors.forestLight,
        ),
        const SizedBox(height: 12),
        _StepTitle(
          title: l10n.paySucceededTitle,
          body: payment.isSadaqah
              ? l10n.paySucceededBodySadaqah(
                  MoneyFormatter.etb(payment.amountEtb),
                )
              : l10n.paySucceededBody(MoneyFormatter.etb(payment.amountEtb)),
          center: true,
        ),
        if (payment.paidDifferentAmount) ...[
          const SizedBox(height: 8),
          Text(
            l10n.payPaidDifferentAmount(
              MoneyFormatter.etb(payment.amountEtb),
              MoneyFormatter.etb(payment.issuedAmountEtb!),
            ),
            textAlign: TextAlign.center,
            style: AppTypography.body(
              fontSize: 13,
              color: AppColors.goldDeep,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        if (reference != null) ...[
          const SizedBox(height: 8),
          Text(
            l10n.payReference(reference),
            textAlign: TextAlign.center,
            style: AppTypography.body(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 24),
        if (certificateId != null)
          GoldActionButton(
            label: payment.isSadaqah
                ? l10n.payViewReceipt
                : l10n.payViewCertificate,
            icon: Icons.workspace_premium_outlined,
            onPressed: () => context.push(
              '/zakat/certificate/${Uri.encodeComponent(certificateId)}',
            ),
          ),
        const SizedBox(height: 8),
        TextButton(onPressed: () => context.go('/'), child: Text(l10n.payDone)),
      ],
    );
  }
}

/// Failed, cancelled or expired: start again.
class _EndedResult extends StatelessWidget {
  const _EndedResult({required this.state});

  final PaymentFlowState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final payment = state.payment;
    final (title, body) = switch (payment.status) {
      PaymentStatus.cancelled => (l10n.payCancelledTitle, l10n.payNoMoneyTaken),
      // An expired QR paid late is still confirmed for 24 hours.
      PaymentStatus.expired => (l10n.payExpiredTitle, l10n.payQrExpiredBody),
      _ => (
        l10n.payFailedTitle,
        payment.failureReason ?? state.errorMessage ?? l10n.payFailedBody,
      ),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          payment.status == PaymentStatus.failed
              ? Icons.error_outline_rounded
              : Icons.info_outline_rounded,
          size: 64,
          color: payment.status == PaymentStatus.failed
              ? Theme.of(context).colorScheme.error
              : AppColors.goldDeep,
        ),
        const SizedBox(height: 12),
        _StepTitle(title: title, body: body, center: true),
        if (payment.status == PaymentStatus.expired &&
            payment.canCheckPayment) ...[
          _ErrorText(state.notReceived ? l10n.payQrNotReceived : null),
          _ErrorText(state.errorMessage),
          const SizedBox(height: 20),
          _CheckPaymentButton(state: state, label: l10n.payQrCheckPayment),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: state.busy ? null : () => context.pop(),
            icon: const Icon(Icons.replay_rounded),
            label: Text(l10n.payStartAgain),
          ),
        ] else ...[
          const SizedBox(height: 24),
          GoldActionButton(
            label: l10n.payStartAgain,
            icon: Icons.replay_rounded,
            onPressed: () => context.pop(),
          ),
        ],
      ],
    );
  }
}

/// Asks the server to check with the bank; "Checking your payment…" while
/// it runs (up to two checks, 5 seconds apart).
class _CheckPaymentButton extends StatelessWidget {
  const _CheckPaymentButton({required this.state, required this.label});

  final PaymentFlowState state;
  final String label;

  @override
  Widget build(BuildContext context) {
    if (state.checking) {
      return Column(
        children: [
          const SizedBox(
            height: 56,
            child: Center(child: CircularProgressIndicator()),
          ),
          Text(
            context.l10n.payQrChecking,
            style: AppTypography.body(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }
    return GoldActionButton(
      label: label,
      icon: Icons.check_circle_outline_rounded,
      onPressed: state.busy
          ? null
          : () => context.read<PaymentFlowBloc>().add(
              const PaymentCheckRequested(),
            ),
    );
  }
}

class _StepTitle extends StatelessWidget {
  const _StepTitle({
    required this.title,
    required this.body,
    this.center = false,
  });

  final String title;
  final String body;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final align = center ? TextAlign.center : TextAlign.start;
    return Column(
      crossAxisAlignment: center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: align,
          style: AppTypography.displayHeading(
            fontSize: 22,
            color: scheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          body,
          textAlign: align,
          style: AppTypography.body(
            fontSize: 14,
            color: scheme.onSurfaceVariant,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
