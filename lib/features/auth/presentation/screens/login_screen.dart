import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/app_logo.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../core/l10n/l10n.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';
import '../../data/login_identifier.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({this.embeddedInProfile = false, super.key});

  final bool embeddedInProfile;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final username = LoginIdentifier.resolve(_identifierController.text);
    if (username == null) {
      return;
    }
    context.read<AuthBloc>().add(
      AuthLoginSubmitted(
        username: username,
        password: _passwordController.text,
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffix,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return InputDecoration(
      hintText: hint,
      prefixIcon: Padding(
        padding: const EdgeInsetsDirectional.only(start: 16, end: 12),
        child: Icon(prefixIcon, size: 20, color: scheme.onSurfaceVariant),
      ),
      prefixIconConstraints: const BoxConstraints(),
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // A soft emerald wash at the top with a barely-there lattice.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    scheme.primary.withValues(alpha: 0.10),
                    scheme.primary.withValues(alpha: 0),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  IslamicPatternLayer(
                    color: scheme.primary,
                    opacity: 0.07,
                    cell: 40,
                    fadeTo: Alignment.bottomCenter,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  if (!widget.embeddedInProfile) {
                    context.go('/profile');
                  }
                }
                if (state is AuthFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                final isLoading = state is AuthLoading;
                return Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      28,
                      widget.embeddedInProfile ? 16 : 32,
                      28,
                      28,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Center(child: AppLogo(height: 68)),
                            const SizedBox(height: 18),
                            Text(
                              l10n.appTitle.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: AppTypography.label(
                                fontSize: 11,
                                color: scheme.onSurfaceVariant,
                                letterSpacing: 2.2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 36),
                            Text(
                              l10n.loginTitle,
                              textAlign: TextAlign.center,
                              style: AppTypography.displayHeading(
                                fontSize: 28,
                                color: scheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              l10n.loginSubtitle,
                              textAlign: TextAlign.center,
                              style: AppTypography.body(
                                fontSize: 14,
                                color: scheme.onSurfaceVariant,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 32),
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _identifierController,
                              builder: (context, value, _) {
                                final isEmail = LoginIdentifier.looksLikeEmail(
                                  value.text,
                                );
                                return TextFormField(
                                  controller: _identifierController,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  enabled: !isLoading,
                                  autofillHints: const [AutofillHints.username],
                                  decoration: _fieldDecoration(
                                    hint: l10n.loginIdentifierLabel,
                                    prefixIcon: isEmail
                                        ? Icons.alternate_email_rounded
                                        : Icons.phone_outlined,
                                  ),
                                  validator: (input) {
                                    final text = (input ?? '').trim();
                                    if (text.isEmpty) {
                                      return l10n.loginIdentifierRequired;
                                    }
                                    return LoginIdentifier.resolve(text) == null
                                        ? l10n.loginIdentifierInvalid
                                        : null;
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              enabled: !isLoading,
                              autofillHints: const [AutofillHints.password],
                              onFieldSubmitted: (_) => _submit(),
                              decoration: _fieldDecoration(
                                hint: l10n.loginPasswordLabel,
                                prefixIcon: Icons.lock_outline_rounded,
                                suffix: IconButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => setState(
                                          () => _obscurePassword =
                                              !_obscurePassword,
                                        ),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 20,
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.loginPasswordRequired;
                                }
                                return null;
                              },
                            ),
                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.loginForgotPasswordComingSoon,
                                      ),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(0, 40),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                ),
                                child: Text(
                                  l10n.loginForgotPassword,
                                  style: AppTypography.body(
                                    fontSize: 13,
                                    color: scheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            FilledButton(
                              onPressed: isLoading ? null : _submit,
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(54),
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: scheme.onPrimary,
                                      ),
                                    )
                                  : Text(l10n.loginButton),
                            ),
                            const SizedBox(height: 28),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(color: scheme.outlineVariant),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: GoldOrnamentDivider(width: 22),
                                ),
                                Expanded(
                                  child: Divider(color: scheme.outlineVariant),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  l10n.loginNewToBaraka,
                                  style: AppTypography.body(
                                    fontSize: 13,
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          l10n.loginCreateAccountComingSoon,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 6,
                                    ),
                                    child: Text(
                                      l10n.loginCreateAccount,
                                      style: AppTypography.body(
                                        fontSize: 13,
                                        color: scheme.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lock_outline_rounded,
                                  size: 13,
                                  color: scheme.onSurfaceVariant.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    l10n.loginSecureNote,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.body(
                                      fontSize: 11.5,
                                      color: scheme.onSurfaceVariant.withValues(
                                        alpha: 0.85,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
