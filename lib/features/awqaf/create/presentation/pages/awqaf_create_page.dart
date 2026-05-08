import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';

enum _WaqfInstrument { money, asset }

enum _MoneyStep { amountShares, dedication, beneficiaries, payment, review }

enum _AssetStep {
  propertyDetails,
  valuationDocs,
  legalCompliance,
  beneficiaries,
  review,
}

enum _DedicationTarget { myself, parents, deceasedRelative, anonymous }

enum _PaymentMethod { coopAlhuda, cbe, telebirr, zamzamBank }

class AwqafCreatePage extends StatefulWidget {
  const AwqafCreatePage({super.key});

  @override
  State<AwqafCreatePage> createState() => _AwqafCreatePageState();
}

class _AwqafCreatePageState extends State<AwqafCreatePage> {
  static const _moneySteps = [
    _MoneyStep.amountShares,
    _MoneyStep.dedication,
    _MoneyStep.beneficiaries,
    _MoneyStep.payment,
    _MoneyStep.review,
  ];
  static const _assetSteps = [
    _AssetStep.propertyDetails,
    _AssetStep.valuationDocs,
    _AssetStep.legalCompliance,
    _AssetStep.beneficiaries,
    _AssetStep.review,
  ];

  _WaqfInstrument _instrument = _WaqfInstrument.money;
  _MoneyStep _moneyStep = _MoneyStep.amountShares;
  _AssetStep _assetStep = _AssetStep.propertyDetails;

  int _shares = 5;
  final _moneyAmountController = TextEditingController(text: '5000');

  _DedicationTarget _dedicationTarget = _DedicationTarget.myself;
  final _honoreeController = TextEditingController();
  final _dedicationMessageController = TextEditingController();
  bool _isDedicationPrivate = false;

  final _assetNameController = TextEditingController();
  final _assetLocationController = TextEditingController();
  final _estimatedValueController = TextEditingController();
  bool _valuationDocAttached = false;
  bool _ownershipDocAttached = false;
  bool _acceptedLegalTerms = false;

  final Set<String> _beneficiaries = {'Education Fund'};
  final _beneficiaryNotesController = TextEditingController();

  _PaymentMethod _paymentMethod = _PaymentMethod.coopAlhuda;

  @override
  void dispose() {
    _moneyAmountController.dispose();
    _honoreeController.dispose();
    _dedicationMessageController.dispose();
    _assetNameController.dispose();
    _assetLocationController.dispose();
    _estimatedValueController.dispose();
    _beneficiaryNotesController.dispose();
    super.dispose();
  }

  int get _stepIndex => _instrument == _WaqfInstrument.money
      ? _moneySteps.indexOf(_moneyStep)
      : _assetSteps.indexOf(_assetStep);
  int get _totalSteps =>
      _instrument == _WaqfInstrument.money ? _moneySteps.length : _assetSteps.length;
  String get _stepTitle {
    if (_instrument == _WaqfInstrument.money) {
      return switch (_moneyStep) {
        _MoneyStep.amountShares => 'Amount & Shares',
        _MoneyStep.dedication => 'Dedication Details',
        _MoneyStep.beneficiaries => 'Beneficiary Design',
        _MoneyStep.payment => 'Payment Method',
        _MoneyStep.review => 'Review & Confirm',
      };
    }
    return switch (_assetStep) {
      _AssetStep.propertyDetails => 'Property/Asset Details',
      _AssetStep.valuationDocs => 'Valuation & Documents',
      _AssetStep.legalCompliance => 'Legal Ownership/Compliance',
      _AssetStep.beneficiaries => 'Beneficiary Design',
      _AssetStep.review => 'Review & Confirm',
    };
  }

  bool get _canContinue {
    if (_instrument == _WaqfInstrument.money) {
      return switch (_moneyStep) {
        _MoneyStep.amountShares =>
          _shares > 0 && (double.tryParse(_moneyAmountController.text) ?? 0) > 0,
        _MoneyStep.dedication =>
          _dedicationTarget != _DedicationTarget.deceasedRelative ||
              _honoreeController.text.trim().isNotEmpty,
        _MoneyStep.beneficiaries => _beneficiaries.isNotEmpty,
        _MoneyStep.payment => true,
        _MoneyStep.review => true,
      };
    }
    return switch (_assetStep) {
      _AssetStep.propertyDetails =>
        _assetNameController.text.trim().isNotEmpty &&
            _assetLocationController.text.trim().isNotEmpty &&
            (double.tryParse(_estimatedValueController.text) ?? 0) > 0,
      _AssetStep.valuationDocs => _valuationDocAttached,
      _AssetStep.legalCompliance => _ownershipDocAttached && _acceptedLegalTerms,
      _AssetStep.beneficiaries => _beneficiaries.isNotEmpty,
      _AssetStep.review => true,
    };
  }

  void _switchInstrument(_WaqfInstrument instrument) {
    setState(() {
      _instrument = instrument;
      _moneyStep = _MoneyStep.amountShares;
      _assetStep = _AssetStep.propertyDetails;
    });
  }

  void _onBack() {
    if (_stepIndex == 0) {
      Navigator.of(context).maybePop();
      return;
    }
    setState(() {
      if (_instrument == _WaqfInstrument.money) {
        _moneyStep = _moneySteps[_stepIndex - 1];
      } else {
        _assetStep = _assetSteps[_stepIndex - 1];
      }
    });
  }

  void _onContinue() {
    if (_stepIndex == _totalSteps - 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Awqaf registration draft confirmed.')),
      );
      return;
    }
    setState(() {
      if (_instrument == _WaqfInstrument.money) {
        _moneyStep = _moneySteps[_stepIndex + 1];
      } else {
        _assetStep = _assetSteps[_stepIndex + 1];
      }
    });
  }

  Widget _buildStepBody(ThemeData theme) {
    if (_instrument == _WaqfInstrument.money) {
      switch (_moneyStep) {
        case _MoneyStep.amountShares:
          return _MoneyAmountSharesStep(
            amountController: _moneyAmountController,
            shares: _shares,
            onChanged: () => setState(() {}),
            onMinus: () => setState(() {
              if (_shares > 1) _shares -= 1;
            }),
            onPlus: () => setState(() => _shares += 1),
          );
        case _MoneyStep.dedication:
          return _DedicationStep(
            dedicationTarget: _dedicationTarget,
            honoreeController: _honoreeController,
            messageController: _dedicationMessageController,
            isPrivate: _isDedicationPrivate,
            onTargetChanged: (v) => setState(() => _dedicationTarget = v),
            onPrivateChanged: (v) => setState(() => _isDedicationPrivate = v ?? false),
            onChanged: () => setState(() {}),
          );
        case _MoneyStep.beneficiaries:
          return _BeneficiariesStep(
            selected: _beneficiaries,
            notesController: _beneficiaryNotesController,
            onToggle: (value) => setState(() {
              if (_beneficiaries.contains(value)) {
                _beneficiaries.remove(value);
              } else {
                _beneficiaries.add(value);
              }
            }),
          );
        case _MoneyStep.payment:
          return _PaymentMethodStep(
            selected: _paymentMethod,
            onChanged: (value) => setState(() => _paymentMethod = value),
          );
        case _MoneyStep.review:
          return _ReviewStep(
            instrument: _instrument,
            shares: _shares,
            moneyAmount: _moneyAmountController.text.trim(),
            dedicationTarget: _dedicationTarget,
            honoree: _honoreeController.text.trim(),
            message: _dedicationMessageController.text.trim(),
            isPrivate: _isDedicationPrivate,
            beneficiaries: _beneficiaries,
            paymentMethod: _paymentMethod,
            assetName: _assetNameController.text.trim(),
            assetLocation: _assetLocationController.text.trim(),
            assetValue: _estimatedValueController.text.trim(),
          );
      }
    }
    switch (_assetStep) {
      case _AssetStep.propertyDetails:
        return _AssetPropertyStep(
          assetNameController: _assetNameController,
          assetLocationController: _assetLocationController,
          estimatedValueController: _estimatedValueController,
          onChanged: () => setState(() {}),
        );
      case _AssetStep.valuationDocs:
        return _ValuationDocStep(
          attached: _valuationDocAttached,
          onToggle: () => setState(() => _valuationDocAttached = !_valuationDocAttached),
        );
      case _AssetStep.legalCompliance:
        return _LegalStep(
          ownershipDocAttached: _ownershipDocAttached,
          acceptedTerms: _acceptedLegalTerms,
          onOwnershipToggle: () => setState(() => _ownershipDocAttached = !_ownershipDocAttached),
          onTermsChanged: (v) => setState(() => _acceptedLegalTerms = v ?? false),
        );
      case _AssetStep.beneficiaries:
        return _BeneficiariesStep(
          selected: _beneficiaries,
          notesController: _beneficiaryNotesController,
          onToggle: (value) => setState(() {
            if (_beneficiaries.contains(value)) {
              _beneficiaries.remove(value);
            } else {
              _beneficiaries.add(value);
            }
          }),
        );
      case _AssetStep.review:
        return _ReviewStep(
          instrument: _instrument,
          shares: _shares,
          moneyAmount: _moneyAmountController.text.trim(),
          dedicationTarget: _dedicationTarget,
          honoree: _honoreeController.text.trim(),
          message: _dedicationMessageController.text.trim(),
          isPrivate: _isDedicationPrivate,
          beneficiaries: _beneficiaries,
          paymentMethod: _paymentMethod,
          assetName: _assetNameController.text.trim(),
          assetLocation: _assetLocationController.text.trim(),
          assetValue: _estimatedValueController.text.trim(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Mejlis Awqaf')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StepHeader(
                stepIndex: _stepIndex,
                totalSteps: _totalSteps,
                title: _stepTitle,
              ),
              const SizedBox(height: 12),
              _InstrumentPicker(
                selected: _instrument,
                onChanged: _switchInstrument,
              ),
              const SizedBox(height: 14),
              _buildStepBody(theme),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _onBack,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.awqafPrimary,
                    foregroundColor: AppColors.textOnPrimary,
                  ),
                  onPressed: _canContinue ? _onContinue : null,
                  icon: Icon(_stepIndex == _totalSteps - 1 ? Icons.verified : Icons.arrow_forward),
                  label: Text(_stepIndex == _totalSteps - 1 ? 'Confirm Dedication' : 'Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({
    required this.stepIndex,
    required this.totalSteps,
    required this.title,
  });

  final int stepIndex;
  final int totalSteps;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STEP ${stepIndex + 1} OF $totalSteps',
          style: theme.textTheme.labelSmall?.copyWith(
            letterSpacing: 1.0,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 6,
            value: (stepIndex + 1) / totalSteps,
            color: AppColors.awqafPrimary,
            backgroundColor: AppColors.awqafSecondary.withValues(alpha: 0.2),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _InstrumentPicker extends StatelessWidget {
  const _InstrumentPicker({required this.selected, required this.onChanged});

  final _WaqfInstrument selected;
  final ValueChanged<_WaqfInstrument> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<_WaqfInstrument>(
      segments: const [
        ButtonSegment(
          value: _WaqfInstrument.money,
          icon: Icon(Icons.payments_outlined),
          label: Text('Money Waqf'),
        ),
        ButtonSegment(
          value: _WaqfInstrument.asset,
          icon: Icon(Icons.apartment_outlined),
          label: Text('Asset/Land Waqf'),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (value) => onChanged(value.first),
    );
  }
}

class _MoneyAmountSharesStep extends StatelessWidget {
  const _MoneyAmountSharesStep({
    required this.amountController,
    required this.shares,
    required this.onChanged,
    required this.onMinus,
    required this.onPlus,
  });

  final TextEditingController amountController;
  final int shares;
  final VoidCallback onChanged;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amount = double.tryParse(amountController.text) ?? 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Waqf Shares Allocation', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => onChanged(),
              decoration: const InputDecoration(
                labelText: 'Total Contribution (ETB)',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton.outlined(onPressed: onMinus, icon: const Icon(Icons.remove)),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          shares.toString().padLeft(2, '0'),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.awqafPrimary,
                          ),
                        ),
                        Text('TOTAL SHARES', style: theme.textTheme.labelSmall),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.awqafPrimary,
                    foregroundColor: AppColors.textOnPrimary,
                  ),
                  onPressed: onPlus,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.awqafSecondary.withValues(alpha: 0.16),
              ),
              child: Text(
                'Draft deed contribution: ETB ${amount.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.awqafPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DedicationStep extends StatelessWidget {
  const _DedicationStep({
    required this.dedicationTarget,
    required this.honoreeController,
    required this.messageController,
    required this.isPrivate,
    required this.onTargetChanged,
    required this.onPrivateChanged,
    required this.onChanged,
  });

  final _DedicationTarget dedicationTarget;
  final TextEditingController honoreeController;
  final TextEditingController messageController;
  final bool isPrivate;
  final ValueChanged<_DedicationTarget> onTargetChanged;
  final ValueChanged<bool?> onPrivateChanged;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final opts = <(_DedicationTarget, String, String)>[
      (_DedicationTarget.myself, 'Myself', 'Personal legacy dedication'),
      (_DedicationTarget.parents, 'Parents', 'Honor your parents'),
      (_DedicationTarget.deceasedRelative, 'Deceased Relative', 'Sadaqa Jariya for departed'),
      (_DedicationTarget.anonymous, 'Anonymous', 'Without naming a recipient'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...opts.map((o) {
          final selected = dedicationTarget == o.$1;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              onTap: () => onTargetChanged(o.$1),
              leading: Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: AppColors.awqafPrimary,
              ),
              title: Text(o.$2),
              subtitle: Text(o.$3),
            ),
          );
        }),
        TextField(
          controller: honoreeController,
          onChanged: (_) => onChanged(),
          decoration: const InputDecoration(
            labelText: 'Honoree name',
            hintText: 'Required for deceased relative',
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: messageController,
          onChanged: (_) => onChanged(),
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Message (optional)',
          ),
        ),
        CheckboxListTile(
          value: isPrivate,
          onChanged: onPrivateChanged,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text('Keep this dedication private'),
        ),
      ],
    );
  }
}

class _BeneficiariesStep extends StatelessWidget {
  const _BeneficiariesStep({
    required this.selected,
    required this.notesController,
    required this.onToggle,
  });

  final Set<String> selected;
  final TextEditingController notesController;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    const items = [
      'Education Fund',
      'Healthcare Waqf',
      'Livelihood Support',
      'Community Infrastructure',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map((item) => FilterChip(
                    selected: selected.contains(item),
                    label: Text(item),
                    selectedColor: AppColors.awqafSecondary.withValues(alpha: 0.22),
                    onSelected: (_) => onToggle(item),
                  ))
              .toList(),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: notesController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Purpose/notes (optional)',
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodStep extends StatelessWidget {
  const _PaymentMethodStep({
    required this.selected,
    required this.onChanged,
  });

  final _PaymentMethod selected;
  final ValueChanged<_PaymentMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    final methods = <(_PaymentMethod, String)>[
      (_PaymentMethod.coopAlhuda, 'Coop Bank Alhuda'),
      (_PaymentMethod.cbe, 'CBE'),
      (_PaymentMethod.telebirr, 'Telebirr'),
      (_PaymentMethod.zamzamBank, 'Zamzam Bank'),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: methods.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, i) {
        final m = methods[i];
        final active = selected == m.$1;
        return Card(
          color: active ? AppColors.awqafSecondary.withValues(alpha: 0.25) : null,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onChanged(m.$1),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  m.$2,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AssetPropertyStep extends StatelessWidget {
  const _AssetPropertyStep({
    required this.assetNameController,
    required this.assetLocationController,
    required this.estimatedValueController,
    required this.onChanged,
  });

  final TextEditingController assetNameController;
  final TextEditingController assetLocationController;
  final TextEditingController estimatedValueController;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: assetNameController,
          onChanged: (_) => onChanged(),
          decoration: const InputDecoration(labelText: 'Asset name'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: assetLocationController,
          onChanged: (_) => onChanged(),
          decoration: const InputDecoration(labelText: 'Asset location'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: estimatedValueController,
          onChanged: (_) => onChanged(),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Estimated market value (ETB)'),
        ),
      ],
    );
  }
}

class _ValuationDocStep extends StatelessWidget {
  const _ValuationDocStep({required this.attached, required this.onToggle});

  final bool attached;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(attached ? Icons.check_circle : Icons.upload_file_outlined),
        title: const Text('Attach valuation report'),
        subtitle: Text(attached ? 'Valuation document attached' : 'Tap to attach mock document'),
        onTap: onToggle,
      ),
    );
  }
}

class _LegalStep extends StatelessWidget {
  const _LegalStep({
    required this.ownershipDocAttached,
    required this.acceptedTerms,
    required this.onOwnershipToggle,
    required this.onTermsChanged,
  });

  final bool ownershipDocAttached;
  final bool acceptedTerms;
  final VoidCallback onOwnershipToggle;
  final ValueChanged<bool?> onTermsChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            leading: Icon(
              ownershipDocAttached ? Icons.verified_rounded : Icons.description_outlined,
            ),
            title: const Text('Attach ownership document'),
            subtitle: Text(
              ownershipDocAttached
                  ? 'Ownership certificate attached'
                  : 'Tap to attach mock ownership document',
            ),
            onTap: onOwnershipToggle,
          ),
        ),
        CheckboxListTile(
          value: acceptedTerms,
          onChanged: onTermsChanged,
          contentPadding: EdgeInsets.zero,
          title: const Text('I confirm legal ownership and Sharia compliance.'),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }
}

class _ReviewStep extends StatelessWidget {
  const _ReviewStep({
    required this.instrument,
    required this.shares,
    required this.moneyAmount,
    required this.dedicationTarget,
    required this.honoree,
    required this.message,
    required this.isPrivate,
    required this.beneficiaries,
    required this.paymentMethod,
    required this.assetName,
    required this.assetLocation,
    required this.assetValue,
  });

  final _WaqfInstrument instrument;
  final int shares;
  final String moneyAmount;
  final _DedicationTarget dedicationTarget;
  final String honoree;
  final String message;
  final bool isPrivate;
  final Set<String> beneficiaries;
  final _PaymentMethod paymentMethod;
  final String assetName;
  final String assetLocation;
  final String assetValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paymentLabel = switch (paymentMethod) {
      _PaymentMethod.coopAlhuda => 'Coop Bank Alhuda',
      _PaymentMethod.cbe => 'CBE',
      _PaymentMethod.telebirr => 'Telebirr',
      _PaymentMethod.zamzamBank => 'Zamzam Bank',
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Draft Deed Summary',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            _reviewLine('Instrument', instrument == _WaqfInstrument.money ? 'Money Waqf' : 'Asset/Land Waqf'),
            if (instrument == _WaqfInstrument.money) ...[
              _reviewLine('Contribution', 'ETB ${moneyAmount.isEmpty ? '0.00' : moneyAmount}'),
              _reviewLine('Shares', '$shares'),
              _reviewLine('Payment Method', paymentLabel),
              _reviewLine('Dedication', dedicationTarget.name),
              _reviewLine('Honoree', honoree.isEmpty ? 'Not specified' : honoree),
              _reviewLine('Message', message.isEmpty ? 'No custom message' : message),
              _reviewLine('Privacy', isPrivate ? 'Private' : 'Public acknowledgment'),
            ] else ...[
              _reviewLine('Asset Name', assetName),
              _reviewLine('Location', assetLocation),
              _reviewLine('Estimated Value', 'ETB ${assetValue.isEmpty ? '0.00' : assetValue}'),
            ],
            _reviewLine('Beneficiaries', beneficiaries.join(', ')),
          ],
        ),
      ),
    );
  }

  Widget _reviewLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
