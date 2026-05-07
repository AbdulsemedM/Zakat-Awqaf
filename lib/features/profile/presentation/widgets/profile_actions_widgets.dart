part of '../pages/profile_page.dart';

class _CoreActionsCard extends StatelessWidget {
  const _CoreActionsCard({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(
        children: [
          _ActionTile(
            icon: Icons.history_rounded,
            iconColor: Theme.of(context).colorScheme.primary,
            title: context.l10n.profileMyZakatHistory,
            subtitle: context.l10n.profileMyZakatHistorySubtitle,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.profileZakatHistoryComingSoon)),
              );
            },
          ),
          const Divider(height: 1, indent: 56, endIndent: 16),
          _ActionTile(
            icon: Icons.account_balance_rounded,
            iconColor: Theme.of(context).colorScheme.secondary,
            title: context.l10n.profileMyAwqafEndowments,
            subtitle: context.l10n.profileMyAwqafEndowmentsSubtitle,
            onTap: () => context.go('/awqaf'),
          ),
          const Divider(height: 1, indent: 56, endIndent: 16),
          _ActionTile(
            icon: Icons.assignment_outlined,
            iconColor: Theme.of(context).colorScheme.tertiary,
            title: profile.isBeneficiary
                ? context.l10n.profileBeneficiaryApplication
                : context.l10n.profileApplyAsBeneficiary,
            subtitle: profile.isBeneficiary
                ? context.l10n.profileBeneficiaryApplicationSubtitle
                : context.l10n.profileApplyAsBeneficiarySubtitle,
            onTap: () => context.go('/beneficiary-registration'),
          ),
          const Divider(height: 1, indent: 56, endIndent: 16),
          _ActionTile(
            icon: Icons.receipt_long_outlined,
            iconColor: Theme.of(context).colorScheme.primary,
            title: context.l10n.profileDonationHistory,
            subtitle: context.l10n.profileDonationHistorySubtitle,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.profileDonationHistoryComingSoon)),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
    this.titleColor,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: titleColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      trailing: trailing ??
          Icon(
            Icons.chevron_right_rounded,
            color: scheme.onSurfaceVariant,
          ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      elevation: 0,
      child: Column(
        children: [
          _ActionTile(
            icon: Icons.help_outline_rounded,
            iconColor: AppColors.primary,
            title: context.l10n.profileHelpCenter,
            subtitle: context.l10n.profileHelpCenterSubtitle,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.profileHelpCenterComingSoon)),
              );
            },
          ),
          const Divider(height: 1, indent: 56, endIndent: 16),
          _ActionTile(
            icon: Icons.support_agent_rounded,
            iconColor: AppColors.primary,
            title: context.l10n.profileSupportAndGrievances,
            subtitle: context.l10n.profileSupportAndGrievancesSubtitle,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.profileSupportCenterComingSoon)),
              );
            },
          ),
          const Divider(height: 1, indent: 56, endIndent: 16),
          _ActionTile(
            icon: Icons.logout_rounded,
            iconColor: scheme.error,
            title: context.l10n.profileLogOut,
            subtitle: context.l10n.profileLogOutSubtitle,
            titleColor: scheme.error,
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: scheme.error.withValues(alpha: 0.7),
            ),
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final bloc = context.read<ProfileBloc>();
    final theme = Theme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.profileLogOutDialogTitle),
        content: Text(context.l10n.profileLogOutDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.profileCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.l10n.profileLogOut),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      bloc.add(const ProfileLoggedOut());
    }
  }
}

class _HadithOfTheDayCard extends StatelessWidget {
  const _HadithOfTheDayCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppColors.secondary.withValues(alpha: 0.22),
            scheme.surfaceContainerLow,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        children: [
          Text(
            '\u201C',
            style: TextStyle(
              fontSize: 36,
              height: 1,
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            context.l10n.profileHadithOfTheDay,
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.profileHadithQuote,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              color: scheme.onSurface,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.profileHadithSource,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  return DateFormat('d MMM yyyy').format(date);
}
