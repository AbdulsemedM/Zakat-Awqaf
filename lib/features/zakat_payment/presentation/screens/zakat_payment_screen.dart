import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/primary_hero.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../app/widgets/zakat_page_header.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../causes/data/models/cause.dart';
import '../../../causes/data/repository/causes_repository.dart';
import '../models/zakat_certificate_args.dart';
import '../models/zakat_checkout_method.dart';
import '../models/zakat_payment_args.dart';
import '../../../zakat_calculator/bloc/zakat_calculator_state.dart';

class ZakatPaymentScreen extends StatefulWidget {
  const ZakatPaymentScreen({super.key, required this.args});

  final ZakatPaymentArgs args;

  @override
  State<ZakatPaymentScreen> createState() => _ZakatPaymentScreenState();
}

class _ZakatPaymentScreenState extends State<ZakatPaymentScreen> {
  final _firstName = TextEditingController();
  final _fatherName = TextEditingController();
  final _grandFatherName = TextEditingController();
  final _estimatedEtb = TextEditingController();

  ZakatCheckoutMethod _method = ZakatCheckoutMethod.coopBankAlhuda;
  bool _recurring = false;

  /// Selected project; `null` is the general sadaqah fund. Zakat always has
  /// one ([Cause.generalFundId] by default), sent as `causeId` in B3.3.
  String? _causeId;
  List<Cause> _causes = const [];
  bool _causesLoading = true;
  String? _causesLang;

  static const _quickAmounts = [100, 500, 1000, 5000];

  bool get _isSadaqah => widget.args.purpose == PaymentPurpose.sadaqah;

  @override
  void initState() {
    super.initState();
    final prefillAmount = widget.args.fixedAmountEtb;
    if (prefillAmount != null && prefillAmount > 0) {
      _estimatedEtb.text = _formatEtbInput(prefillAmount);
    }
    _causeId =
        widget.args.initialCauseId ?? (_isSadaqah ? null : Cause.generalFundId);
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

  /// Zakat: causes that accept zakat (general fund first). Sadaqah: every
  /// active cause; its general fund is the `null` option.
  Future<void> _loadCauses(String lang) async {
    setState(() => _causesLoading = true);
    List<Cause> causes;
    try {
      final page = await getIt<CausesRepository>().fetchCauses(
        acceptsZakatOnly: !_isSadaqah,
        limit: 50,
        lang: lang,
      );
      causes = _isSadaqah
          ? page.items.where((c) => !c.isGeneralFund).toList()
          : page.items;
    } on ApiException {
      causes = const [];
    }
    if (!mounted || lang != _causesLang) return;
    setState(() {
      _causes = causes;
      _causesLoading = false;
    });
  }

  /// Dropdown options as `(id, title)`, always including the selection.
  List<(String?, String)> _projectOptions(AppLocalizations l10n) {
    final options = <(String?, String)>[
      if (_isSadaqah) (null, l10n.payGeneralFundSadaqah),
      for (final cause in _causes) (cause.id, cause.title),
    ];
    if (!_isSadaqah && !options.any((o) => o.$1 == Cause.generalFundId)) {
      options.insert(0, (Cause.generalFundId, l10n.payGeneralFundZakat));
    }
    final selected = _causeId;
    if (selected != null && !options.any((o) => o.$1 == selected)) {
      options.add((selected, widget.args.initialCauseTitle ?? selected));
    }
    return options;
  }

  @override
  void dispose() {
    _firstName.dispose();
    _fatherName.dispose();
    _grandFatherName.dispose();
    _estimatedEtb.dispose();
    super.dispose();
  }

  double get _payAmountEtb {
    final a = widget.args;
    if (a.amountEntryMode == ZakatAmountEntryMode.fixed) {
      return a.fixedAmountEtb ?? 0;
    }
    return double.tryParse(_estimatedEtb.text.replaceAll(',', '')) ?? 0;
  }

  bool get _amountOk {
    final a = widget.args;
    if (a.amountEntryMode == ZakatAmountEntryMode.fixed) {
      return (a.fixedAmountEtb ?? 0) > 0;
    }
    return _payAmountEtb > 0;
  }

  bool get _canPay => _amountOk;

  String get _fullName {
    final parts = [
      _firstName.text.trim(),
      _fatherName.text.trim(),
      _grandFatherName.text.trim(),
    ].where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return 'Anonymous Payer';
    return parts.join(' ');
  }

  Future<void> _onPay() async {
    if (!_canPay) {
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) {
      return;
    }

    final certId = 'ZK-${DateTime.now().millisecondsSinceEpoch}';
    final extra = ZakatCertificateArgs(
      certificateId: certId,
      payerFullName: _fullName,
      amountEtb: _payAmountEtb,
      paymentMethodLabel: _method.label,
      issuedAt: DateTime.now(),
      categoryTab: widget.args.activeTab,
      beneficiaryLabel: _causeId == null
          ? null
          : _projectOptions(
              context.l10n,
            ).firstWhere((o) => o.$1 == _causeId).$2,
      naturalUnitSummary: widget.args.certificateNaturalUnitLine,
      amountIsMarketEstimate: widget.args.activeTab != ZakatCategoryTab.wealth,
    );

    context.push('/zakat/certificate', extra: extra);
  }

  void _setQuickAmount(int value) {
    setState(() => _estimatedEtb.text = value.toString());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final a = widget.args;
    const gap = SizedBox(height: 16);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ZakatPageHeader(
              title: _isSadaqah ? l10n.payTitleSadaqah : l10n.payTitleZakat,
              subtitle: _isSadaqah
                  ? l10n.paySubtitleSadaqah
                  : l10n.paySubtitleZakat,
              leadingIcon: _isSadaqah
                  ? Icons.favorite_outline_rounded
                  : Icons.verified_user_outlined,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!_isSadaqah && a.overviewTitle != null) ...[
                    _OverviewCard(args: a),
                    gap,
                  ],
                  PremiumCard(
                    child: _AmountSection(
                      args: a,
                      isSadaqah: _isSadaqah,
                      estimatedController: _estimatedEtb,
                      quickAmounts: _isSadaqah ? _quickAmounts : const [],
                      onQuickAmount: _setQuickAmount,
                      onChanged: () => setState(() {}),
                    ),
                  ),
                  gap,
                  PremiumCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ZakatFormSectionTitle(
                          icon: Icons.person_outline_rounded,
                          label: l10n.payPayerName,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _firstName,
                                textCapitalization: TextCapitalization.words,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  labelText: l10n.payFirstName,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _fatherName,
                                textCapitalization: TextCapitalization.words,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  labelText: l10n.payFatherName,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _grandFatherName,
                          textCapitalization: TextCapitalization.words,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            labelText: l10n.payGrandfatherName,
                          ),
                        ),
                        const SizedBox(height: 18),
                        ZakatFormSectionTitle(
                          icon: Icons.volunteer_activism_outlined,
                          label: l10n.payBeneficiary,
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String?>(
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
                              DropdownMenuItem<String?>(
                                value: id,
                                child: Text(
                                  title,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                          onChanged: (v) => setState(() => _causeId = v),
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
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ZakatCheckoutMethod.values.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1.3,
                              ),
                          itemBuilder: (context, index) {
                            final m = ZakatCheckoutMethod.values[index];
                            return _MethodTile(
                              method: m,
                              selected: _method == m,
                              onTap: () => setState(() => _method = m),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        SwitchListTile.adaptive(
                          value: _recurring,
                          onChanged: (v) => setState(() => _recurring = v),
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            l10n.payRecurringTitle,
                            style: AppTypography.body(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(
                            l10n.payRecurringSubtitle,
                            style: AppTypography.body(
                              fontSize: 12,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
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
          child: GoldActionButton(
            label: _isSadaqah ? l10n.payButtonSadaqah : l10n.calcPayYourZakat,
            icon: Icons.lock_outline_rounded,
            onPressed: _canPay ? _onPay : null,
          ),
        ),
      ),
    );
  }
}

String _formatEtbInput(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(2);
}

IconData _methodIcon(ZakatCheckoutMethod method) {
  return switch (method) {
    ZakatCheckoutMethod.telebirr => Icons.account_balance_wallet_outlined,
    ZakatCheckoutMethod.cbeBirr => Icons.account_balance_outlined,
    ZakatCheckoutMethod.mPesa => Icons.phone_iphone_outlined,
    ZakatCheckoutMethod.coopBankAlhuda => Icons.account_balance_rounded,
    ZakatCheckoutMethod.cbe => Icons.account_balance_wallet_rounded,
    ZakatCheckoutMethod.zamzamBank => Icons.mosque_outlined,
  };
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
    required this.isSadaqah,
    required this.estimatedController,
    required this.quickAmounts,
    required this.onQuickAmount,
    required this.onChanged,
  });

  final ZakatPaymentArgs args;
  final bool isSadaqah;
  final TextEditingController estimatedController;
  final List<int> quickAmounts;
  final ValueChanged<int> onQuickAmount;
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
    final current = int.tryParse(estimatedController.text.replaceAll(',', ''));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ZakatFormSectionTitle(
          icon: Icons.payments_outlined,
          label: isSadaqah ? l10n.donationAmountLabel : l10n.payAmountLabel,
        ),
        if (!isSadaqah && args.activeTab != ZakatCategoryTab.wealth) ...[
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
          controller: estimatedController,
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
            prefixIcon: const _EtbPrefix(),
            prefixIconConstraints: const BoxConstraints(),
          ),
        ),
        if (quickAmounts.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final amount in quickAmounts)
                ChoiceChip(
                  label: Text('ETB $amount'),
                  selected: current == amount,
                  onSelected: (_) => onQuickAmount(amount),
                ),
            ],
          ),
        ],
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

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final ZakatCheckoutMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
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
                        _methodIcon(method),
                        size: 17,
                        color: selected
                            ? AppColors.goldLight
                            : AppColors.forestMid,
                      ),
                    ),
                    const Spacer(),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 180),
                      opacity: selected ? 1 : 0,
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.forestLight,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  method.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.body(
                    fontSize: 13,
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  method.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.body(
                    fontSize: 11,
                    color: scheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
              ],
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
