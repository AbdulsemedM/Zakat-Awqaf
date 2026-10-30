part of '../pages/profile_page.dart';

/// Help and support contacts (`GET /api/zakat/v1/support`), with their own
/// section header. Loaded each time the profile opens, since an admin can
/// change them; hidden while loading, when they can't load, or when none
/// is set. Tapping a contact copies it.
class _SupportSection extends StatefulWidget {
  const _SupportSection();

  @override
  State<_SupportSection> createState() => _SupportSectionState();
}

class _SupportSectionState extends State<_SupportSection> {
  SupportContact? _contact;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final contact = await getIt<ProfileRepository>().fetchSupportContact();
      if (mounted) setState(() => _contact = contact);
    } catch (_) {
      // No support section rather than an error on the profile.
    }
  }

  Future<void> _copy(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.supportCopied)));
  }

  @override
  Widget build(BuildContext context) {
    final contact = _contact;
    if (contact == null || contact.isEmpty) return const SizedBox.shrink();
    final l10n = context.l10n;
    final rows = <(IconData, String, String)>[
      if (contact.phone != null)
        (Icons.phone_outlined, l10n.supportPhone, contact.phone!),
      if (contact.email != null)
        (Icons.email_outlined, l10n.supportEmail, contact.email!),
      if (contact.webUrl != null)
        (Icons.language_rounded, l10n.supportWebsite, contact.webUrl!),
    ];
    final hours = contact.hours;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(l10n.profileSectionSupport),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            child: Column(
              children: [
                for (final (index, (icon, label, value)) in rows.indexed) ...[
                  if (index > 0)
                    const Divider(height: 1, indent: 56, endIndent: 16),
                  _ActionTile(
                    icon: icon,
                    iconColor: Theme.of(context).colorScheme.primary,
                    title: value,
                    subtitle: label,
                    trailing: Icon(
                      Icons.copy_rounded,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onTap: () => _copy(value),
                  ),
                ],
                if (hours != null) ...[
                  if (rows.isNotEmpty)
                    const Divider(height: 1, indent: 56, endIndent: 16),
                  _InfoRow(
                    label: l10n.supportHours,
                    value: hours,
                    icon: Icons.schedule_rounded,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
