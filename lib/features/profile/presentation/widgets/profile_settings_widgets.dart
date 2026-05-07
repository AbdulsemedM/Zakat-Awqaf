part of '../pages/profile_page.dart';

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
            title: Text(
              context.l10n.profileNisabThresholdAlerts,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              context.l10n.profileNisabThresholdAlertsSubtitle,
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
        ],
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
    final selectedLanguage = profile.language.label;
    final selectedTheme = profile.themePreference == AppThemePreference.light
        ? context.l10n.themeLight
        : context.l10n.themeDark;
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            _SelectorTile(
              icon: Icons.translate_rounded,
              title: context.l10n.profileLanguagePreferences,
              value: selectedLanguage,
              onTap: () => _pickLanguage(context, profile.language),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _SelectorTile(
              icon: Icons.palette_outlined,
              title: context.l10n.profileThemeMode,
              value: selectedTheme,
              onTap: () => _pickTheme(context, profile.themePreference),
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
              title: Text(
                context.l10n.profileChangePin,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: scheme.onSurfaceVariant,
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l10n.profileChangePinComingSoon)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickLanguage(BuildContext context, AppLanguage current) async {
    final selection = await showModalBottomSheet<AppLanguage>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text(
                  context.l10n.profileLanguagePreferences,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              for (final lang in AppLanguage.values)
                ListTile(
                  title: Text(lang.label),
                  trailing: lang == current
                      ? Icon(
                          Icons.check_rounded,
                          color: theme.colorScheme.primary,
                        )
                      : null,
                  selected: lang == current,
                  selectedTileColor: theme.colorScheme.primary.withValues(
                    alpha: 0.08,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onTap: () => Navigator.of(sheetContext).pop(lang),
                ),
            ],
          ),
        );
      },
    );
    if (selection == null || selection == current) return;
    if (!context.mounted) return;
    context.read<AppSettingsController>().setLanguage(selection);
    context.read<ProfileBloc>().add(ProfileLanguageSelected(selection));
  }

  Future<void> _pickTheme(
    BuildContext context,
    AppThemePreference current,
  ) async {
    final selection = await showModalBottomSheet<AppThemePreference>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text(
                  context.l10n.profileThemeMode,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ListTile(
                title: Text(context.l10n.themeLight),
                trailing: current == AppThemePreference.light
                    ? Icon(
                        Icons.check_rounded,
                        color: theme.colorScheme.primary,
                      )
                    : null,
                selected: current == AppThemePreference.light,
                selectedTileColor: theme.colorScheme.primary.withValues(
                  alpha: 0.08,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () => Navigator.of(sheetContext).pop(
                  AppThemePreference.light,
                ),
              ),
              ListTile(
                title: Text(context.l10n.themeDark),
                trailing: current == AppThemePreference.dark
                    ? Icon(
                        Icons.check_rounded,
                        color: theme.colorScheme.primary,
                      )
                    : null,
                selected: current == AppThemePreference.dark,
                selectedTileColor: theme.colorScheme.primary.withValues(
                  alpha: 0.08,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () => Navigator.of(sheetContext).pop(
                  AppThemePreference.dark,
                ),
              ),
            ],
          ),
        );
      },
    );
    if (selection == null || selection == current) return;
    if (!context.mounted) return;
    context.read<ProfileBloc>().add(ProfileThemeSelected(selection));
    context.read<AppSettingsController>().setThemeMode(
      selection == AppThemePreference.light
          ? ThemeMode.light
          : ThemeMode.dark,
    );
  }
}

class _SelectorTile extends StatelessWidget {
  const _SelectorTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        value,
        style: theme.textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: scheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}
