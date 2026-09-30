import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/primary_hero.dart';
import '../../../../app/widgets/app_logo.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../core/common/utils/phone_e164.dart';
import '../../../../core/l10n/l10n.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({this.embeddedInProfile = false, super.key});

  final bool embeddedInProfile;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _localPhoneDigits(String raw) {
    var digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('0')) {
      digits = digits.substring(1);
    }
    return digits;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final localNumber = _localPhoneDigits(_phoneController.text);
    context.read<AuthBloc>().add(
          AuthLoginSubmitted(
            username: '+${PhoneE164.ethiopiaCountryCode}$localNumber',
            password: _passwordController.text,
          ),
        );
  }

  // The form card is always light, so fields use fixed light colours
  // rather than the (possibly dark) theme surface.
  InputDecoration _fieldDecoration({
    required String hint,
    IconData? prefixIcon,
    String? prefixText,
    Widget? suffix,
  }) {
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: color, width: width),
        );
    final error = Theme.of(context).colorScheme.error;
    return InputDecoration(
      hintText: hint,
      prefixIcon: prefixIcon == null
          ? null
          : Padding(
              padding: const EdgeInsetsDirectional.only(start: 14, end: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(prefixIcon, color: AppColors.forestMid),
                  if (prefixText != null) ...[
                    const SizedBox(width: 10),
                    Text(
                      prefixText,
                      style: AppTypography.body(
                        fontSize: 15,
                        color: AppColors.forestMid,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 22,
                      margin: const EdgeInsetsDirectional.only(start: 4),
                      color: AppColors.borderWarm,
                    ),
                  ],
                ],
              ),
            ),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: border(AppColors.borderWarm),
      enabledBorder: border(AppColors.borderWarm),
      focusedBorder: border(AppColors.forestLight, 1.6),
      errorBorder: border(error.withValues(alpha: 0.7)),
      focusedErrorBorder: border(error, 1.6),
      hintStyle: AppTypography.body(fontSize: 15, color: const Color(0xFF8A968F)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final double logoSize = screenWidth.clamp(320.0, 430.0).toDouble() * 0.28;

    return Scaffold(
      backgroundColor: AppColors.emeraldNight,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(gradient: PrimaryHero.zakatHeroGradient),
          ),
          const IslamicPatternLayer(opacity: 0.12, fadeTo: Alignment.bottomCenter),
          const Positioned(
            top: -10,
            right: -60,
            child: CrescentOrnament(size: 170, opacity: 0.13),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is AuthLoading;
                return Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      widget.embeddedInProfile ? 12 : 28,
                      24,
                      24,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _LogoMedallion(size: logoSize),
                            const SizedBox(height: 24),
                            Text(
                              l10n.loginTitle,
                              textAlign: TextAlign.center,
                              style: AppTypography.displayHeading(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const GoldOrnamentDivider(width: 72),
                            const SizedBox(height: 12),
                            Text(
                              l10n.loginSubtitle,
                              textAlign: TextAlign.center,
                              style: AppTypography.body(
                                fontSize: 14,
                                color: AppColors.mintGreen,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 28),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                color: AppColors.ivory,
                                border: Border.all(
                                  color: AppColors.goldLight.withValues(alpha: 0.6),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.30),
                                    blurRadius: 32,
                                    spreadRadius: -6,
                                    offset: const Offset(0, 18),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.next,
                                    enabled: !isLoading,
                                    style: AppTypography.body(
                                      fontSize: 15,
                                      color: AppColors.ink,
                                    ),
                                    inputFormatters: [
                                      _EthiopianLocalPhoneInputFormatter(),
                                    ],
                                    decoration: _fieldDecoration(
                                      hint: l10n.loginPhoneLabel,
                                      prefixIcon: Icons.phone_outlined,
                                      prefixText:
                                          '+${PhoneE164.ethiopiaCountryCode}',
                                    ),
                                    validator: (value) {
                                      final digits = _localPhoneDigits(value ?? '');
                                      if (digits.isEmpty) {
                                        return l10n.loginPhoneRequired;
                                      }
                                      if (!RegExp(r'^9\d{8}$').hasMatch(digits)) {
                                        return l10n.loginPhoneInvalid;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 14),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    textInputAction: TextInputAction.done,
                                    enabled: !isLoading,
                                    style: AppTypography.body(
                                      fontSize: 15,
                                      color: AppColors.ink,
                                    ),
                                    onFieldSubmitted: (_) => _submit(),
                                    decoration: _fieldDecoration(
                                      hint: l10n.loginPasswordLabel,
                                      prefixIcon: Icons.lock_outline_rounded,
                                      suffix: IconButton(
                                        onPressed: isLoading
                                            ? null
                                            : () => setState(
                                                  () => _obscurePassword = !_obscurePassword,
                                                ),
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: AppColors.mutedText,
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
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: TextButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(l10n.loginForgotPasswordComingSoon),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.goldDeep,
                                        minimumSize: const Size(0, 36),
                                        padding: const EdgeInsets.symmetric(horizontal: 6),
                                      ),
                                      child: Text(
                                        l10n.loginForgotPassword,
                                        style: AppTypography.body(
                                          fontSize: 13,
                                          color: AppColors.goldDeep,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _GoldSubmitButton(
                                    label: l10n.loginButton,
                                    loading: isLoading,
                                    onPressed: isLoading ? null : _submit,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 22),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.shield_outlined,
                                  size: 16,
                                  color: AppColors.goldLight,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    l10n.loginSecureNote,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.body(
                                      fontSize: 12,
                                      color: AppColors.mintGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  l10n.loginNewToBaraka,
                                  style: AppTypography.body(
                                    fontSize: 13,
                                    color: AppColors.mintGreenMuted,
                                  ),
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(l10n.loginCreateAccountComingSoon),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      l10n.loginCreateAccount,
                                      style: AppTypography.body(
                                        fontSize: 13,
                                        color: AppColors.goldLight,
                                        fontWeight: FontWeight.w700,
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

/// Logo on an emerald disc framed by a double gold ring.
class _LogoMedallion extends StatelessWidget {
  const _LogoMedallion({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.goldLight.withValues(alpha: 0.35)),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [Colors.white, AppColors.parchment],
          ),
          border: Border.all(color: AppColors.warmGold, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.warmGold.withValues(alpha: 0.25),
              blurRadius: 24,
            ),
          ],
        ),
        child: Center(
          child: AppLogo(
            height: size * 0.46,
            width: size * 0.56,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _GoldSubmitButton extends StatelessWidget {
  const _GoldSubmitButton({
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  final String label;
  final bool loading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: PrimaryHero.sadaqahGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.goldDeep.withValues(alpha: 0.30),
            blurRadius: 16,
            spreadRadius: -4,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: AppColors.emeraldNight,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        onPressed: onPressed,
        child: loading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.emeraldNight,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: AppTypography.body(
                      fontSize: 16,
                      color: AppColors.emeraldNight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
      ),
    );
  }
}

/// Strips a leading `0` from Ethiopian local numbers (e.g. `0923…` → `923…`).
class _EthiopianLocalPhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('0')) {
      digits = digits.substring(1);
    }
    if (digits.length > 9) {
      digits = digits.substring(0, 9);
    }

    return TextEditingValue(
      text: digits,
      selection: TextSelection.collapsed(offset: digits.length),
    );
  }
}
