import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../app/widgets/zakat_page_header.dart';
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

  static const _quickAmounts = [500, 1000, 2500, 5000];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final currentAmount = _amountEtb?.round();
    const gap = SizedBox(height: 16);
    const fieldGap = SizedBox(height: 10);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ZakatPageHeader(
              title: l10n.donationInternationalTitle,
              subtitle: l10n.donationInternationalSubtitle,
              leadingIcon: TablerIcons.world_heart,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PremiumCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ZakatFormSectionTitle(
                          icon: TablerIcons.coin,
                          label: l10n.donationAmountLabel,
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _amount,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                          ],
                          onChanged: (_) => setState(() {}),
                          style: AppTypography.body(
                            fontSize: 24,
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w800,
                          ),
                          decoration: InputDecoration(
                            hintText: l10n.donationAmountHint,
                            prefixIcon: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 16,
                                end: 10,
                              ),
                              child: Text(
                                'ETB',
                                style: AppTypography.body(
                                  fontSize: 16,
                                  color: AppColors.goldDeep,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            prefixIconConstraints: const BoxConstraints(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final amount in _quickAmounts)
                              ChoiceChip(
                                label: Text('ETB $amount'),
                                selected: currentAmount == amount,
                                onSelected: (_) => setState(
                                  () => _amount.text = amount.toString(),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.info_outline, size: 14, color: scheme.onSurfaceVariant),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                l10n.donationAmountHelper,
                                style: AppTypography.body(
                                  fontSize: 12,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  gap,
                  PremiumCard(
                    padding: const EdgeInsets.fromLTRB(18, 8, 12, 8),
                    child: SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      secondary: const Icon(Icons.visibility_off_outlined),
                      title: Text(
                        l10n.donationAnonymousLabel,
                        style: AppTypography.body(
                          fontSize: 14,
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        l10n.donationAnonymousSubtitle,
                        style: AppTypography.body(
                          fontSize: 12,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      value: _anonymous,
                      onChanged: (value) => setState(() => _anonymous = value),
                    ),
                  ),
                  gap,
                  PremiumCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ZakatFormSectionTitle(
                          icon: TablerIcons.user,
                          label: l10n.donationDonorSectionTitle,
                        ),
                        const SizedBox(height: 14),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 200),
                          child: _anonymous
                              ? const SizedBox(width: double.infinity)
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: TextField(
                                    controller: _fullName,
                                    textCapitalization: TextCapitalization.words,
                                    onChanged: (_) => setState(() {}),
                                    decoration: InputDecoration(
                                      labelText: l10n.donationFullNameLabel,
                                      prefixIcon: const Icon(Icons.badge_outlined),
                                    ),
                                  ),
                                ),
                        ),
                        TextField(
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            labelText: l10n.donationPhoneLabel,
                            hintText: '+1 555 123 4567',
                            prefixIcon: const Icon(Icons.phone_outlined),
                          ),
                        ),
                        fieldGap,
                        TextField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            labelText: l10n.donationEmailLabel,
                            prefixIcon: const Icon(Icons.alternate_email_rounded),
                          ),
                        ),
                      ],
                    ),
                  ),
                  gap,
                  PremiumCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ZakatFormSectionTitle(
                          icon: TablerIcons.map_pin,
                          label: l10n.donationBillingSectionTitle,
                        ),
                        const SizedBox(height: 14),
                        DonationSearchPickerField(
                          label: l10n.donationCountryLabel,
                          hintText: l10n.donationSelectCountry,
                          displayText: _selectedCountryLabel == null
                              ? null
                              : '${_selectedCountryLabel!} (${_selectedCountryCode!})',
                          onTap: _pickCountry,
                        ),
                        fieldGap,
                        TextField(
                          controller: _address1,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(labelText: l10n.donationAddress1Label),
                        ),
                        fieldGap,
                        TextField(
                          controller: _address2,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(labelText: l10n.donationAddress2Label),
                        ),
                        fieldGap,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _locality,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  labelText: l10n.donationLocalityLabel,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _postalCode,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  labelText: l10n.donationPostalCodeLabel,
                                ),
                              ),
                            ),
                          ],
                        ),
                        fieldGap,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: GoldActionButton(
            label: l10n.donationContinueToPayment,
            icon: Icons.lock_outline_rounded,
            busy: _submitting,
            busyLabel: l10n.donationSubmitting,
            onPressed: _canSubmit ? _onSubmit : null,
          ),
        ),
      ),
    );
  }
}
