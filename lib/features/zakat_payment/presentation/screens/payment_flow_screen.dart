import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../app/widgets/zakat_page_header.dart';
import '../../../../core/common/utils/money_formatter.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/l10n.dart';
import '../../bloc/payment_flow_bloc.dart';
import '../../data/models/zakat_payment_models.dart';
import '../widgets/payment_countdown.dart';

/// Steps 2–3 of a zakat payment and its result: confirm the account, enter
/// the code, then paid / declined / still confirming.
class PaymentFlowScreen extends StatelessWidget {
  const PaymentFlowScreen({super.key, required this.payment});

  final ZakatPayment payment;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PaymentFlowBloc>(param1: payment),
      child: const _PaymentFlowView(),
    );
  }
}

class _PaymentFlowView extends StatelessWidget {
  const _PaymentFlowView();

  /// Leaving before the transfer: ask, then cancel the payment. While the
  /// bank is processing, leaving only stops watching (it can't be undone).
  Future<void> _onBack(BuildContext context, PaymentFlowState state) async {
    final payment = state.payment;
    final waitingForDonor =
        payment.status == PaymentStatus.pending &&
        payment.step != PaymentStep.processing;
    if (!waitingForDonor) {
      context.pop();
      return;
    }
    final l10n = context.l10n;
    final bloc = context.read<PaymentFlowBloc>();
    final cancel = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.payCancelConfirmTitle),
        content: Text(l10n.payCancelConfirmBody),
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
                    title: l10n.payTitleZakat,
                    leadingIcon: Icons.verified_user_outlined,
                    onBack: () => _onBack(context, state),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                    child: switch ((payment.status, payment.step)) {
                      (PaymentStatus.pending, PaymentStep.confirmAccount) =>
                        _ConfirmAccountStep(state: state),
                      (PaymentStatus.pending, PaymentStep.enterOtp) => _OtpStep(
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
  const _PaymentSummary({required this.payment, this.showAccount = false});

  final ZakatPayment payment;
  final bool showAccount;

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
          if (showAccount) ...[
            const Divider(height: 24),
            _InfoRow(
              label: l10n.payAccountHolder,
              value: payment.accountHolderName ?? '—',
              emphasize: true,
            ),
            const SizedBox(height: 8),
            _InfoRow(
              label: l10n.payAccountNumberShort,
              value: payment.accountNumber ?? '—',
            ),
            if (payment.methodLabel != null) ...[
              const SizedBox(height: 8),
              _InfoRow(label: l10n.payMethod, value: payment.methodLabel!),
            ],
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: AppTypography.body(
              fontSize: 13,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTypography.body(
              fontSize: emphasize ? 16 : 14,
              color: scheme.onSurface,
              fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// "Finish within 12:34": the time left before the payment expires (15
/// minutes from step 1). At zero, reloads it so the server's `expired`
/// state is shown.
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
      onFinished: () => bloc.add(const PaymentStatusRefreshRequested()),
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

/// Step 2: "Is this your account?"
class _ConfirmAccountStep extends StatelessWidget {
  const _ConfirmAccountStep({required this.state});

  final PaymentFlowState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<PaymentFlowBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepTitle(title: l10n.payConfirmTitle, body: l10n.payConfirmBody),
        const SizedBox(height: 16),
        _PaymentSummary(payment: state.payment, showAccount: true),
        _PaymentDeadline(payment: state.payment),
        _ErrorText(state.errorMessage),
        const SizedBox(height: 20),
        if (state.busy)
          const Center(child: CircularProgressIndicator())
        else ...[
          GoldActionButton(
            label: l10n.payYesSendCode,
            icon: Icons.sms_outlined,
            onPressed: () => bloc.add(const PaymentAccountConfirmed()),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => bloc.add(const PaymentCancelRequested()),
            child: Text(l10n.payNotMyAccount),
          ),
        ],
      ],
    );
  }
}

/// Step 3: enter the code and pay.
class _OtpStep extends StatefulWidget {
  const _OtpStep({required this.state});

  final PaymentFlowState state;

  @override
  State<_OtpStep> createState() => _OtpStepState();
}

class _OtpStepState extends State<_OtpStep> {
  final _otp = TextEditingController();

  @override
  void dispose() {
    _otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<PaymentFlowBloc>();
    final state = widget.state;
    final payment = state.payment;
    final attemptsLeft = payment.otpAttemptsLeft;
    final complete = _otp.text.length == 6;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepTitle(title: l10n.payOtpTitle, body: l10n.payOtpBody),
        const SizedBox(height: 16),
        _PaymentSummary(payment: payment),
        _PaymentDeadline(payment: payment),
        const SizedBox(height: 16),
        TextField(
          controller: _otp,
          autofocus: true,
          enabled: !state.busy,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          onChanged: (_) => setState(() {}),
          style: AppTypography.body(
            fontSize: 26,
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w800,
            letterSpacing: 8,
          ),
          decoration: InputDecoration(
            labelText: l10n.payOtpLabel,
            helperText: attemptsLeft == null
                ? null
                : l10n.payOtpAttemptsLeft(attemptsLeft),
            errorText: state.errorMessage,
            errorMaxLines: 3,
          ),
        ),
        if (payment.otpExpiresAt != null)
          PaymentCountdown(
            deadline: payment.otpExpiresAt!,
            builder: (context, remaining) => Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                remaining == Duration.zero
                    ? l10n.payOtpExpiredLocal
                    : l10n.payOtpExpiresIn(formatCountdown(remaining)),
                style: AppTypography.body(
                  fontSize: 12,
                  color: remaining == Duration.zero
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        const SizedBox(height: 8),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton.icon(
            onPressed: state.busy || !state.canResend
                ? null
                : () {
                    _otp.clear();
                    bloc.add(const PaymentOtpResendRequested());
                  },
            icon: Icon(
              Icons.refresh,
              color: state.otpExpired ? AppColors.goldDeep : null,
            ),
            label: Text(l10n.payResendCode),
          ),
        ),
        const SizedBox(height: 12),
        if (state.busy)
          const Center(child: CircularProgressIndicator())
        else
          GoldActionButton(
            label: l10n.payPayAmount(MoneyFormatter.etb(payment.amountEtb)),
            icon: Icons.lock_outline_rounded,
            onPressed: complete
                ? () => bloc.add(PaymentOtpSubmitted(_otp.text))
                : null,
          ),
      ],
    );
  }
}

/// The bank has not answered yet; the bloc polls.
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
          body: l10n.paySucceededBody(MoneyFormatter.etb(payment.amountEtb)),
          center: true,
        ),
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
            label: l10n.payViewCertificate,
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

/// Failed, cancelled or expired: nothing was taken, start again.
class _EndedResult extends StatelessWidget {
  const _EndedResult({required this.state});

  final PaymentFlowState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final payment = state.payment;
    final (title, body) = switch (payment.status) {
      PaymentStatus.cancelled => (l10n.payCancelledTitle, l10n.payNoMoneyTaken),
      PaymentStatus.expired => (l10n.payExpiredTitle, l10n.payExpiredBody),
      _ => (
        l10n.payFailedTitle,
        [
          payment.failureReason ?? state.errorMessage,
          l10n.payNoMoneyTaken,
        ].whereType<String>().join('\n'),
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
        const SizedBox(height: 24),
        GoldActionButton(
          label: l10n.payStartAgain,
          icon: Icons.replay_rounded,
          onPressed: () => context.pop(),
        ),
      ],
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
