import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/app_logo.dart';
import '../../../../core/common/utils/phone_e164.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/l10n.dart';
import '../../data/donation_countries.dart';
import '../../data/donation_exception.dart';
import '../../data/donation_subdivisions.dart';
import '../../data/models/donation_create_request.dart';
import '../../data/repository/donation_repository.dart';
import '../pages/donation_payment_webview_page.dart';
import '../widgets/donation_search_picker.dart';
import '../widgets/donation_section_card.dart';

class InternationalDonationScreen extends StatefulWidget {
  const InternationalDonationScreen({super.key});

  @override
  State<InternationalDonationScreen> createState() =>
      _InternationalDonationScreenState();
}

class _InternationalDonationScreenState extends State<InternationalDonationScreen> {
  final _amount = TextEditingController();
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _address1 = TextEditingController();
  final _address2 = TextEditingController();
  final _adminArea = TextEditingController();
  final _locality = TextEditingController();
  final _postalCode = TextEditingController();

  bool _anonymous = false;
  bool _submitting = false;
  String? _selectedCountryCode;
  String? _selectedSubdivisionCode;

  @override
  void dispose() {
    _amount.dispose();
    _fullName.dispose();
    _phone.dispose();
    _email.dispose();
    _address1.dispose();
    _address2.dispose();
    _adminArea.dispose();
    _locality.dispose();
    _postalCode.dispose();
    super.dispose();
  }

  bool get _usesSearchableSubdivisions =>
      _selectedCountryCode != null &&
      countryUsesSearchableSubdivisions(_selectedCountryCode!);

  String? get _selectedCountryLabel {
    if (_selectedCountryCode == null) return null;
    return donationCountryByCode(_selectedCountryCode!)?.label;
  }

  String? get _selectedSubdivisionLabel {
    if (_selectedCountryCode == null || _selectedSubdivisionCode == null) {
      return null;
    }
    return subdivisionOptionByCode(
      _selectedCountryCode!,
      _selectedSubdivisionCode!,
    )?.label;
  }

  String get _resolvedAdminArea {
    if (_usesSearchableSubdivisions) {
      return _selectedSubdivisionCode?.trim() ?? '';
    }
    return _adminArea.text.trim();
  }

  double? get _amountEtb {
    final raw = _amount.text.replaceAll(',', '').trim();
    if (raw.isEmpty) return null;
    return double.tryParse(raw);
  }

  String get _resolvedCountry => _selectedCountryCode?.trim() ?? '';

  bool get _canSubmit {
    if (_submitting) return false;
    final amount = _amountEtb;
    if (amount == null || amount <= 0) return false;
    if (_phone.text.trim().isEmpty || _email.text.trim().isEmpty) return false;
    if (!_anonymous && _fullName.text.trim().isEmpty) return false;
    if (_selectedCountryCode == null || _selectedCountryCode!.trim().isEmpty) {
      return false;
    }
    if (_address1.text.trim().isEmpty ||
        _resolvedAdminArea.isEmpty ||
        _locality.text.trim().isEmpty ||
        _postalCode.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> _pickCountry() async {
    final l10n = context.l10n;
    final selected = await showDonationSearchPicker(
      context: context,
      title: l10n.donationCountryLabel,
      searchHint: l10n.donationSearchCountry,
      options: donationCountryOptions,
      itemSubtitle: (option) => option.value,
    );
    if (!mounted || selected == null) return;
    setState(() {
      _selectedCountryCode = selected.value;
      _selectedSubdivisionCode = null;
      _adminArea.clear();
    });
  }

  Future<void> _pickSubdivision() async {
    final countryCode = _selectedCountryCode;
    if (countryCode == null || !countryUsesSearchableSubdivisions(countryCode)) {
      return;
    }
    final l10n = context.l10n;
    final selected = await showDonationSearchPicker(
      context: context,
      title: l10n.donationAdminAreaLabel,
      searchHint: l10n.donationSearchState,
      options: subdivisionOptionsForCountry(countryCode),
      itemSubtitle: (option) => option.value,
    );
    if (!mounted || selected == null) return;
    setState(() => _selectedSubdivisionCode = selected.value);
  }

  String? _validatePhone() {
    final raw = _phone.text.trim();
    if (raw.isEmpty) return null;
    if (PhoneE164.isValid(raw)) return null;
    final normalized = PhoneE164.normalize(raw, countryCode: '1');
    if (normalized != null) return null;
    return context.l10n.donationValidationPhone;
  }

  Future<void> _onSubmit() async {
    final l10n = context.l10n;
    if (!_canSubmit) return;

    final phoneError = _validatePhone();
    if (phoneError != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(phoneError)));
      return;
    }

    final phone = PhoneE164.isValid(_phone.text.trim())
        ? _phone.text.trim()
        : PhoneE164.normalize(_phone.text.trim(), countryCode: '1') ??
            _phone.text.trim();

    setState(() => _submitting = true);

    try {
      final request = DonationCreateRequest(
        donorMode: _anonymous ? DonorMode.anonymous.apiValue : DonorMode.identified.apiValue,
        paymentPurpose: 'SADAQAH',
        amountEtb: _amountEtb!,
        address: DonationAddress(
          address1: _address1.text,
          address2: _address2.text,
          country: _resolvedCountry,
          administrativeArea: _resolvedAdminArea,
          locality: _locality.text,
          postalCode: _postalCode.text,
        ),
        donor: DonationDonor(
          fullName: _anonymous ? 'Anonymous' : _fullName.text,
          phone: phone,
          email: _email.text,
        ),
      );

      final result = await getIt<DonationRepository>().createDonation(request);
      if (!mounted) return;

      final paymentUrl = result.paymentUrl?.trim();
      if (paymentUrl != null && paymentUrl.isNotEmpty) {
        final uri = Uri.tryParse(paymentUrl);
        if (uri != null) {
          await Navigator.of(context).push<void>(
            MaterialPageRoute<void>(
              builder: (_) => DonationPaymentWebViewPage(
                url: uri,
                title: l10n.donationPaymentWebViewTitle,
              ),
            ),
          );
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.donationSuccess)),
      );
      context.go('/');
    } on DonationException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        backgroundColor: AppColors.awqafPrimary,
        foregroundColor: AppColors.textOnPrimary,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLogo(height: 24),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                l10n.donationInternationalTitle,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -40,
            child: _GlowOrb(
              size: 200,
              color: AppColors.warmGold.withValues(alpha: 0.22),
            ),
          ),
          Positioned(
            bottom: 120,
            left: -60,
            child: _GlowOrb(
              size: 160,
              color: AppColors.awqafPrimary.withValues(alpha: 0.12),
            ),
          ),
          Column(
            children: [
              _InternationalHero(subtitle: l10n.donationInternationalSubtitle),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  children: [
                    DonationSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.donationAmountLabel,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.awqafPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _amount,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[\d.,]'),
                              ),
                            ],
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: l10n.donationAmountHint,
                              prefixText: 'ETB ',
                              filled: true,
                              fillColor: theme.colorScheme.surface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.donationAmountHelper,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.mutedText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    DonationSectionCard(
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          l10n.donationAnonymousLabel,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(l10n.donationAnonymousSubtitle),
                        value: _anonymous,
                        onChanged: (value) => setState(() => _anonymous = value),
                      ),
                    ),
                    const SizedBox(height: 14),
                    DonationSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle(
                            icon: TablerIcons.user,
                            label: l10n.donationDonorSectionTitle,
                          ),
                          const SizedBox(height: 12),
                          if (!_anonymous)
                            TextField(
                              controller: _fullName,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                labelText: l10n.donationFullNameLabel,
                              ),
                            ),
                          if (!_anonymous) const SizedBox(height: 10),
                          TextField(
                            controller: _phone,
                            keyboardType: TextInputType.phone,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              labelText: l10n.donationPhoneLabel,
                              hintText: '+1 555 123 4567',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              labelText: l10n.donationEmailLabel,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    DonationSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle(
                            icon: TablerIcons.map_pin,
                            label: l10n.donationBillingSectionTitle,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _address1,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              labelText: l10n.donationAddress1Label,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _address2,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              labelText: l10n.donationAddress2Label,
                            ),
                          ),
                          const SizedBox(height: 10),
                          DonationSearchPickerField(
                            label: l10n.donationCountryLabel,
                            hintText: l10n.donationSelectCountry,
                            displayText: _selectedCountryLabel == null
                                ? null
                                : '${_selectedCountryLabel!} (${_selectedCountryCode!})',
                            onTap: _pickCountry,
                          ),
                          const SizedBox(height: 10),
                          if (_usesSearchableSubdivisions)
                            DonationSearchPickerField(
                              label: l10n.donationAdminAreaLabel,
                              hintText: l10n.donationSelectState,
                              displayText: _selectedSubdivisionLabel == null
                                  ? null
                                  : '${_selectedSubdivisionLabel!} (${_selectedSubdivisionCode!})',
                              onTap: _pickSubdivision,
                            )
                          else
                            TextField(
                              controller: _adminArea,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                labelText: l10n.donationAdminAreaLabel,
                              ),
                            ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _locality,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              labelText: l10n.donationLocalityLabel,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _postalCode,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              labelText: l10n.donationPostalCodeLabel,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton(
            onPressed: _canSubmit ? _onSubmit : null,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.awqafPrimary,
              foregroundColor: AppColors.textOnPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: _submitting
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(l10n.donationSubmitting),
                    ],
                  )
                : Text(
                    l10n.donationContinueToPayment,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
          ),
        ),
      ),
    );
  }
}

class _InternationalHero extends StatelessWidget {
  const _InternationalHero({required this.subtitle});

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.awqafPrimary,
            Color(0xFF1A3A6B),
            AppColors.warmGold,
          ],
          stops: [0.0, 0.6, 1.0],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.awqafPrimary.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.textOnPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              TablerIcons.world_heart,
              color: AppColors.textOnPrimary,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              subtitle,
              style: AppTypography.body(
                fontSize: 14,
                color: AppColors.textOnPrimary.withValues(alpha: 0.95),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.awqafPrimary),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.awqafPrimary,
              ),
        ),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
