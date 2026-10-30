import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/widgets/zakat_page_header.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/login_identifier.dart';
import '../../data/models/otp_challenge.dart';
import '../../data/password_rules.dart';
import '../../data/repository/auth_repository.dart';

/// The account flows confirmed by an SMS code.
enum OtpFlowKind {
  /// Public: a new password for the account of a phone number.
  passwordReset,

  /// Public: a new donor account, signed in at the end.
  donorSignup,

  /// Signed in: a new phone number (the login), then sign in again.
  phoneChange,
}

/// Step 1 asks for the phone number (and the name, for a sign-up) and
/// sends the code; step 2 takes the code (and the new password, except for
/// a phone change). Pops with a message for the screen below to show, or
/// `null` (cancelled, or signed in by a sign-up).
///
/// The server's `message` is written for the user, so it is shown as is.
class OtpFlowScreen extends StatefulWidget {
  const OtpFlowScreen({super.key, required this.kind});

  final OtpFlowKind kind;

  @override
  State<OtpFlowScreen> createState() => _OtpFlowScreenState();
}

class _OtpFlowScreenState extends State<OtpFlowScreen> {
  final _repository = getIt<AuthRepository>();
  final _phone = TextEditingController();
  final _fullName = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  /// Set once a code was sent: step 2.
  OtpChallenge? _challenge;
  bool _busy = false;
  bool _obscure = true;
  String? _phoneError;
  String? _nameError;
  String? _codeError;
  String? _passwordError;
  String? _confirmError;

  bool get _asksPassword => widget.kind != OtpFlowKind.phoneChange;

  @override
  void dispose() {
    _phone.dispose();
    _fullName.dispose();
    _code.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final l10n = context.l10n;
    final phone = LoginIdentifier.resolvePhone(_phone.text);
    final fullName = _fullName.text.trim();
    setState(() {
      _phoneError = phone == null ? l10n.payPayerPhoneInvalid : null;
      _nameError = widget.kind == OtpFlowKind.donorSignup && fullName.isEmpty
          ? l10n.otpFullNameRequired
          : null;
    });
    if (phone == null || _nameError != null) return;
    await _run(() async {
      final challenge = await switch (widget.kind) {
        OtpFlowKind.passwordReset => _repository.startPasswordReset(phone),
        OtpFlowKind.donorSignup => _repository.startDonorSignup(
          phone: phone,
          fullName: fullName,
        ),
        OtpFlowKind.phoneChange => _repository.startPhoneChange(phone),
      };
      if (!mounted) return;
      setState(() {
        _challenge = challenge;
        _code.clear();
        _codeError = null;
      });
    });
  }

  Future<void> _resend() async {
    final id = _challenge?.id;
    if (id == null) return;
    await _run(() async {
      final challenge = await switch (widget.kind) {
        OtpFlowKind.passwordReset => _repository.resendPasswordReset(id),
        OtpFlowKind.donorSignup => _repository.resendDonorSignup(id),
        OtpFlowKind.phoneChange => _repository.resendPhoneChange(id),
      };
      if (!mounted) return;
      setState(() {
        _challenge = challenge;
        _code.clear();
        _codeError = null;
      });
      _showSnack(context.l10n.otpCodeResent);
    });
  }

  Future<void> _verify() async {
    final id = _challenge?.id;
    if (id == null) return;
    final l10n = context.l10n;
    final code = _code.text.trim();
    final password = _password.text;
    setState(() {
      _codeError = RegExp(r'^\d{4,8}$').hasMatch(code)
          ? null
          : l10n.otpCodeRequired;
      _passwordError = !_asksPassword || PasswordRules.isStrong(password)
          ? null
          : l10n.regPasswordRules;
      _confirmError = !_asksPassword || _confirm.text == password
          ? null
          : l10n.otpPasswordMismatch;
    });
    if (_codeError != null || _passwordError != null || _confirmError != null) {
      return;
    }
    await _run(() async {
      switch (widget.kind) {
        case OtpFlowKind.passwordReset:
          await _repository.confirmPasswordReset(
            id,
            code: code,
            newPassword: password,
          );
          _finish(l10n.otpResetDone);
        case OtpFlowKind.donorSignup:
          final signedIn = await _repository.completeDonorSignup(
            id,
            otp: code,
            password: password,
          );
          _finish(signedIn ? null : l10n.otpSignupLoginNeeded);
        case OtpFlowKind.phoneChange:
          await _repository.completePhoneChange(id, code: code);
          _finish(l10n.otpChangePhoneDone);
      }
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } on ApiException catch (e) {
      if (mounted) setState(() => _onError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _onError(ApiException e) {
    final l10n = context.l10n;
    final challenge = _challenge;
    if (challenge != null && e.data.isNotEmpty) {
      _challenge = challenge.withLimitsFrom(e.data);
    }
    if (e.noResponse) {
      _showSnack(l10n.otpNetworkError);
      return;
    }
    switch (e.code) {
      case 'OTP_WRONG' || 'OTP_EXPIRED':
        final attempts = _challenge?.attemptsLeft;
        _codeError = attempts == null
            ? e.message
            : '${e.message}\n${l10n.otpAttemptsLeft(attempts)}';
      case 'WEAK_PASSWORD':
        _passwordError = e.message;
      case 'INVALID_PHONE' || 'SAME_PHONE' || 'PHONE_ALREADY_REGISTERED':
        _restart();
        _phoneError = e.message;
      case 'ALREADY_COMPLETED' when widget.kind == OtpFlowKind.donorSignup:
        // The account exists: sign in. (Not inside this setState.)
        Future.microtask(() => _finish(e.message));
      case 'VALIDATION_FAILED' when e.fieldErrors.isNotEmpty:
        final fields = e.fieldErrors;
        _codeError = fields['code'] ?? fields['otp'];
        _passwordError = fields['newPassword'] ?? fields['password'];
        _phoneError =
            fields['username'] ?? fields['phone'] ?? fields['newPhone'];
        _nameError = fields['fullName'];
        if (_phoneError != null || _nameError != null) _restart();
      default:
        // Locked, expired, used or unknown: this code can't be used any
        // more. Limits (429) and an unavailable SMS service (503) leave it.
        if (challenge != null &&
            (e.code == 'OTP_LOCKED' ||
                e.statusCode == 404 ||
                e.statusCode == 409)) {
          _restart();
        }
        _showSnack(e.message);
    }
  }

  /// Back to step 1, keeping what was typed there.
  void _restart() {
    _challenge = null;
    _code.clear();
    _codeError = null;
  }

  void _finish(String? message) {
    if (mounted) context.pop(message);
  }

  void _showSnack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final challenge = _challenge;
    final (title, intro) = switch (widget.kind) {
      OtpFlowKind.passwordReset => (l10n.otpResetTitle, l10n.otpResetIntro),
      OtpFlowKind.donorSignup => (l10n.loginCreateAccount, l10n.otpSignupIntro),
      OtpFlowKind.phoneChange => (
        l10n.otpChangePhoneTitle,
        l10n.otpChangePhoneIntro,
      ),
    };
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ZakatPageHeader(title: title, leadingIcon: Icons.sms_outlined),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: AutofillGroup(
                child: challenge == null
                    ? _phoneStep(l10n, intro)
                    : _codeStep(l10n, challenge),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _phoneStep(AppLocalizations l10n, String intro) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          intro,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        if (widget.kind == OtpFlowKind.donorSignup) ...[
          TextField(
            controller: _fullName,
            enabled: !_busy,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.name],
            onChanged: (_) => setState(() => _nameError = null),
            decoration: InputDecoration(
              labelText: l10n.payPayerNameLabel,
              errorText: _nameError,
              prefixIcon: const Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: 14),
        ],
        TextField(
          controller: _phone,
          enabled: !_busy,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.telephoneNumber],
          onChanged: (_) => setState(() => _phoneError = null),
          onSubmitted: (_) => _send(),
          decoration: InputDecoration(
            labelText: widget.kind == OtpFlowKind.phoneChange
                ? l10n.otpNewPhoneLabel
                : l10n.profilePhoneNumber,
            hintText: l10n.regPhoneHint,
            errorText: _phoneError,
            errorMaxLines: 3,
            prefixIcon: const Icon(Icons.phone_outlined),
          ),
        ),
        const SizedBox(height: 24),
        _SubmitButton(label: l10n.otpSendCode, busy: _busy, onPressed: _send),
      ],
    );
  }

  Widget _codeStep(AppLocalizations l10n, OtpChallenge challenge) {
    final theme = Theme.of(context);
    final passwordToggle = IconButton(
      onPressed: () => setState(() => _obscure = !_obscure),
      icon: Icon(
        _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        size: 20,
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.otpCodeSentTo(
            challenge.maskedPhone ??
                LoginIdentifier.resolvePhone(_phone.text) ??
                _phone.text,
          ),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _code,
          enabled: !_busy,
          keyboardType: TextInputType.number,
          textInputAction: _asksPassword
              ? TextInputAction.next
              : TextInputAction.done,
          autofillHints: const [AutofillHints.oneTimeCode],
          maxLength: 8,
          onChanged: (_) => setState(() => _codeError = null),
          onSubmitted: (_) => _asksPassword ? null : _verify(),
          decoration: InputDecoration(
            labelText: l10n.otpCodeLabel,
            errorText: _codeError,
            errorMaxLines: 3,
            counterText: '',
            prefixIcon: const Icon(Icons.pin_outlined),
          ),
        ),
        if (_asksPassword) ...[
          const SizedBox(height: 14),
          TextField(
            controller: _password,
            enabled: !_busy,
            obscureText: _obscure,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.newPassword],
            onChanged: (_) => setState(() => _passwordError = null),
            decoration: InputDecoration(
              labelText: widget.kind == OtpFlowKind.passwordReset
                  ? l10n.otpNewPasswordLabel
                  : l10n.regPassword,
              helperText: l10n.regPasswordRules,
              helperMaxLines: 3,
              errorText: _passwordError,
              errorMaxLines: 3,
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: passwordToggle,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _confirm,
            enabled: !_busy,
            obscureText: _obscure,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            onChanged: (_) => setState(() => _confirmError = null),
            onSubmitted: (_) => _verify(),
            decoration: InputDecoration(
              labelText: l10n.regConfirmPassword,
              errorText: _confirmError,
              prefixIcon: const Icon(Icons.lock_outline_rounded),
            ),
          ),
        ],
        const SizedBox(height: 24),
        _SubmitButton(
          label: switch (widget.kind) {
            OtpFlowKind.passwordReset => l10n.otpResetButton,
            OtpFlowKind.donorSignup => l10n.otpSignupButton,
            OtpFlowKind.phoneChange => l10n.otpChangePhoneButton,
          },
          busy: _busy,
          onPressed: _verify,
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: _busy || !challenge.canResend ? null : _resend,
              child: Text(l10n.otpResend),
            ),
            TextButton(
              onPressed: _busy ? null : () => setState(_restart),
              child: Text(l10n.otpUseAnotherNumber),
            ),
          ],
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.label,
    required this.busy,
    required this.onPressed,
  });

  final String label;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FilledButton(
      onPressed: busy ? null : onPressed,
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54)),
      child: busy
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: scheme.onPrimary,
              ),
            )
          : Text(label),
    );
  }
}
