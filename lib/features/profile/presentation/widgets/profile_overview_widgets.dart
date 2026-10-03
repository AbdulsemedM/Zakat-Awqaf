part of '../pages/profile_page.dart';

class _ProfileHeroHeader extends StatelessWidget {
  const _ProfileHeroHeader({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: PrimaryHero.zakatHeroGradient,
                  ),
                ),
              ),
              const IslamicPatternLayer(
                opacity: 0.13,
                fadeTo: Alignment.bottomLeft,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  MediaQuery.of(context).padding.top + 12,
                  16,
                  48,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const AppLogo(
                          height: 28,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            context.l10n.appTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.textOnPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.l10n.profileNoNewNotifications,
                                ),
                              ),
                            );
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.10,
                            ),
                            side: BorderSide(
                              color: AppColors.goldLight.withValues(
                                alpha: 0.45,
                              ),
                            ),
                          ),
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.goldLight,
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
                          verified:
                              profile.isBeneficiary &&
                              profile.beneficiaryStatus ==
                                  BeneficiaryStatus.approved,
                          ringColor: AppColors.goldLight,
                          fillColor: Colors.white.withValues(alpha: 0.12),
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
                                  gradient: PrimaryHero.goldButtonGradient,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  (profile.isBeneficiary
                                          ? context.l10n.profileRoleBeneficiary
                                          : context.l10n.profileRoleDonor)
                                      .toUpperCase(),
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
            ],
          ),
        ),
        // Beneficiaries: verification of their application. Donors have
        // nothing to verify, so no card.
        if (profile.isBeneficiary) ...[
          Positioned(
            left: 16,
            right: 16,
            bottom: -22,
            child: _VerificationCard(status: profile.beneficiaryStatus),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: -38,
            child: SizedBox(height: 16),
          ),
        ],
      ],
    );
  }
}

/// The beneficiary's verification, from `GET /me/application`.
class _VerificationCard extends StatelessWidget {
  const _VerificationCard({required this.status});

  final BeneficiaryStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final (icon, color) = switch (status) {
      BeneficiaryStatus.approved => (Icons.verified_rounded, AppColors.primary),
      BeneficiaryStatus.pending => (Icons.schedule_rounded, scheme.secondary),
      BeneficiaryStatus.rejected => (Icons.gpp_bad_rounded, scheme.error),
    };
    return PremiumCard(
      radius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.profileVerificationStatus,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  beneficiaryStatusLabel(context, status),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
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

/// Localized verification status of a beneficiary.
String beneficiaryStatusLabel(BuildContext context, BeneficiaryStatus status) {
  final l10n = context.l10n;
  return switch (status) {
    BeneficiaryStatus.approved => l10n.profileVerificationVerified,
    BeneficiaryStatus.pending => l10n.profileVerificationPending,
    BeneficiaryStatus.rejected => l10n.profileVerificationRejected,
  };
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.name,
    required this.asset,
    required this.verified,
    required this.ringColor,
    required this.fillColor,
  });

  final String name;
  final String? asset;

  /// Shows the check badge (a verified beneficiary).
  final bool verified;
  final Color ringColor;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            border: Border.all(
              color: ringColor.withValues(alpha: 0.6),
              width: 2,
            ),
            image: asset != null
                ? DecorationImage(image: AssetImage(asset!), fit: BoxFit.cover)
                : null,
          ),
          alignment: Alignment.center,
          child: asset == null
              ? Text(
                  initials,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: ringColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  ),
                )
              : null,
        ),
        if (verified)
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
              child: Icon(Icons.check_rounded, size: 14, color: ringColor),
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
                    context.l10n.profileApplicationStatus,
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
                        profile.beneficiaryStatus == BeneficiaryStatus.approved
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
                        beneficiaryStatusLabel(
                          context,
                          profile.beneficiaryStatus,
                        ),
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
            if (profile.applicationMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                profile.applicationMessage!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
            const Divider(height: 24),
            if (profile.applicationCaseStatus != null) ...[
              _InsightRow(
                icon: Icons.assignment_turned_in_outlined,
                label: context.l10n.profileCaseStatus,
                value: _caseStatusLabel(
                  context,
                  profile.applicationCaseStatus!,
                ),
              ),
              const SizedBox(height: 12),
            ],
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
                    context.l10n.profileLastDisbursement,
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
                    context.l10n.profileTotalAidReceived,
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

class _InsightRow extends StatelessWidget {
  const _InsightRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: scheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
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
            label: context.l10n.profileEmailAddress,
            value: profile.email,
            icon: Icons.email_outlined,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _EditableInfoRow(
            label: context.l10n.profilePhoneNumber,
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
                SnackBar(
                  content: Text(context.l10n.profileEditFieldComingSoon(label)),
                ),
              );
            },
            icon: Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
          ),
        ],
      ),
    );
  }
}

/// Localized `caseStatus`; the raw value for one the app does not know.
String _caseStatusLabel(BuildContext context, String caseStatus) {
  final l10n = context.l10n;
  return switch (caseStatus.toUpperCase()) {
    'SUBMITTED' => l10n.caseStatusSubmitted,
    'VERIFIED' => l10n.caseStatusVerified,
    'APPROVED' => l10n.caseStatusApproved,
    'ACTIVE' => l10n.caseStatusActive,
    'CLOSED' => l10n.caseStatusClosed,
    _ => caseStatus,
  };
}
