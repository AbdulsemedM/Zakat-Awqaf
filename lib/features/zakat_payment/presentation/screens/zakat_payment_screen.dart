import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/urgent_beneficiary_projects.dart';
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

  ZakatCheckoutMethod _method = ZakatCheckoutMethod.telebirr;
  bool _recurring = false;
  String? _beneficiaryProjectTitle;

  @override
  void dispose() {
    _firstName.dispose();
    _fatherName.dispose();
    _grandFatherName.dispose();
    _estimatedEtb.dispose();
    super.dispose();
  }

  bool get _namesOk =>
      _firstName.text.trim().isNotEmpty &&
      _fatherName.text.trim().isNotEmpty &&
      _grandFatherName.text.trim().isNotEmpty;

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

  bool get _canPay => _namesOk && _amountOk;

  String get _fullName =>
      '${_firstName.text.trim()} ${_fatherName.text.trim()} ${_grandFatherName.text.trim()}';

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
      beneficiaryLabel: _beneficiaryProjectTitle,
      naturalUnitSummary: widget.args.certificateNaturalUnitLine,
      amountIsMarketEstimate:
          widget.args.activeTab != ZakatCategoryTab.wealth,
    );

    context.push('/zakat/certificate', extra: extra);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final a = widget.args;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete contribution'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.verified_user_outlined, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Complete Contribution',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Securely fulfill your religious obligation through integrated local gateways.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              _AmountSection(
                args: a,
                estimatedController: _estimatedEtb,
                onChanged: () => setState(() {}),
              ),
              const SizedBox(height: 16),
              Text('Payer name', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: _firstName,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'First name',
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: _fatherName,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: "Father's name",
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 130,
                      child: TextField(
                        controller: _grandFatherName,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: "Grandfather's name",
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Beneficiary (optional)',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String?>(
                // ignore: deprecated_member_use
                value: _beneficiaryProjectTitle,
                decoration: const InputDecoration(
                  labelText: 'Urgent beneficiary project',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('General Zakat fund (no specific project)'),
                  ),
                  ...homeUrgentNeeds.map(
                    (p) => DropdownMenuItem<String?>(
                      value: p.title,
                      child: Text(p.title),
                    ),
                  ),
                ],
                onChanged: (v) => setState(() => _beneficiaryProjectTitle = v),
              ),
              const SizedBox(height: 16),
              Text(
                'Payment method',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...ZakatCheckoutMethod.values.map(
                (m) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _method == m
                          ? AppColors.secondary.withValues(alpha: 0.22)
                          : theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _method == m
                            ? AppColors.primary
                            : theme.colorScheme.outlineVariant
                                .withValues(alpha: 0.5),
                        width: _method == m ? 1.5 : 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => setState(() => _method = m),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              m == ZakatCheckoutMethod.telebirr
                                  ? Icons.account_balance_wallet_outlined
                                  : m == ZakatCheckoutMethod.cbeBirr
                                  ? Icons.account_balance_outlined
                                  : Icons.phone_iphone_outlined,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    m.label,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    m.subtitle,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_method == m)
                              Icon(Icons.check_circle, color: AppColors.primary, size: 22),
                          ],
                        ),
                      ),
                    ),
                    ),
                  ),
                ),
              ),
              CheckboxListTile(
                value: _recurring,
                onChanged: (v) => setState(() => _recurring = v ?? false),
                title: const Text('Save for recurring monthly'),
                subtitle: const Text(
                  'Automatically calculate and prompt for payment every lunar month.',
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 16, color: theme.colorScheme.outline),
                  const SizedBox(width: 6),
                  Text(
                    '256-BIT SSL',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.shield_outlined, size: 16, color: theme.colorScheme.outline),
                  const SizedBox(width: 6),
                  Text(
                    'BANK GRADE SECURITY',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _canPay ? _onPay : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.lock_outline),
                label: const Text('Pay Your Zakat'),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.volunteer_activism_outlined, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Your Impact\nThis contribution supports transparent allocation through the commission’s programs.',
                        style: theme.textTheme.bodySmall?.copyWith(height: 1.35),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountSection extends StatelessWidget {
  const _AmountSection({
    required this.args,
    required this.estimatedController,
    required this.onChanged,
  });

  final ZakatPaymentArgs args;
  final TextEditingController estimatedController;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      args.activeTab == ZakatCategoryTab.wealth
                          ? 'TOTAL ZAKAT DUE'
                          : 'CALCULATED OVERVIEW',
                      style: theme.textTheme.labelMedium?.copyWith(
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Icon(Icons.info_outline, size: 18, color: theme.colorScheme.outline),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                args.overviewTitle,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                args.overviewPrimaryValue,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      args.overviewDueLabel,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      args.overviewDueValue,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (args.activeTab != ZakatCategoryTab.wealth) ...[
          Text(
            'Zakat for ${args.activeTab == ZakatCategoryTab.livestock ? 'livestock' : 'crops'} is determined in natural units. '
            'You may estimate the ETB amount to discharge your obligation based on your local and current market value.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),
          if ((args.livestockTransparencyText ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              args.livestockTransparencyText!.trim(),
              style: theme.textTheme.bodySmall?.copyWith(height: 1.3),
            ),
          ],
          if ((args.cropTransparencyText ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              args.cropTransparencyText!.trim(),
              style: theme.textTheme.bodySmall?.copyWith(height: 1.3),
            ),
          ],
          const SizedBox(height: 8),
        ],
        TextField(
          controller: estimatedController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) => onChanged(),
          decoration: InputDecoration(
            labelText: 'Amount to pay (ETB)',
            hintText: args.activeTab == ZakatCategoryTab.wealth
                ? 'Enter amount you want to pay'
                : 'Enter ETB amount',
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
