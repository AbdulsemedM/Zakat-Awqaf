import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/primary_hero.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../app/widgets/zakat_page_header.dart';
import '../../../../core/auth/payer_access.dart';
import '../../../../core/common/utils/money_formatter.dart';
import '../../../../core/common/utils/phone_e164.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/uuid.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../causes/data/models/cause.dart';
import '../../../zakat_calculator/bloc/zakat_calculator_state.dart';
import '../../data/models/zakat_payment_models.dart';
import '../../data/repository/zakat_payment_repository.dart';
import '../models/zakat_payment_args.dart';
import '../../../../core/network/https_url.dart';

/// Start of a zakat payment: amount, project and method; a guest also gives
/// the name for the certificate (a signed-in donor's comes from the
/// account). "Pay by QR" creates the QR, shown on [`PaymentFlowScreen`].
class ZakatPaymentScreen extends StatefulWidget {
  const ZakatPaymentScreen({super.key, required this.args});

  final ZakatPaymentArgs args;

  @override
  State<ZakatPaymentScreen> createState() => _ZakatPaymentScreenState();
}

class _ZakatPaymentScreenState extends State<ZakatPaymentScreen> {
  final _amount = TextEditingController();
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  bool _anonymous = false;
  final _repository = getIt<ZakatPaymentRepository>();
  final _payerAccess = getIt<PayerAccess>();

  /// Sent as `causeId`: the cause the payment was started from, else the
  /// general fund. Not a choice on this screen.
  late String _causeId;

  List<PaymentMethod> _methods = const [];
  bool _methodsLoading = true;
  bool _methodsFailed = false;
  String? _methodCode;

  /// One key per attempt. Kept while the inputs stay the same, so repeating
  /// step 1 after no response returns the same payment (and, for a guest, a
  /// new token) instead of starting a second one. Changing the amount,
  /// payer or project makes it a new attempt with a new key.
  String _idempotencyKey = uuidV4();

  void _inputsChanged() => _idempotencyKey = uuidV4();
  bool _starting = false;
  String? _amountError;
  String? _fullNameError;
  String? _phoneError;

  @override
  void initState() {
    super.initState();
    final prefillAmount = widget.args.fixedAmountEtb;
    if (prefillAmount != null && prefillAmount > 0) {
      _amount.text = _formatEtbInput(prefillAmount);
    }
    _causeId = widget.args.initialCauseId ?? Cause.generalFundId;
    _loadMethods();
  }

  @override
  void dispose() {
    _amount.dispose();
    _fullName.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _loadMethods() async {
    setState(() {
      _methodsLoading = true;
      _methodsFailed = false;
    });
    try {
      final methods = await _repository.fetchMethods();
      if (!mounted) return;
      final usable = methods.where((m) => m.available && m.isQr);
      setState(() {
        _methods = methods;
        _methodCode = usable.firstOrNull?.code;
        _methodsLoading = false;
      });
    } on ApiException {
      if (!mounted) return;
      setState(() {
        _methodsLoading = false;
        _methodsFailed = true;
      });
    }
  }

  PaymentMethod? get _method {
    for (final method in _methods) {
      if (method.code == _methodCode) return method;
    }
    return null;
  }

  /// A guest gives the name printed on the certificate.
  bool get _needsPayerName => !_payerAccess.isSignedInDonor;

  double get _amountEtb {
    final a = widget.args;
    if (a.amountEntryMode == ZakatAmountEntryMode.fixed) {
      return a.fixedAmountEtb ?? 0;
    }
    return double.tryParse(_amount.text.replaceAll(',', '')) ?? 0;
  }

  String? _validateAmount(AppLocalizations l10n) {
    final amount = _amountEtb;
    if (amount <= 0) return l10n.payEnterAmount;
    final min = _method?.minAmountEtb;
    final max = _method?.maxAmountEtb;
    if ((min != null && amount < min) || (max != null && amount > max)) {
      return l10n.payAmountOutOfRange(
        MoneyFormatter.etb(min ?? 0),
        max == null ? '—' : MoneyFormatter.etb(max),
      );
    }
    return null;
  }

  bool get _canContinue =>
      !_starting &&
      _method != null &&
      _amountEtb > 0 &&
      (!_needsPayerName || _fullName.text.trim().isNotEmpty);

  /// `payer` for the request, or `null` when there is nothing to send.
  PaymentPayer? _payer() {
    final fullName = _needsPayerName ? _fullName.text.trim() : null;
    final phone = _needsPayerName && _phone.text.trim().isNotEmpty
        ? PhoneE164.normalize(_phone.text)
        : null;
    if (fullName == null && phone == null && !_anonymous) return null;
    return PaymentPayer(
      fullName: fullName,
      phone: phone,
      anonymous: _anonymous,
    );
  }

  Future<void> _onContinue() async {
    final l10n = context.l10n;
    final method = _method;
    if (method == null) return;
    final amountError = _validateAmount(l10n);
    final fullNameError = !_needsPayerName || _fullName.text.trim().isNotEmpty
        ? null
        : l10n.payPayerNameRequired;
    final phone = _phone.text.trim();
    final phoneError =
        !_needsPayerName || phone.isEmpty || PhoneE164.normalize(phone) != null
        ? null
        : l10n.payPayerPhoneInvalid;
    setState(() {
      _amountError = amountError;
      _fullNameError = fullNameError;
      _phoneError = phoneError;
    });
    if (amountError != null || fullNameError != null || phoneError != null) {
      return;
    }

    setState(() => _starting = true);
    try {
      final payment = await _repository.startPayment(
        ZakatPaymentRequest(
          purpose: widget.args.purpose,
          zakatType: widget.args.zakatType,
          amountEtb: _amountEtb,
          methodCode: method.code,
          causeId: _causeId,
          payer: _payer(),
          idempotencyKey: _idempotencyKey,
          calculation: widget.args.calculation,
        ),
      );
      if (!mounted) return;
      setState(() => _starting = false);
      await context.push('/zakat/payment/flow', extra: payment);
      // Whatever happened there, a new attempt needs a new key.
      if (mounted) setState(() => _idempotencyKey = uuidV4());
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _starting = false;
        _showStartError(l10n, e);
      });
    }
  }

  void _showStartError(AppLocalizations l10n, ApiException e) {
    switch (e.code) {
      case 'AMOUNT_OUT_OF_RANGE':
        _amountError = e.message;
        return;
      case 'VALIDATION_FAILED' || 'INVALID_REQUEST':
        _amountError = e.fieldErrors['amountEtb'];
        _fullNameError = e.fieldErrors['payer.fullName'];
        _phoneError = e.fieldErrors['payer.phone'];
        if (_amountError != null ||
            _fullNameError != null ||
            _phoneError != null) {
          return;
        }
      case 'DUPLICATE_REQUEST':
        _idempotencyKey = uuidV4();
      case 'CAUSE_INVALID':
        // The cause ended or stopped accepting zakat: the next attempt goes
        // to the general fund.
        _causeId = Cause.generalFundId;
        _inputsChanged();
    }
    final message = e.noResponse ? l10n.payNetworkError : e.message;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final a = widget.args;
    const gap = SizedBox(height: 16);

    return ListenableBuilder(
      listenable: _payerAccess,
      builder: (context, _) {
        final canPay = _payerAccess.canPay;
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ZakatPageHeader(
                  title: a.title ?? l10n.payTitleZakat,
                  subtitle: a.subtitle ?? l10n.paySubtitleZakat,
                  leadingIcon: Icons.verified_user_outlined,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!canPay) ...[
                        _NoticeCard(text: l10n.payNotAllowedBeneficiary),
                        gap,
                      ],
                      if (a.overviewTitle != null) ...[
                        _OverviewCard(args: a),
                        gap,
                      ],
                      PremiumCard(
                        child: _AmountSection(
                          args: a,
                          controller: _amount,
                          errorText: _amountError,
                          onChanged: () => setState(() {
                            _amountError = null;
                            _inputsChanged();
                          }),
                        ),
                      ),
                      gap,
                      // No project choice: zakat goes to the general fund,
                      // or to the cause it was started from (fixed).
                      if (_causeId != Cause.generalFundId) ...[
                        PremiumCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ZakatFormSectionTitle(
                                icon: Icons.volunteer_activism_outlined,
                                label: l10n.payBeneficiary,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                a.initialCauseTitle ?? _causeId,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ),
                        gap,
                      ],
                      PremiumCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ZakatFormSectionTitle(
                              icon: Icons.account_balance_wallet_outlined,
                              label: l10n.payMethod,
                            ),
                            const SizedBox(height: 14),
                            ..._methodSection(l10n),
                          ],
                        ),
                      ),
                      gap,
                      PremiumCard(child: _payerSection(l10n)),
                      gap,
                      const _ImpactNote(),
                      const SizedBox(height: 14),
                      const _SecurityRow(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: _starting
                  ? const SizedBox(
                      height: 56,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : GoldActionButton(
                      label: l10n.payByQr,
                      icon: Icons.qr_code_2_rounded,
                      onPressed: canPay && _canContinue ? _onContinue : null,
                    ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _methodSection(AppLocalizations l10n) {
    if (_methodsLoading) {
      return [
        Row(
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 10),
            Text(l10n.payMethodsLoading),
          ],
        ),
      ];
    }
    if (_methodsFailed) {
      return [
        Text(l10n.payMethodsError),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: _loadMethods,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.commonRetry),
          ),
        ),
      ];
    }
    if (_methods.isEmpty) return [Text(l10n.payNoMethods)];
    return [
      for (final (index, method) in _methods.indexed) ...[
        if (index > 0) const SizedBox(height: 10),
        _MethodTile(
          method: method,
          selected: method.code == _methodCode,
          onTap: method.available && method.isQr
              ? () => setState(() {
                  _methodCode = method.code;
                  _inputsChanged();
                })
              : null,
        ),
      ],
    ];
  }

  /// Name for the certificate (guests) and the anonymous option.
  Widget _payerSection(AppLocalizations l10n) {
    void changed(VoidCallback clear) => setState(() {
      clear();
      _inputsChanged();
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ZakatFormSectionTitle(
          icon: Icons.workspace_premium_outlined,
          label: l10n.payCertificateSection,
        ),
        if (_needsPayerName) ...[
          const SizedBox(height: 14),
          TextField(
            controller: _fullName,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            onChanged: (_) => changed(() => _fullNameError = null),
            decoration: InputDecoration(
              labelText: l10n.payPayerNameLabel,
              helperText: widget.args.purpose == PaymentPurpose.sadaqah
                  ? l10n.payPayerNameHelperSadaqah
                  : l10n.payPayerNameHelper,
              helperMaxLines: 2,
              errorText: _fullNameError,
              prefixIcon: const Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d+ ]')),
              LengthLimitingTextInputFormatter(16),
            ],
            onChanged: (_) => changed(() => _phoneError = null),
            decoration: InputDecoration(
              labelText: l10n.payPayerPhoneLabel,
              errorText: _phoneError,
              prefixIcon: const Icon(Icons.phone_outlined),
            ),
          ),
        ],
        const SizedBox(height: 4),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          value: _anonymous,
          onChanged: (v) => changed(() => _anonymous = v),
          title: Text(l10n.payAnonymousLabel),
          subtitle: Text(l10n.payAnonymousHelper),
        ),
      ],
    );
  }
}

String _formatEtbInput(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(2);
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: scheme.onErrorContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTypography.body(
                fontSize: 13,
                color: scheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Emerald summary of what the calculator worked out (Zakat only).
class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.args});

  final ZakatPaymentArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: PrimaryHero.zakatHeroGradient,
          border: Border.all(
            color: AppColors.goldLight.withValues(alpha: 0.35),
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Stack(
          children: [
            const IslamicPatternLayer(
              opacity: 0.12,
              cell: 36,
              fadeTo: Alignment.bottomLeft,
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    args.activeTab == ZakatCategoryTab.wealth
                        ? l10n.payTotalZakatDue
                        : l10n.payCalculatedOverview,
                    style: AppTypography.label(
                      fontSize: 11,
                      color: AppColors.mintGreen,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    args.overviewTitle ?? '',
                    style: AppTypography.displayHeading(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    args.overviewPrimaryValue,
                    style: AppTypography.body(
                      fontSize: 24,
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.goldHairline),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          args.overviewDueLabel,
                          style: AppTypography.body(
                            fontSize: 13,
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          args.overviewDueValue,
                          style: AppTypography.body(
                            fontSize: 20,
                            color: scheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountSection extends StatelessWidget {
  const _AmountSection({
    required this.args,
    required this.controller,
    required this.errorText,
    required this.onChanged,
  });

  final ZakatPaymentArgs args;
  final TextEditingController controller;
  final String? errorText;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final noteStyle = AppTypography.body(
      fontSize: 12,
      color: scheme.onSurfaceVariant,
      height: 1.45,
    );
    final fixed = args.amountEntryMode == ZakatAmountEntryMode.fixed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ZakatFormSectionTitle(
          icon: Icons.payments_outlined,
          label: l10n.payAmountLabel,
        ),
        if (args.activeTab != ZakatCategoryTab.wealth) ...[
          const SizedBox(height: 12),
          Text(
            args.activeTab == ZakatCategoryTab.livestock
                ? l10n.payNaturalUnitsLivestock
                : l10n.payNaturalUnitsCrops,
            style: noteStyle,
          ),
          if ((args.livestockTransparencyText ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(args.livestockTransparencyText!.trim(), style: noteStyle),
          ],
          if ((args.cropTransparencyText ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(args.cropTransparencyText!.trim(), style: noteStyle),
          ],
        ],
        if ((args.amountNote ?? '').isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            args.amountNote!,
            style: noteStyle.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
        const SizedBox(height: 14),
        TextField(
          controller: controller,
          readOnly: fixed,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
          ],
          onChanged: (_) => onChanged(),
          style: AppTypography.body(
            fontSize: 24,
            color: scheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
          decoration: InputDecoration(
            hintText: args.activeTab == ZakatCategoryTab.wealth
                ? l10n.payAmountHintZakat
                : l10n.payAmountHintEtb,
            hintStyle: AppTypography.body(
              fontSize: 14,
              color: scheme.onSurfaceVariant,
            ),
            errorText: errorText,
            errorMaxLines: 3,
            prefixIcon: const _EtbPrefix(),
            prefixIconConstraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }
}

/// Always-visible currency tag inside amount fields.
class _EtbPrefix extends StatelessWidget {
  const _EtbPrefix();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16, end: 10),
      child: Text(
        'ETB',
        style: AppTypography.body(
          fontSize: 16,
          color: AppColors.goldDeep,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// One payment method from the API; greyed out with its reason when it is
/// not available.
class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final PaymentMethod method;
  final bool selected;

  /// `null` when the method can't be chosen.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final enabled = onTap != null;
    final subtitle = enabled
        ? method.subtitle
        : method.unavailableReason ?? l10n.payMethodUnavailable;
    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.tagGreenBg.withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? 0.12
                      : 1,
                )
              : scheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.forestLight : scheme.outlineVariant,
            width: selected ? 1.6 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: selected
                          ? const LinearGradient(
                              colors: [
                                AppColors.forestLight,
                                AppColors.forestGreen,
                              ],
                            )
                          : null,
                      color: selected ? null : AppColors.tagGreenBg,
                      border: Border.all(color: AppColors.goldHairline),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: httpsUrl(method.logoUrl) == null
                        ? _methodIcon(selected)
                        : Image.network(
                            httpsUrl(method.logoUrl)!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => _methodIcon(selected),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          method.label,
                          style: AppTypography.body(
                            fontSize: 14,
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: AppTypography.body(
                              fontSize: 12,
                              color: scheme.onSurfaceVariant,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (selected)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.forestLight,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImpactNote extends StatelessWidget {
  const _ImpactNote();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tagGoldBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.tagGoldBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome_outlined, color: AppColors.goldDeep),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.payImpactTitle,
                  style: AppTypography.body(
                    fontSize: 14,
                    color: AppColors.tagGoldText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.payImpactBody,
                  style: AppTypography.body(
                    fontSize: 12,
                    color: AppColors.tagGoldText,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityRow extends StatelessWidget {
  const _SecurityRow();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    final style = AppTypography.label(
      fontSize: 10,
      color: color,
      letterSpacing: 0.8,
    );
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 6,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 14, color: color),
            const SizedBox(width: 6),
            Text(l10n.paySecureSsl, style: style),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield_outlined, size: 14, color: color),
            const SizedBox(width: 6),
            Text(l10n.paySecureBank, style: style),
          ],
        ),
      ],
    );
  }
}

Widget _methodIcon(bool selected) => Icon(
  Icons.qr_code_2_rounded,
  size: 18,
  color: selected ? AppColors.goldLight : AppColors.forestMid,
);
