part of '../pages/profile_page.dart';

/// Where the beneficiary's disbursements are paid. The banks come from
/// `GET /payout-banks`: available ones can be picked, the others show as
/// "Coming soon". Saved with the bank's code; the server locks the account
/// once the first assessment is submitted (its message says so).
class _PayoutAccountSetupCard extends StatefulWidget {
  const _PayoutAccountSetupCard({required this.profile});

  final ProfileModel profile;

  @override
  State<_PayoutAccountSetupCard> createState() =>
      _PayoutAccountSetupCardState();
}

class _PayoutAccountSetupCardState extends State<_PayoutAccountSetupCard> {
  late final TextEditingController _accountController;
  List<PayoutBank>? _banks;
  bool _banksFailed = false;
  String? _selectedCode;
  String? _accountError;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _accountController = TextEditingController(
      text: widget.profile.coopBankAccountNumber ?? '',
    );
    _loadBanks();
  }

  @override
  void didUpdateWidget(covariant _PayoutAccountSetupCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final saved = widget.profile.coopBankAccountNumber ?? '';
    if (saved != (oldWidget.profile.coopBankAccountNumber ?? '')) {
      _accountController.text = saved;
    }
    if (widget.profile.bankCode != oldWidget.profile.bankCode) {
      _selectedCode = _initialCode(_banks);
    }
  }

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  Future<void> _loadBanks() async {
    setState(() => _banksFailed = false);
    try {
      final banks = await getIt<ProfileRepository>().fetchPayoutBanks();
      if (!mounted) return;
      setState(() {
        _banks = banks;
        _selectedCode = _initialCode(banks);
      });
    } catch (_) {
      if (mounted) setState(() => _banksFailed = true);
    }
  }

  /// The saved bank when it can still be picked, else the first available.
  String? _initialCode(List<PayoutBank>? banks) {
    final available = [...?banks?.where((b) => b.available)];
    final saved = widget.profile.bankCode;
    if (available.any((b) => b.code == saved)) return saved;
    return available.isEmpty ? null : available.first.code;
  }

  PayoutBank? get _selectedBank {
    for (final bank in _banks ?? const <PayoutBank>[]) {
      if (bank.code == _selectedCode) return bank;
    }
    return null;
  }

  void _saveAccountNumber() {
    final bank = _selectedBank;
    if (bank == null) return;
    final l10n = context.l10n;
    final accountNumber = PayoutBank.normalizeAccountNumber(
      _accountController.text,
    );
    final error = accountNumber.isEmpty
        ? l10n.profileAccountNumberRequired
        : !bank.acceptsAccountNumber(accountNumber)
        ? l10n.profileAccountNumberInvalid
        : null;
    setState(() => _accountError = error);
    if (error != null) return;
    setState(() => _saving = true);
    context.read<ProfileBloc>().add(
      ProfileBankAccountSaved(
        bankCode: bank.code,
        accountNumber: accountNumber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final banks = _banks;

    final Widget bankList;
    if (banks == null && _banksFailed) {
      bankList = Row(
        children: [
          Expanded(
            child: Text(
              l10n.profilePayoutBanksLoadError,
              style: theme.textTheme.bodyMedium?.copyWith(color: scheme.error),
            ),
          ),
          TextButton(onPressed: _loadBanks, child: Text(l10n.profileTryAgain)),
        ],
      );
    } else if (banks == null) {
      bankList = const Padding(
        padding: EdgeInsets.all(12),
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      bankList = Column(
        children: [
          for (final bank in banks) ...[
            _PayoutBankTile(
              bank: bank,
              selected: bank.code == _selectedCode,
              onTap: bank.available && !_saving
                  ? () => setState(() {
                      _selectedCode = bank.code;
                      _accountError = null;
                    })
                  : null,
            ),
            const SizedBox(height: 8),
          ],
        ],
      );
    }

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
                l10n.profileDisbursementIntro,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              bankList,
              const SizedBox(height: 8),
              TextField(
                controller: _accountController,
                keyboardType: TextInputType.number,
                enabled: !_saving && _selectedBank != null,
                onChanged: (_) {
                  if (_accountError != null) {
                    setState(() => _accountError = null);
                  }
                },
                decoration: InputDecoration(
                  labelText: l10n.profileAccountNumberLabel,
                  hintText: l10n.profileCoopAccountHint,
                  errorText: _accountError,
                  prefixIcon: const Icon(Icons.numbers_rounded),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                ),
                onPressed: _saving || _selectedBank == null
                    ? null
                    : _saveAccountNumber,
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.textOnPrimary,
                        ),
                      )
                    : Text(l10n.profileSaveAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PayoutBankTile extends StatelessWidget {
  const _PayoutBankTile({
    required this.bank,
    required this.selected,
    required this.onTap,
  });

  final PayoutBank bank;
  final bool selected;

  /// `null` for a bank that can't be picked (not available, or saving).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Opacity(
      opacity: bank.available ? 1 : 0.55,
      child: Material(
        color: selected
            ? AppColors.secondary.withValues(alpha: 0.22)
            : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: selected ? AppColors.primary : scheme.outlineVariant,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: scheme.surfaceContainerHighest,
                  child: const Icon(
                    Icons.account_balance_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    bank.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                if (!bank.available)
                  Text(
                    context.l10n.profileBankComingSoon,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  )
                else if (selected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
