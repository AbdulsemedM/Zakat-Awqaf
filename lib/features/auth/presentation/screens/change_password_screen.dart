import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/widgets/zakat_page_header.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_envelope.dart';
import '../../data/password_rules.dart';
import '../../data/repository/auth_repository.dart';

/// Changes the signed-in user's password (`POST /api/auth/v1/me/password`).
///
/// [forced]: the account has a temporary password (`passwordChangeRequired`)
/// and the router shows only this screen until it is changed; the way out
/// is signing out.
///
/// The change ends every session, so the app signs in again with the new
/// password. A wrong current password (400 `CURRENT_PASSWORD_INVALID`) keeps
/// the session; too many failures (429 `TOO_MANY_ATTEMPTS`) are shown and
/// not retried.
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key, this.forced = false});

  final bool forced;

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _repository = getIt<AuthRepository>();
  final _current = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _busy = false;
  bool _obscure = true;
  String? _currentError;
  String? _passwordError;
  String? _confirmError;

  /// A failure that belongs to no field (limits, network).
  String? _error;

  @override
  void dispose() {
    _current.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    final current = _current.text;
    final password = _password.text;
    setState(() {
      _error = null;
      _currentError = current.isEmpty
          ? l10n.changePasswordCurrentRequired
          : null;
      _passwordError = PasswordRules.isStrong(password)
          ? (password == current ? l10n.changePasswordSameAsCurrent : null)
          : l10n.regPasswordRules;
      _confirmError = _confirm.text == password
          ? null
          : l10n.otpPasswordMismatch;
    });
    if (_currentError != null ||
        _passwordError != null ||
        _confirmError != null) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    setState(() => _busy = true);
    try {
      final signedIn = await _repository.changePassword(
        currentPassword: current,
        newPassword: password,
      );
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            signedIn ? l10n.changePasswordDone : l10n.changePasswordSignInAgain,
          ),
        ),
      );
      // Signed in again: the router no longer holds the user here. Signed
      // out: the profile tab shows the sign-in.
      router.go('/profile');
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _onError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _onError(ApiException e) {
    final l10n = context.l10n;
    if (e.noResponse) {
      _error = l10n.otpNetworkError;
      return;
    }
    switch (e.code) {
      case 'CURRENT_PASSWORD_INVALID':
        // The session is still valid: only the field is wrong.
        _currentError = l10n.changePasswordCurrentInvalid;
      case 'WEAK_PASSWORD':
        _passwordError = e.message;
      case 'VALIDATION_FAILED' when e.fieldErrors.isNotEmpty:
        final fields = e.fieldErrors;
        _currentError = fields['currentPassword'];
        _passwordError = fields['newPassword'];
        _confirmError = fields['confirmNewPassword'];
        if (_currentError == null &&
            _passwordError == null &&
            _confirmError == null) {
          _error = e.message;
        }
      default:
        // 429 TOO_MANY_ATTEMPTS says when to try again; no automatic retry.
        _error = e.message;
    }
  }

  Future<void> _signOut() async {
    setState(() => _busy = true);
    await _repository.logout();
    if (mounted) context.go('/profile');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final toggle = IconButton(
      onPressed: () => setState(() => _obscure = !_obscure),
      icon: Icon(
        _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        size: 20,
      ),
    );
    final error = _error;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ZakatPageHeader(
              title: l10n.changePasswordTitle,
              leadingIcon: Icons.lock_reset_rounded,
              onBack: widget.forced ? (_busy ? () {} : _signOut) : null,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.forced
                          ? l10n.changePasswordForcedIntro
                          : l10n.changePasswordIntro,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _current,
                      enabled: !_busy,
                      obscureText: _obscure,
                      autocorrect: false,
                      enableSuggestions: false,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.password],
                      onChanged: (_) => setState(() => _currentError = null),
                      decoration: InputDecoration(
                        labelText: widget.forced
                            ? l10n.changePasswordTemporaryLabel
                            : l10n.changePasswordCurrentLabel,
                        errorText: _currentError,
                        errorMaxLines: 3,
                        prefixIcon: const Icon(Icons.key_outlined),
                        suffixIcon: toggle,
                      ),
                    ),
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
                        labelText: l10n.otpNewPasswordLabel,
                        helperText: l10n.regPasswordRules,
                        helperMaxLines: 5,
                        errorText: _passwordError,
                        errorMaxLines: 4,
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
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
                      onSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: l10n.regConfirmPassword,
                        errorText: _confirmError,
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                      ),
                    ),
                    if (error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        error,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _busy ? null : _submit,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                      ),
                      child: _busy
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: scheme.onPrimary,
                              ),
                            )
                          : Text(l10n.changePasswordButton),
                    ),
                    if (widget.forced) ...[
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _busy ? null : _signOut,
                        child: Text(l10n.profileLogOut),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
