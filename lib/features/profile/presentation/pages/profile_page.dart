import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/settings/app_settings_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/primary_hero.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/utils/number_format.dart';
import '../../bloc/profile_bloc.dart';
import '../../bloc/profile_event.dart';
import '../../bloc/profile_state.dart';
import '../../data/models/profile_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return switch (state) {
            ProfileInitial() || ProfileLoading() =>
              const Center(child: CircularProgressIndicator()),
            ProfileError(:final message) => _ErrorView(message: message),
            ProfileLoaded(:final profile) => _ProfileContent(profile: profile),
          };
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              'Could not load your profile',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context
                  .read<ProfileBloc>()
                  .add(const ProfileStarted()),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ProfileHeroHeader(profile: profile),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SectionHeader('Impact Dashboard'),
            ),
            const SizedBox(height: 8),
            _ImpactDashboardRow(profile: profile),
            if (profile.isBeneficiary) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _SectionHeader('Beneficiary Insights'),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _BeneficiaryInsightsCard(profile: profile),
              ),
            ],
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SectionHeader('Personal Information'),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _PersonalInfoCard(profile: profile),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SectionHeader('Spiritual Settings'),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SpiritualSettingsCard(profile: profile),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SectionHeader('Core Actions'),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _CoreActionsCard(profile: profile),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SectionHeader('Settings & Security'),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SettingsSecurityCard(profile: profile),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SectionHeader('Support'),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SupportCard(),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _HadithOfTheDayCard(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label.toUpperCase(),
      style: theme.textTheme.labelMedium?.copyWith(
        letterSpacing: 1.2,
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _ProfileHeroHeader extends StatelessWidget {
  const _ProfileHeroHeader({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(
            16,
            MediaQuery.of(context).padding.top + 12,
            16,
            48,
          ),
          decoration: BoxDecoration(
            gradient: PrimaryHero.gradient(scheme),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Mejlis Hub',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No new notifications')),
                      );
                    },
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _Avatar(
                    name: profile.name,
                    asset: profile.avatarAsset,
                    ringColor: AppColors.textOnPrimary,
                    fillColor: AppColors.textOnPrimary.withValues(alpha: 0.16),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.28),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: AppColors.secondary,
                            ),
                          ),
                          child: Text(
                            profile.roleLabel.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.onSecondary,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: -22,
          child: Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(14),
            color: scheme.surface,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Icon(
                    profile.isFaydaVerified
                        ? Icons.verified_rounded
                        : Icons.gpp_maybe_rounded,
                    color: profile.isFaydaVerified
                        ? AppColors.primary
                        : scheme.error,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verification Status',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          profile.isFaydaVerified
                              ? 'Fayda Verified'
                              : 'Not verified',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.28),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: -38,
          child: SizedBox(height: 16),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.name,
    required this.asset,
    required this.ringColor,
    required this.fillColor,
  });

  final String name;
  final String? asset;
  final Color ringColor;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    final initials = _initials(name);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: fillColor,
            border: Border.all(color: ringColor.withValues(alpha: 0.6), width: 2),
            image: asset != null
                ? DecorationImage(
                    image: AssetImage(asset!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          alignment: Alignment.center,
          child: asset == null
              ? Text(
                  initials,
                  style: TextStyle(
                    color: ringColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  ),
                )
              : null,
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: ringColor, width: 2),
            ),
            child: Icon(
              Icons.check_rounded,
              size: 14,
              color: ringColor,
            ),
          ),
        ),
      ],
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.characters.take(2).toString().toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}

class _ImpactDashboardRow extends StatelessWidget {
  const _ImpactDashboardRow({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final stats = <_ImpactStat>[
      _ImpactStat(
        icon: Icons.volunteer_activism_rounded,
        label: 'Total Zakat Paid',
        primary: 'ETB ${formatThousands(profile.totalZakatPaid)}',
        secondary: 'FY 2023 Summary',
      ),
      _ImpactStat(
        icon: Icons.account_balance_rounded,
        label: 'Active Endowments',
        primary: profile.activeEndowments.toString(),
        secondary: 'Sustainable impact',
      ),
      _ImpactStat(
        icon: Icons.groups_2_rounded,
        label: 'Beneficiaries Helped',
        primary: profile.beneficiariesHelped.toString(),
        secondary: 'Across programs',
      ),
    ];

    return SizedBox(
      height: 132,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: stats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) => _ImpactStatCard(stat: stats[index]),
      ),
    );
  }
}

class _ImpactStat {
  const _ImpactStat({
    required this.icon,
    required this.label,
    required this.primary,
    required this.secondary,
  });

  final IconData icon;
  final String label;
  final String primary;
  final String secondary;
}

class _ImpactStatCard extends StatelessWidget {
  const _ImpactStatCard({required this.stat});

  final _ImpactStat stat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SizedBox(
      width: 200,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(stat.icon, size: 18, color: AppColors.primary),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      stat.label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                stat.primary,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                stat.secondary,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BeneficiaryInsightsCard extends StatelessWidget {
  const _BeneficiaryInsightsCard({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final statusColor = switch (profile.beneficiaryStatus) {
      BeneficiaryStatus.approved => AppColors.primary,
      BeneficiaryStatus.pending => scheme.secondary,
      BeneficiaryStatus.rejected => scheme.error,
    };
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Application Status',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        profile.beneficiaryStatus ==
                                BeneficiaryStatus.approved
                            ? Icons.check_circle_rounded
                            : profile.beneficiaryStatus ==
                                    BeneficiaryStatus.pending
                                ? Icons.schedule_rounded
                                : Icons.cancel_rounded,
                        size: 16,
                        color: statusColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        profile.beneficiaryStatus.label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Icon(
                  Icons.event_available_rounded,
                  size: 18,
                  color: scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Last Disbursement',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Text(
                  profile.lastDisbursement != null
                      ? _formatDate(profile.lastDisbursement!)
                      : '—',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.payments_rounded,
                  size: 18,
                  color: scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Total Aid Received',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Text(
                  'ETB ${formatThousands(profile.totalAidReceived)}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonalInfoCard extends StatelessWidget {
  const _PersonalInfoCard({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(
        children: [
          _EditableInfoRow(
            label: 'Email Address',
            value: profile.email,
            icon: Icons.email_outlined,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _EditableInfoRow(
            label: 'Phone Number',
            value: profile.phone,
            icon: Icons.phone_outlined,
          ),
        ],
      ),
    );
  }
}

class _EditableInfoRow extends StatelessWidget {
  const _EditableInfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: scheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Edit $label coming soon')),
              );
            },
            icon: Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
          ),
        ],
      ),
    );
  }
}

class _SpiritualSettingsCard extends StatelessWidget {
  const _SpiritualSettingsCard({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      elevation: 0,
      child: Column(
        children: [
          SwitchListTile.adaptive(
            value: profile.nisabAlerts,
            onChanged: (v) => context
                .read<ProfileBloc>()
                .add(ProfileNisabAlertsToggled(v)),
            title: const Text(
              'Nisab Threshold Alerts',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Notify when wealth reaches threshold',
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            secondary: Icon(
              Icons.notifications_active_outlined,
              color: scheme.onSurfaceVariant,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: Icon(
              Icons.menu_book_outlined,
              color: scheme.onSurfaceVariant,
            ),
            title: const Text(
              'Preferred Madhhab',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Used for Zakat calculations',
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  profile.madhhab.label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  color: scheme.onSurfaceVariant,
                ),
              ],
            ),
            onTap: () => _pickMadhhab(context, profile.madhhab),
          ),
        ],
      ),
    );
  }

  Future<void> _pickMadhhab(BuildContext context, Madhhab current) async {
    final bloc = context.read<ProfileBloc>();
    final selection = await showModalBottomSheet<Madhhab>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Text(
                  'Preferred Madhhab',
                  style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              for (final m in Madhhab.values)
                RadioListTile<Madhhab>(
                  value: m,
                  groupValue: current,
                  title: Text(m.label),
                  onChanged: (selected) =>
                      Navigator.of(sheetContext).pop(selected),
                ),
              const SizedBox(height: 4),
            ],
          ),
        );
      },
    );
    if (selection != null && selection != current) {
      bloc.add(ProfileMadhhabSelected(selection));
    }
  }
}

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
            title: 'My Zakat History',
            subtitle: 'View ledger & certificates',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Zakat history coming soon')),
              );
            },
          ),
          const Divider(height: 1, indent: 56, endIndent: 16),
          _ActionTile(
            icon: Icons.account_balance_rounded,
            iconColor: Theme.of(context).colorScheme.secondary,
            title: 'My Awqaf Endowments',
            subtitle: 'View schools & wells',
            onTap: () => context.go('/awqaf'),
          ),
          const Divider(height: 1, indent: 56, endIndent: 16),
          _ActionTile(
            icon: Icons.assignment_outlined,
            iconColor: Theme.of(context).colorScheme.tertiary,
            title: profile.isBeneficiary
                ? 'Beneficiary Application'
                : 'Apply as Beneficiary',
            subtitle: profile.isBeneficiary
                ? 'Submit or track aid requests'
                : 'Register to receive aid',
            onTap: () => context.go('/beneficiary-registration'),
          ),
          const Divider(height: 1, indent: 56, endIndent: 16),
          _ActionTile(
            icon: Icons.receipt_long_outlined,
            iconColor: Theme.of(context).colorScheme.primary,
            title: 'Donation History',
            subtitle: 'See every contribution',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Donation history coming soon')),
              );
            },
          ),
          const Divider(height: 1, indent: 56, endIndent: 16),
          _ActionTile(
            icon: Icons.description_outlined,
            iconColor: Theme.of(context).colorScheme.primary,
            title: 'Tax Receipts',
            subtitle: 'Download annual statements',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tax receipts coming soon')),
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

class _SettingsSecurityCard extends StatelessWidget {
  const _SettingsSecurityCard({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  Icon(
                    Icons.translate_rounded,
                    size: 18,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.profileLanguagePreferences,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: _LanguageChipRow(profile: profile),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  Icon(
                    Icons.palette_outlined,
                    size: 18,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.profileThemeMode,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: _ThemeChipRow(profile: profile),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            SwitchListTile.adaptive(
              value: profile.biometricEnabled,
              onChanged: (v) => context
                  .read<ProfileBloc>()
                  .add(ProfileBiometricToggled(v)),
              title: Text(
                context.l10n.profileBiometricLogin,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                context.l10n.profileBiometricSubtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              secondary: Icon(
                Icons.fingerprint_rounded,
                color: scheme.onSurfaceVariant,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            ListTile(
              leading: Icon(
                Icons.lock_outline_rounded,
                color: scheme.onSurfaceVariant,
              ),
              title: const Text(
                'Change PIN',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: scheme.onSurfaceVariant,
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Change PIN coming soon')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageChipRow extends StatelessWidget {
  const _LanguageChipRow({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final lang in AppLanguage.values)
          ChoiceChip(
            label: Text(lang.label),
            selected: lang == profile.language,
            onSelected: (selected) {
              if (selected) {
                context.read<AppSettingsController>().setLanguage(lang);
                context
                    .read<ProfileBloc>()
                    .add(ProfileLanguageSelected(lang));
              }
            },
          ),
      ],
    );
  }
}

class _ThemeChipRow extends StatelessWidget {
  const _ThemeChipRow({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final pref in AppThemePreference.values)
          ChoiceChip(
            label: Text(
              pref == AppThemePreference.light
                  ? context.l10n.themeLight
                  : context.l10n.themeDark,
            ),
            selected: pref == profile.themePreference,
            onSelected: (selected) {
              if (!selected) return;
              context.read<ProfileBloc>().add(ProfileThemeSelected(pref));
              context.read<AppSettingsController>().setThemeMode(
                pref == AppThemePreference.light
                    ? ThemeMode.light
                    : ThemeMode.dark,
              );
            },
          ),
      ],
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
            title: 'Help Center',
            subtitle: 'FAQs and guidance',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help center coming soon')),
              );
            },
          ),
          const Divider(height: 1, indent: 56, endIndent: 16),
          _ActionTile(
            icon: Icons.support_agent_rounded,
            iconColor: AppColors.primary,
            title: 'Support & Grievances',
            subtitle: 'Talk to our team',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Support center coming soon')),
              );
            },
          ),
          const Divider(height: 1, indent: 56, endIndent: 16),
          _ActionTile(
            icon: Icons.logout_rounded,
            iconColor: scheme.error,
            title: 'Log Out',
            subtitle: 'End your current session',
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
        title: const Text('Log out?'),
        content: const Text(
          'You will be signed out of Mejlis Hub on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Log Out'),
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
            'Hadith of the Day',
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '"The believer\'s shade on the Day of Resurrection will be his charity."',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              color: scheme.onSurface,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '— At-Tirmidhi',
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
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
