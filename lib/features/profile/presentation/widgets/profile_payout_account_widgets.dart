part of '../pages/profile_page.dart';

class _PayoutAccountSetupCard extends StatefulWidget {
  const _PayoutAccountSetupCard({required this.profile});

  final ProfileModel profile;

  @override
  State<_PayoutAccountSetupCard> createState() => _PayoutAccountSetupCardState();
}

class _PayoutAccountSetupCardState extends State<_PayoutAccountSetupCard> {
  late final TextEditingController _accountController;
  late FinancialInstitution _selected;
  bool _saving = false;

  FinancialInstitution _institutionFromBankName(String? bankName) {
    if (bankName == null || bankName.trim().isEmpty) {
      return FinancialInstitution.coopBank;
    }
    for (final institution in FinancialInstitution.values) {
      if (institution.label.toLowerCase() == bankName.trim().toLowerCase()) {
        return institution;
      }
    }
    return FinancialInstitution.coopBank;
  }

  @override
  void initState() {
    super.initState();
    _selected = _institutionFromBankName(widget.profile.bankName);
    _accountController = TextEditingController(
      text: widget.profile.coopBankAccountNumber ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant _PayoutAccountSetupCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final saved = widget.profile.coopBankAccountNumber ?? '';
    if (saved != _accountController.text) {
      _accountController.text = saved;
    }
    if (widget.profile.bankName != oldWidget.profile.bankName) {
      _selected = _institutionFromBankName(widget.profile.bankName);
    }
  }

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  IconData _iconFor(FinancialInstitution institution) {
    return switch (institution) {
      FinancialInstitution.teleBirr => Icons.phone_android_rounded,
      _ => Icons.account_balance_rounded,
    };
  }

  void _saveAccountNumber() {
    final accountNumber = _accountController.text.trim();
    if (accountNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your Coop Bank account number.'),
        ),
      );
      return;
    }
    setState(() => _saving = true);
    context.read<ProfileBloc>().add(
          ProfileBankAccountSaved(
            bankName: _selected.label,
            accountNumber: accountNumber,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) =>
          current is ProfileLoaded && current.feedbackMessage != null,
      listener: (context, state) {
        if (state is ProfileLoaded && state.feedbackMessage != null) {
          setState(() => _saving = false);
        }
      },
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Choose where you want to receive disbursements.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              ...FinancialInstitution.values.map((institution) {
                final isSelected = _selected == institution;
                final isAvailable = institution.isAvailable;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _FinancialInstitutionTile(
                    title: institution.label,
                    icon: _iconFor(institution),
                    selected: isSelected,
                    enabled: isAvailable,
                    onTap: isAvailable
                        ? () => setState(() => _selected = institution)
                        : null,
                  ),
                );
              }),
              if (_selected == FinancialInstitution.coopBank) ...[
                const SizedBox(height: 6),
                TextField(
                  controller: _accountController,
                  keyboardType: TextInputType.number,
                  enabled: !_saving,
                  decoration: const InputDecoration(
                    labelText: 'Coop Bank Account Number',
                    hintText: 'Enter your account number',
                    prefixIcon: Icon(Icons.numbers_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textOnPrimary,
                  ),
                  onPressed: _saving ? null : _saveAccountNumber,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.textOnPrimary,
                          ),
                        )
                      : const Text('Save Account'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FinancialInstitutionTile extends StatelessWidget {
  const _FinancialInstitutionTile({
    required this.title,
    required this.icon,
    required this.selected,
    required this.enabled,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: selected && enabled
                ? AppColors.secondary.withValues(alpha: 0.22)
                : scheme.surface,
            border: Border.all(
              color: selected && enabled
                  ? AppColors.primary
                  : scheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: scheme.surfaceContainerHighest,
                child: Icon(
                  icon,
                  size: 18,
                  color: enabled ? AppColors.primary : scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: enabled
                            ? scheme.onSurface
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                    if (!enabled) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Coming soon',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (enabled)
                Icon(
                  selected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: selected ? AppColors.primary : scheme.outline,
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Soon',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
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
