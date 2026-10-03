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
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/uuid.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../causes/data/models/cause.dart';
import '../../../causes/data/repository/causes_repository.dart';
import '../../../zakat_calculator/bloc/zakat_calculator_state.dart';
import '../../data/models/zakat_payment_models.dart';
import '../../data/repository/zakat_payment_repository.dart';
import '../models/zakat_payment_args.dart';

/// Step 1 of a zakat payment: amount, project, method and the donor's Coop
/// Bank account. "Continue" starts the payment; steps 2–3 are on
/// [`PaymentFlowScreen`].
class ZakatPaymentScreen extends StatefulWidget {
  const ZakatPaymentScreen({super.key, required this.args});

  final ZakatPaymentArgs args;

  @override
  State<ZakatPaymentScreen> createState() => _ZakatPaymentScreenState();
}

class _ZakatPaymentScreenState extends State<ZakatPaymentScreen> {
  final _amount = TextEditingController();
  final _account = TextEditingController();
  final _repository = getIt<ZakatPaymentRepository>();
  final _payerAccess = getIt<PayerAccess>();

  /// Selected project, sent as `causeId` ([Cause.generalFundId] by default).
  late String _causeId;
  List<Cause> _causes = const [];
  bool _causesLoading = true;
  String? _causesLang;

  List<PaymentMethod> _methods = const [];
  bool _methodsLoading = true;
  bool _methodsFailed = false;
  String? _methodCode;

  /// One key per attempt. Kept when step 1 gets no response, so repeating
  /// it returns the same payment instead of starting a second one.
  String _idempotencyKey = uuidV4();
  bool _starting = false;
  String? _amountError;
  String? _accountError;

  static final _accountPattern = RegExp(r'^\d{6,20}$');

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lang = apiLang(context.contentLocale);
    if (lang != _causesLang) {
      _causesLang = lang;
      _loadCauses(lang);
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _account.dispose();
    super.dispose();
  }

  /// Causes that accept zakat, general fund first.
  Future<void> _loadCauses(String lang) async {
    setState(() => _causesLoading = true);
    List<Cause> causes;
    try {
      final page = await getIt<CausesRepository>().fetchCauses(
        acceptsZakatOnly: true,
        limit: 50,
        lang: lang,
      );
      causes = page.items;
    } on ApiException {
      causes = const [];
    }
    if (!mounted || lang != _causesLang) return;
    setState(() {
      _causes = causes;
      _causesLoading = false;
    });
  }

  Future<void> _loadMethods() async {
    setState(() {
      _methodsLoading = true;
      _methodsFailed = false;
    });
    try {
      final methods = await _repository.fetchMethods();
      if (!mounted) return;
      final usable = methods.where((m) => m.available && m.isAccountOtp);
      setState(() {
        _methods = methods;
        _methodCode = usable.isEmpty ? null : usable.first.code;
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

  /// Dropdown options as `(id, title)`, always including the selection.
  List<(String, String)> _projectOptions(AppLocalizations l10n) {
    final options = <(String, String)>[
      for (final cause in _causes) (cause.id, cause.title),
    ];
    if (!options.any((o) => o.$1 == Cause.generalFundId)) {
      options.insert(0, (Cause.generalFundId, l10n.payGeneralFundZakat));
    }
    if (!options.any((o) => o.$1 == _causeId)) {
      options.add((_causeId, widget.args.initialCauseTitle ?? _causeId));
    }
    return options;
  }

  PaymentMethod? get _method {
    for (final method in _methods) {
      if (method.code == _methodCode) return method;
    }
    return null;
  }

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
      _accountPattern.hasMatch(_account.text.trim());

  Future<void> _onContinue() async {
    final l10n = context.l10n;
    final method = _method;
    if (method == null) return;
    final amountError = _validateAmount(l10n);
    final account = _account.text.trim();
    final accountError = _accountPattern.hasMatch(account)
        ? null
        : l10n.payAccountNumberInvalid;
    setState(() {
      _amountError = amountError;
      _accountError = accountError;
    });
    if (amountError != null || accountError != null) return;

    setState(() => _starting = true);
    try {
      final payment = await _repository.startPayment(
        ZakatPaymentRequest(
          zakatType: widget.args.zakatType,
          amountEtb: _amountEtb,
          methodCode: method.code,
          causeId: _causeId,
          accountNumber: account,
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
      case 'ACCOUNT_NOT_FOUND' || 'ACCOUNT_NOT_ALLOWED':
        // The bank's own text, under the account field.
        _accountError = e.message;
        return;
      case 'AMOUNT_OUT_OF_RANGE':
        _amountError = e.message;
        return;
      case 'VALIDATION_FAILED':
        _amountError = e.fieldErrors['amountEtb'];
        _accountError = e.fieldErrors['accountNumber'];
        if (_amountError != null || _accountError != null) return;
      case 'DUPLICATE_REQUEST':
        _idempotencyKey = uuidV4();
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
                  title: l10n.payTitleZakat,
                  subtitle: l10n.paySubtitleZakat,
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
                          onChanged: () => setState(() => _amountError = null),
                        ),
                      ),
                      gap,
                      PremiumCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ZakatFormSectionTitle(
                              icon: Icons.volunteer_activism_outlined,
                              label: l10n.payBeneficiary,
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<String>(
                              initialValue: _causeId,
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: l10n.payProjectLabel,
                                helperText: _causesLoading
                                    ? l10n.payProjectsLoading
                                    : null,
                              ),
                              items: [
                                for (final (id, title) in _projectOptions(l10n))
                                  DropdownMenuItem<String>(
                                    value: id,
                                    child: Text(
                                      title,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                              ],
                              onChanged: (v) {
                                if (v != null) setState(() => _causeId = v);
                              },
                            ),
                          ],
                        ),
                      ),
                      gap,
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
                            const SizedBox(height: 16),
                            TextField(
                              controller: _account,
                              enabled: _method != null,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(20),
                              ],
                              onChanged: (_) =>
                                  setState(() => _accountError = null),
                              decoration: InputDecoration(
                                labelText: l10n.payAccountNumberLabel,
                                helperText: l10n.payAccountNumberHelper,
                                helperMaxLines: 2,
                                errorText: _accountError,
                                errorMaxLines: 3,
                                prefixIcon: const Icon(
                                  Icons.account_balance_outlined,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                      label: l10n.commonContinue,
                      icon: Icons.lock_outline_rounded,
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
          onTap: method.available && method.isAccountOtp
              ? () => setState(() => _methodCode = method.code)
              : null,
        ),
      ],
    ];
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
                    child: Icon(
                      Icons.account_balance_rounded,
                      size: 18,
                      color: selected
                          ? AppColors.goldLight
                          : AppColors.forestMid,
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
