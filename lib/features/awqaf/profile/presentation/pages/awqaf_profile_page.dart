import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../app/settings/app_settings_controller.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/widgets/app_logo.dart';
import '../../../../profile/data/models/profile_model.dart';

class AwqafProfilePage extends StatefulWidget {
  const AwqafProfilePage({super.key});

  @override
  State<AwqafProfilePage> createState() => _AwqafProfilePageState();
}

class _AwqafProfilePageState extends State<AwqafProfilePage> {
  bool _privateMode = true;
  bool _biometricLock = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = context.watch<AppSettingsController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TopBar(onNotificationsTap: _showComingSoon),
              const SizedBox(height: 8),
              _HeroCard(),
              const SizedBox(height: 10),
              _SectionLabel(label: 'My Active Shares', trailingLabel: 'View All'),
              const SizedBox(height: 6),
              _ActiveShareCard(onTap: () => context.push('/awqaf/portfolio')),
              const SizedBox(height: 12),
              _SectionLabel(label: 'Governance & Transparency'),
              const SizedBox(height: 6),
              _ListGroup(
                children: [
                  _ListActionTile(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Digital Waqf Certificates',
                    onTap: () => _showComingSoon('Digital Waqf Certificates'),
                  ),
                  _ListActionTile(
                    icon: Icons.layers_outlined,
                    title: 'Land & Asset Titles',
                    onTap: () => _showComingSoon('Land & Asset Titles'),
                  ),
                  _ListActionTile(
                    icon: Icons.gavel_outlined,
                    title: 'Memorial (AhAh) Settings',
                    onTap: () => _showComingSoon('Memorial (AhAh) Settings'),
                  ),
                  _ListActionTile(
                    icon: Icons.auto_graph_outlined,
                    title: 'Sharia Compliance Report',
                    onTap: () => context.push('/awqaf/portfolio'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SectionLabel(label: 'Preferences & Security'),
              const SizedBox(height: 6),
              _PreferencesCard(
                privateMode: _privateMode,
                biometricLock: _biometricLock,
                languageLabel: settings.language.label,
                onPrivateModeChanged: (value) {
                  setState(() => _privateMode = value);
                },
                onBiometricChanged: (value) {
                  setState(() => _biometricLock = value);
                },
                onLanguageTap: () => _pickLanguage(settings.language),
              ),
              const SizedBox(height: 14),
              _QuoteCard(textTheme: theme.textTheme),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon([String feature = 'This feature']) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature is coming soon.')),
    );
  }

  Future<void> _pickLanguage(AppLanguage current) async {
    final selection = await showModalBottomSheet<AppLanguage>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              const ListTile(
                title: Text(
                  'Choose language',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              for (final lang in AppLanguage.values)
                ListTile(
                  title: Text(lang.label),
                  trailing: lang == current ? const Icon(Icons.check_rounded) : null,
                  onTap: () => Navigator.of(sheetContext).pop(lang),
                ),
            ],
          ),
        );
      },
    );

    if (selection == null || selection == current || !mounted) {
      return;
    }

    await context.read<AppSettingsController>().setLanguage(selection);
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onNotificationsTap});

  final VoidCallback onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          const AppLogo(height: 30, borderRadius: BorderRadius.all(Radius.circular(6))),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'MEJLIS DIGITAL\nHUB',
              style: TextStyle(
                fontSize: 11,
                height: 1.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
          IconButton(
            splashRadius: 20,
            icon: const Icon(Icons.search_rounded, size: 20),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Search is coming soon.')),
            ),
          ),
          IconButton(
            splashRadius: 20,
            icon: const Icon(Icons.notifications_none_rounded, size: 20),
            onPressed: onNotificationsTap,
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF154A8B),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFB8C2CE)),
            ),
            child: const Icon(Icons.person, size: 48, color: Colors.black54),
          ),
          const SizedBox(height: 6),
          const Text(
            'Hassan Al-Fayed',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          Text(
            'Servant of The Merciful',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontStyle: FontStyle.italic,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 10),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Waqf Value',
                    value: 'ETB 25M+',
                    subLabel: '',
                  ),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: _StatCard(
                    title: 'Projects Active',
                    value: '8',
                    subLabel: '—',
                  ),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: _StatCard(
                    title: 'Expected Reach',
                    value: '30,000+',
                    subLabel: 'Beneficiaries',
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

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.subLabel,
  });

  final String title;
  final String value;
  final String subLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(3),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10.5,
              color: Color(0xFF6B7280),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              height: 1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 3),
          Text(
            subLabel,
            style: const TextStyle(fontSize: 9, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, this.trailingLabel});

  final String label;
  final String? trailingLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF727985),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (trailingLabel != null)
          Text(
            trailingLabel!,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xFF9AA1AC),
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}

class _ActiveShareCard extends StatelessWidget {
  const _ActiveShareCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: const Color(0xFFD8DEE7)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 88,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF053F71), Color(0xFF1E6A9D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF39A267),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Over Last',
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        ),
                      ),
                    ),
                    const Center(
                      child: Icon(Icons.mosque_rounded, color: Colors.white70, size: 46),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Anwar Masjid',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Row(
                children: const [
                  Expanded(
                    child: Text(
                      'ETB 4.5M',
                      style: TextStyle(fontSize: 12, color: Color(0xFF334155)),
                    ),
                  ),
                  Icon(Icons.trending_up_rounded, size: 14, color: Color(0xFF16A34A)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListGroup extends StatelessWidget {
  const _ListGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: const Color(0xFFDDE2EA)),
      ),
      child: Column(children: children),
    );
  }
}

class _ListActionTile extends StatelessWidget {
  const _ListActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          visualDensity: const VisualDensity(vertical: -2),
          leading: Icon(icon, size: 15, color: const Color(0xFF7A828F)),
          title: Text(
            title,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(Icons.chevron_right_rounded, size: 18),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}

class _PreferencesCard extends StatelessWidget {
  const _PreferencesCard({
    required this.privateMode,
    required this.biometricLock,
    required this.languageLabel,
    required this.onPrivateModeChanged,
    required this.onBiometricChanged,
    required this.onLanguageTap,
  });

  final bool privateMode;
  final bool biometricLock;
  final String languageLabel;
  final ValueChanged<bool> onPrivateModeChanged;
  final ValueChanged<bool> onBiometricChanged;
  final VoidCallback onLanguageTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: const Color(0xFFDDE2EA)),
      ),
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Column(
        children: [
          _SwitchRow(
            label: 'Private Mode',
            value: privateMode,
            onChanged: onPrivateModeChanged,
          ),
          const Divider(height: 14),
          _SwitchRow(
            label: 'Biometric Lock',
            value: biometricLock,
            onChanged: onBiometricChanged,
          ),
          const Divider(height: 14),
          InkWell(
            onTap: onLanguageTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Text(
                    'Language',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: const Color(0xFFEAECF1),
                    child: Row(
                      children: [
                        Text(
                          languageLabel,
                          style: const TextStyle(fontSize: 10.5),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down_rounded, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        Switch.adaptive(
          value: value,
          activeTrackColor: AppColors.primary.withValues(alpha: 0.45),
          activeThumbColor: AppColors.primary,
          onChanged: onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF154A8B),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        children: [
          Text(
            '"When a human being dies, his work comes to an end,\nexcept for three things: Sadaqah,\nJariyah (perennial charity), knowledge\nfrom which others benefit, and a\nrighteous child who prays for him."',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'PROPHETIC TRADITION (H.R)\nTHE ESSENCE OF WAQF',
            textAlign: TextAlign.center,
            style: textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    );
  }
}
