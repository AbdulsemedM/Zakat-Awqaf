import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';

enum _CreateStep { instrument, dedication, beneficiary, review }

enum _WaqfInstrument { cash, assetLand }

enum _DedicationTarget { myself, parents, deceasedRelative, anonymous }

class AwqafCreatePage extends StatefulWidget {
  const AwqafCreatePage({super.key});

  @override
  State<AwqafCreatePage> createState() => _AwqafCreatePageState();
}

class _AwqafCreatePageState extends State<AwqafCreatePage> {
  static const _stepOrder = [
    _CreateStep.instrument,
    _CreateStep.dedication,
    _CreateStep.beneficiary,
    _CreateStep.review,
  ];

  _CreateStep _step = _CreateStep.instrument;
  _WaqfInstrument _instrument = _WaqfInstrument.cash;
  int _shares = 5;
  static const int _shareValueEtb = 1000;

  _DedicationTarget _dedicationTarget = _DedicationTarget.myself;
  final TextEditingController _honoreeNameController = TextEditingController();
  final TextEditingController _dedicationMessageController =
      TextEditingController();
  bool _keepPrivate = false;

  final Set<String> _beneficiaryCategories = {'Education Fund'};
  final TextEditingController _educationPercentController =
      TextEditingController(text: '50');
  final TextEditingController _healthcarePercentController =
      TextEditingController(text: '25');
  final TextEditingController _livelihoodPercentController =
      TextEditingController(text: '25');
  final TextEditingController _beneficiaryNotesController =
      TextEditingController();

  @override
  void dispose() {
    _honoreeNameController.dispose();
    _dedicationMessageController.dispose();
    _educationPercentController.dispose();
    _healthcarePercentController.dispose();
    _livelihoodPercentController.dispose();
    _beneficiaryNotesController.dispose();
    super.dispose();
  }

  int get _currentStepIndex => _stepOrder.indexOf(_step);

  double get _totalContribution => _shares * _shareValueEtb.toDouble();

  bool get _canContinueCurrentStep {
    switch (_step) {
      case _CreateStep.instrument:
        return _shares > 0;
      case _CreateStep.dedication:
        if (_dedicationTarget == _DedicationTarget.deceasedRelative) {
          return _honoreeNameController.text.trim().isNotEmpty;
        }
        return true;
      case _CreateStep.beneficiary:
        return _beneficiaryCategories.isNotEmpty;
      case _CreateStep.review:
        return true;
    }
  }

  void _goBack() {
    if (_step == _CreateStep.instrument) {
      Navigator.of(context).maybePop();
      return;
    }
    setState(() {
      _step = _stepOrder[_currentStepIndex - 1];
    });
  }

  void _goNext() {
    if (_step == _CreateStep.review) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Awqaf registration draft confirmed successfully.'),
        ),
      );
      return;
    }
    setState(() {
      _step = _stepOrder[_currentStepIndex + 1];
    });
  }

  String get _stepTitle {
    switch (_step) {
      case _CreateStep.instrument:
        return 'Select Instrument';
      case _CreateStep.dedication:
        return 'Dedication Details';
      case _CreateStep.beneficiary:
        return 'Beneficiary Design';
      case _CreateStep.review:
        return 'Review & Confirm';
    }
  }

  Widget _buildStepContent() {
    switch (_step) {
      case _CreateStep.instrument:
        return _InstrumentStep(
          instrument: _instrument,
          shares: _shares,
          shareValueEtb: _shareValueEtb,
          totalContribution: _totalContribution,
          onInstrumentChanged: (instrument) =>
              setState(() => _instrument = instrument),
          onDecrementShares: () => setState(() {
            if (_shares > 1) _shares -= 1;
          }),
          onIncrementShares: () => setState(() => _shares += 1),
        );
      case _CreateStep.dedication:
        return _DedicationStep(
          selectedTarget: _dedicationTarget,
          honoreeNameController: _honoreeNameController,
          dedicationMessageController: _dedicationMessageController,
          keepPrivate: _keepPrivate,
          onTargetChanged: (target) =>
              setState(() => _dedicationTarget = target),
          onPrivateChanged: (value) =>
              setState(() => _keepPrivate = value ?? false),
          onAnyChanged: () => setState(() {}),
        );
      case _CreateStep.beneficiary:
        return _BeneficiaryStep(
          selectedCategories: _beneficiaryCategories,
          educationPercentController: _educationPercentController,
          healthcarePercentController: _healthcarePercentController,
          livelihoodPercentController: _livelihoodPercentController,
          notesController: _beneficiaryNotesController,
          onToggleCategory: (category) => setState(() {
            if (_beneficiaryCategories.contains(category)) {
              _beneficiaryCategories.remove(category);
            } else {
              _beneficiaryCategories.add(category);
            }
          }),
        );
      case _CreateStep.review:
        return _ReviewStep(
          instrument: _instrument,
          shares: _shares,
          shareValueEtb: _shareValueEtb,
          totalContribution: _totalContribution,
          dedicationTarget: _dedicationTarget,
          honoreeName: _honoreeNameController.text.trim(),
          dedicationMessage: _dedicationMessageController.text.trim(),
          keepPrivate: _keepPrivate,
          beneficiaryCategories: _beneficiaryCategories,
          educationPercent: _educationPercentController.text.trim(),
          healthcarePercent: _healthcarePercentController.text.trim(),
          livelihoodPercent: _livelihoodPercentController.text.trim(),
          notes: _beneficiaryNotesController.text.trim(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mejlis Awqaf'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StepHeader(
                stepIndex: _currentStepIndex,
                stepTitle: _stepTitle,
                totalSteps: _stepOrder.length,
              ),
              const SizedBox(height: 16),
              _buildStepContent(),
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
                  onPressed: _goBack,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.awqafPrimary,
                    foregroundColor: AppColors.textOnPrimary,
                  ),
                  onPressed: _canContinueCurrentStep ? _goNext : null,
                  icon: Icon(
                    _step == _CreateStep.review
                        ? Icons.verified_rounded
                        : Icons.arrow_forward,
                  ),
                  label: Text(
                    _step == _CreateStep.review
                        ? 'Confirm Dedication'
                        : 'Continue',
                  ),
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
    required this.stepTitle,
    required this.totalSteps,
  });

  final int stepIndex;
  final String stepTitle;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (stepIndex + 1) / totalSteps;
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
            value: progress,
            color: AppColors.awqafPrimary,
            backgroundColor: AppColors.awqafSecondary.withValues(alpha: 0.22),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          stepTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _InstrumentStep extends StatelessWidget {
  const _InstrumentStep({
    required this.instrument,
    required this.shares,
    required this.shareValueEtb,
    required this.totalContribution,
    required this.onInstrumentChanged,
    required this.onDecrementShares,
    required this.onIncrementShares,
  });

  final _WaqfInstrument instrument;
  final int shares;
  final int shareValueEtb;
  final double totalContribution;
  final ValueChanged<_WaqfInstrument> onInstrumentChanged;
  final VoidCallback onDecrementShares;
  final VoidCallback onIncrementShares;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<_WaqfInstrument>(
          segments: const [
            ButtonSegment(
              value: _WaqfInstrument.cash,
              icon: Icon(Icons.payments_outlined),
              label: Text('Cash Waqf'),
            ),
            ButtonSegment(
              value: _WaqfInstrument.assetLand,
              icon: Icon(Icons.home_work_outlined),
              label: Text('Asset/Land Waqf'),
            ),
          ],
          selected: {instrument},
          onSelectionChanged: (value) => onInstrumentChanged(value.first),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Waqf Shares Allocation',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Each share equals ETB $shareValueEtb and contributes to perpetual Awqaf impact.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton.outlined(
                      onPressed: onDecrementShares,
                      icon: const Icon(Icons.remove),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.35),
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
                            Text(
                              'TOTAL SHARES',
                              style: theme.textTheme.labelSmall,
                            ),
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
                      onPressed: onIncrementShares,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.awqafSecondary.withValues(alpha: 0.14),
                    border: Border.all(
                      color: AppColors.awqafSecondary.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Text(
                    'Total contribution: ETB ${totalContribution.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.awqafPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DedicationStep extends StatelessWidget {
  const _DedicationStep({
    required this.selectedTarget,
    required this.honoreeNameController,
    required this.dedicationMessageController,
    required this.keepPrivate,
    required this.onTargetChanged,
    required this.onPrivateChanged,
    required this.onAnyChanged,
  });

  final _DedicationTarget selectedTarget;
  final TextEditingController honoreeNameController;
  final TextEditingController dedicationMessageController;
  final bool keepPrivate;
  final ValueChanged<_DedicationTarget> onTargetChanged;
  final ValueChanged<bool?> onPrivateChanged;
  final VoidCallback onAnyChanged;

  @override
  Widget build(BuildContext context) {
    final targetOptions = <(_DedicationTarget, String, String)>[
      (_DedicationTarget.myself, 'Myself', 'Personal legacy dedication'),
      (_DedicationTarget.parents, 'Parents', 'Honor your parents'),
      (
        _DedicationTarget.deceasedRelative,
        'Deceased Relative',
        'Sadaqa Jariya for departed',
      ),
      (_DedicationTarget.anonymous, 'Anonymous', 'Without naming a recipient'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Dedicate this Waqf to:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        ...targetOptions.map((option) {
          final isSelected = selectedTarget == option.$1;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              onTap: () => onTargetChanged(option.$1),
              leading: Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: AppColors.awqafPrimary,
              ),
              title: Text(option.$2),
              subtitle: Text(option.$3),
            ),
          );
        }),
        const SizedBox(height: 8),
        TextField(
          controller: honoreeNameController,
          onChanged: (_) => onAnyChanged(),
          decoration: const InputDecoration(
            labelText: 'Honoree name (optional)',
            hintText: 'Enter the name',
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: dedicationMessageController,
          onChanged: (_) => onAnyChanged(),
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Message of dedication (optional)',
            hintText: 'A brief prayer or message for this endowment.',
          ),
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: keepPrivate,
          onChanged: onPrivateChanged,
          title: const Text('Keep this dedication private'),
          subtitle: const Text('Only approved reports will display this record.'),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }
}

class _BeneficiaryStep extends StatelessWidget {
  const _BeneficiaryStep({
    required this.selectedCategories,
    required this.educationPercentController,
    required this.healthcarePercentController,
    required this.livelihoodPercentController,
    required this.notesController,
    required this.onToggleCategory,
  });

  final Set<String> selectedCategories;
  final TextEditingController educationPercentController;
  final TextEditingController healthcarePercentController;
  final TextEditingController livelihoodPercentController;
  final TextEditingController notesController;
  final ValueChanged<String> onToggleCategory;

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Education Fund',
      'Healthcare Waqf',
      'Livelihood Support',
      'Community Infrastructure',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Target beneficiaries',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories
              .map(
                (category) => FilterChip(
                  selectedColor: AppColors.awqafSecondary.withValues(alpha: 0.22),
                  selected: selectedCategories.contains(category),
                  label: Text(category),
                  onSelected: (_) => onToggleCategory(category),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 14),
        Text(
          'Allocation (%)',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: educationPercentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Education'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: healthcarePercentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Healthcare'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: livelihoodPercentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Livelihood'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: notesController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Purpose/notes (optional)',
            hintText: 'Describe intended impact and distribution policy.',
          ),
        ),
      ],
    );
  }
}

class _ReviewStep extends StatelessWidget {
  const _ReviewStep({
    required this.instrument,
    required this.shares,
    required this.shareValueEtb,
    required this.totalContribution,
    required this.dedicationTarget,
    required this.honoreeName,
    required this.dedicationMessage,
    required this.keepPrivate,
    required this.beneficiaryCategories,
    required this.educationPercent,
    required this.healthcarePercent,
    required this.livelihoodPercent,
    required this.notes,
  });

  final _WaqfInstrument instrument;
  final int shares;
  final int shareValueEtb;
  final double totalContribution;
  final _DedicationTarget dedicationTarget;
  final String honoreeName;
  final String dedicationMessage;
  final bool keepPrivate;
  final Set<String> beneficiaryCategories;
  final String educationPercent;
  final String healthcarePercent;
  final String livelihoodPercent;
  final String notes;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Draft Deed Summary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 10),
            _ReviewLine(
              label: 'Instrument',
              value: instrument == _WaqfInstrument.cash
                  ? 'Cash Waqf'
                  : 'Asset/Land Waqf',
            ),
            _ReviewLine(
              label: 'Shares',
              value: '$shares shares (ETB $shareValueEtb each)',
            ),
            _ReviewLine(
              label: 'Total Contribution',
              value: 'ETB ${totalContribution.toStringAsFixed(2)}',
              valueColor: AppColors.awqafPrimary,
            ),
            _ReviewLine(
              label: 'Dedication',
              value: dedicationTarget.name,
            ),
            _ReviewLine(
              label: 'Honoree',
              value: honoreeName.isEmpty ? 'Not specified' : honoreeName,
            ),
            _ReviewLine(
              label: 'Message',
              value: dedicationMessage.isEmpty
                  ? 'No custom message'
                  : dedicationMessage,
            ),
            _ReviewLine(
              label: 'Privacy',
              value: keepPrivate ? 'Private' : 'Public acknowledgment',
            ),
            _ReviewLine(
              label: 'Beneficiaries',
              value: beneficiaryCategories.isEmpty
                  ? 'None selected'
                  : beneficiaryCategories.join(', '),
            ),
            _ReviewLine(
              label: 'Allocation',
              value:
                  'Edu $educationPercent% | Health $healthcarePercent% | Livelihood $livelihoodPercent%',
            ),
            if (notes.isNotEmpty) _ReviewLine(label: 'Notes', value: notes),
          ],
        ),
      ),
    );
  }
}

class _ReviewLine extends StatelessWidget {
  const _ReviewLine({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
