import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/app_logo.dart';
import '../../bloc/beneficiary_registration_bloc.dart';
import '../../bloc/beneficiary_registration_event.dart';
import '../../bloc/beneficiary_registration_state.dart';
import '../pages/fayda_verification_webview_page.dart';
import '../widgets/asnaf_category_tile.dart';
import '../widgets/payout_method_tile.dart';
import '../widgets/section_card.dart';
import '../widgets/step_progress_header.dart';

void _openFaydaVerificationWebView(BuildContext context, String link) {
  final uri = Uri.tryParse(link.trim());
  if (uri == null) {
    return;
  }
  final bloc = context.read<BeneficiaryRegistrationBloc>();
  Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: FaydaVerificationWebViewPage(url: uri),
      ),
    ),
  );
}

class BeneficiaryRegistrationScreen extends StatelessWidget {
  const BeneficiaryRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BeneficiaryRegistrationBloc, BeneficiaryRegistrationState>(
          listenWhen: (previous, current) =>
              current.errorMessage != null &&
              current.errorMessage!.isNotEmpty &&
              current.errorMessage != previous.errorMessage,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          },
        ),
        BlocListener<BeneficiaryRegistrationBloc, BeneficiaryRegistrationState>(
          listenWhen: (previous, current) {
            if (current.method != RegistrationMethod.fastTrack) {
              return false;
            }
            final link = current.verificationLink?.trim();
            if (link == null || link.isEmpty) {
              return false;
            }
            if (!current.awaitingFaydaSse) {
              return false;
            }
            return !previous.awaitingFaydaSse ||
                previous.verificationLink != current.verificationLink;
          },
          listener: (context, state) {
            _openFaydaVerificationWebView(context, state.verificationLink!);
          },
        ),
        BlocListener<BeneficiaryRegistrationBloc, BeneficiaryRegistrationState>(
          listenWhen: (previous, current) =>
              current.submissionSuccess && !previous.submissionSuccess,
          listener: (context, state) {
            final id = state.createdBeneficiaryId;
            final status = state.registeredBeneficiary?.verificationStatus;
            final buffer = StringBuffer();
            if (id != null && id.isNotEmpty) {
              buffer.write('Application submitted. Reference: $id');
            } else {
              buffer.write('Application submitted successfully.');
            }
            if (status != null && status.trim().isNotEmpty) {
              buffer.write(' Status: ${status.trim()}.');
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(buffer.toString())),
            );
          },
        ),
      ],
      child: BlocBuilder<BeneficiaryRegistrationBloc, BeneficiaryRegistrationState>(
        builder: (context, state) {
          final theme = Theme.of(context);
          return Theme(
            data: theme.copyWith(
              inputDecorationTheme: theme.inputDecorationTheme.copyWith(
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary, width: 1.4),
                ),
                labelStyle: const TextStyle(color: AppColors.primary),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    if (state.step == BeneficiaryRegistrationStep.welcome) {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/');
                      }
                      return;
                    }
                    context.read<BeneficiaryRegistrationBloc>().add(
                      const RegistrationStepWentBack(),
                    );
                  },
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Beneficiary Registration',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const AppLogo(height: 28),
                  ],
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StepProgressHeader(
                        step: state.step,
                        method: state.method,
                      ),
                      if (state.method == RegistrationMethod.fastTrack &&
                          state.step == BeneficiaryRegistrationStep.welcome &&
                          (state.isFaydaPosting || state.awaitingFaydaSse)) ...[
                        const SizedBox(height: 16),
                        const _FaydaVerificationBanner(),
                      ],
                      const SizedBox(height: 16),
                      _StepContent(state: state),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: _FooterActions(state: state),
            ),
          );
        },
      ),
    );
  }
}

class _StepContent extends StatelessWidget {
  const _StepContent({required this.state});

  final BeneficiaryRegistrationState state;

  @override
  Widget build(BuildContext context) {
    switch (state.step) {
      case BeneficiaryRegistrationStep.welcome:
        return _WelcomeStep(state: state);
      case BeneficiaryRegistrationStep.identity:
        if (state.method == RegistrationMethod.manual) {
          return _IdentityStep(state: state);
        }
        return const SizedBox.shrink();
      case BeneficiaryRegistrationStep.needs:
        return _NeedsStep(state: state);
      case BeneficiaryRegistrationStep.disbursement:
        return _DisbursementStep(state: state);
    }
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({required this.state});
  final BeneficiaryRegistrationState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BeneficiaryRegistrationBloc>();
    return Column(
      children: [
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Secure Identity Verification', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Choose your preferred registration method to begin your journey.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              PayoutMethodTile(
                title: 'Fast-Track with National ID (Fayda)',
                subtitle: 'Authenticate using your national digital ID.',
                icon: Icons.qr_code_scanner_rounded,
                selected: state.method == RegistrationMethod.fastTrack,
                onTap: () => bloc.add(
                  const RegistrationMethodSelected(RegistrationMethod.fastTrack),
                ),
              ),
              const SizedBox(height: 12),
              PayoutMethodTile(
                title: 'Manual Registration',
                subtitle: 'Upload supporting documentation for review.',
                icon: Icons.edit_document,
                selected: state.method == RegistrationMethod.manual,
                onTap: () => bloc.add(
                  const RegistrationMethodSelected(RegistrationMethod.manual),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const SectionCard(
          child: Column(
            children: [
              Icon(Icons.lock_outline, size: 28),
              SizedBox(height: 8),
              Text('Encrypted & Private', style: TextStyle(fontWeight: FontWeight.w700)),
              SizedBox(height: 4),
              Text(
                'Your data is secured and handled in line with privacy standards.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        if (state.method == RegistrationMethod.fastTrack &&
            !state.faydaVerificationComplete &&
            state.createdBeneficiaryId != null &&
            state.createdBeneficiaryId!.trim().isNotEmpty &&
            state.errorMessage != null &&
            state.errorMessage!.trim().isNotEmpty) ...[
          const SizedBox(height: 12),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Verification interrupted',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  state.errorMessage!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: state.verificationLink?.trim().isNotEmpty == true
                      ? () => _openFaydaVerificationWebView(
                            context,
                            state.verificationLink!,
                          )
                      : null,
                  icon: const Icon(Icons.open_in_browser_outlined),
                  label: const Text('Reopen verification'),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () =>
                      bloc.add(const FaydaSseRetryRequested()),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry listening'),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _IdentityStep extends StatelessWidget {
  const _IdentityStep({required this.state});
  final BeneficiaryRegistrationState state;

  Future<void> _pickProfileImage(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Take Photo'),
                onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.of(sheetContext).pop(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source == null || !context.mounted) {
      return;
    }

    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1400,
      );
      if (image == null || !context.mounted) {
        return;
      }

      context.read<BeneficiaryRegistrationBloc>().add(
        ProfilePicturePicked(image.path),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open camera/gallery. Please check permissions.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BeneficiaryRegistrationBloc>();
    final birthdateText = state.birthdate == null
          ? 'Select birthdate'
          : MaterialLocalizations.of(context).formatMediumDate(state.birthdate!);
    return Column(
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manual Identity Registration',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (v) => bloc.add(FirstNameUpdated(v)),
                        decoration: const InputDecoration(labelText: 'First Name'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => bloc.add(FatherNameUpdated(v)),
                        decoration: const InputDecoration(labelText: 'Last Name'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (v) => bloc.add(GrandFatherNameUpdated(v)),
                        decoration: const InputDecoration(labelText: "Grandfather's Name"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        onChanged: (v) => bloc.add(PhoneNumberUpdated(v)),
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          hintText: '+251911223344 or 0911223344',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (v) => bloc.add(EmailUpdated(v)),
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<Gender>(
                        initialValue: state.gender,
                        items: const [
                          DropdownMenuItem(value: Gender.male, child: Text('Male')),
                          DropdownMenuItem(value: Gender.female, child: Text('Female')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            bloc.add(GenderUpdated(value));
                          }
                        },
                        decoration: const InputDecoration(labelText: 'Gender'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () async {
                    final now = DateTime.now();
                    final selected = await showDatePicker(
                      context: context,
                      initialDate: state.birthdate ?? DateTime(now.year - 20),
                      firstDate: DateTime(1900),
                      lastDate: now,
                    );
                    if (!context.mounted || selected == null) {
                      return;
                    }
                    bloc.add(BirthdateUpdated(selected));
                  },
                  icon: const Icon(Icons.calendar_today_outlined),
                  label: Text(birthdateText),
                ),
                const SizedBox(height: 10),
                TextField(
                  maxLines: 3,
                  onChanged: (v) => bloc.add(AddressUpdated(v)),
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (v) => bloc.add(RegionUpdated(v)),
                  decoration: const InputDecoration(labelText: 'Region'),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (v) => bloc.add(CityUpdated(v)),
                  decoration: const InputDecoration(labelText: 'City'),
                ),
                const SizedBox(height: 10),
                TextField(
                  maxLines: 2,
                  onChanged: (v) => bloc.add(NotesUpdated(v)),
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    hintText: 'e.g. Zakat support applicant',
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _pickProfileImage(context),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: const Text('Upload Profile Picture'),
                ),
                if (state.profilePicture != null) ...[
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundImage: FileImage(File(state.profilePicture!)),
                    ),
                    title: Text(state.profilePicture!),
                    trailing: IconButton(
                      onPressed: () => bloc.add(const ProfilePictureRemoved()),
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      );
  }
}

class _FaydaVerificationBanner extends StatelessWidget {
  const _FaydaVerificationBanner();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Verifying with Fayda… Complete verification in the browser when it opens.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _NeedsStep extends StatelessWidget {
  const _NeedsStep({required this.state});
  final BeneficiaryRegistrationState state;

  static const Map<AsnafCategory, String> _labels = {
    AsnafCategory.fakir: 'Fakir',
    AsnafCategory.miskin: 'Miskin',
    AsnafCategory.amil: 'Amil',
    AsnafCategory.muallaf: 'Muallaf',
    AsnafCategory.riqab: 'Riqab',
    AsnafCategory.gharimin: 'Gharimin',
    AsnafCategory.fisabilillah: 'Fisabilillah',
    AsnafCategory.ibnSabil: 'Ibnus Sabil',
  };

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BeneficiaryRegistrationBloc>();
    return Column(
      children: [
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Category Assessment', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.5,
                children: _labels.entries.map((entry) {
                  return AsnafCategoryTile(
                    label: entry.value,
                    selected: state.selectedCategories.contains(entry.key),
                    onTap: () => bloc.add(AsnafCategoryToggled(entry.key)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                maxLines: 4,
                onChanged: (v) => bloc.add(SituationDescriptionUpdated(v)),
                decoration: const InputDecoration(
                  labelText: 'Describe your current situation',
                  hintText: 'Explain hardship, dependents, and urgent needs...',
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => bloc.add(const SupportingProofPicked('hospital_bill_june.pdf')),
                icon: const Icon(Icons.upload_file_outlined),
                label: const Text('Upload Proof'),
              ),
              if (state.uploadedProofName != null) ...[
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.description_outlined),
                  title: Text(state.uploadedProofName!),
                  trailing: IconButton(
                    onPressed: () => bloc.add(const SupportingProofRemoved()),
                    icon: const Icon(Icons.close),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DisbursementStep extends StatelessWidget {
  const _DisbursementStep({required this.state});
  final BeneficiaryRegistrationState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BeneficiaryRegistrationBloc>();
    return Column(
      children: [
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Disbursement Setup', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              PayoutMethodTile(
                title: 'Telebirr Wallet',
                subtitle: 'Instant mobile money transfer',
                icon: Icons.account_balance_wallet_outlined,
                selected: state.payoutMethod == PayoutMethod.telebirrWallet,
                onTap: () =>
                    bloc.add(const PayoutMethodSelected(PayoutMethod.telebirrWallet)),
              ),
              const SizedBox(height: 10),
              PayoutMethodTile(
                title: 'M-Pesa',
                subtitle: 'Secure mobile payment network',
                icon: Icons.phone_iphone_outlined,
                selected: state.payoutMethod == PayoutMethod.mPesa,
                onTap: () => bloc.add(const PayoutMethodSelected(PayoutMethod.mPesa)),
              ),
              const SizedBox(height: 10),
              PayoutMethodTile(
                title: 'Coopbank Account',
                subtitle: 'Direct bank deposit',
                icon: Icons.account_balance_outlined,
                selected: state.payoutMethod == PayoutMethod.coopbank,
                onTap: () => bloc.add(const PayoutMethodSelected(PayoutMethod.coopbank)),
              ),
              const SizedBox(height: 14),
              TextField(
                onChanged: (v) => bloc.add(AccountOrMobileUpdated(v)),
                decoration: const InputDecoration(labelText: 'Account or Mobile Number'),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (v) => bloc.add(LegalNameUpdated(v)),
                decoration: const InputDecoration(labelText: 'Full Legal Name'),
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                value: state.hasAcceptedCompliance,
                contentPadding: EdgeInsets.zero,
                onChanged: (v) => bloc.add(ComplianceToggled(v ?? false)),
                title: const Text('Agreement & Sharia Compliance'),
                subtitle: const Text(
                  'I declare information is truthful and will use aid according to policy.',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FooterActions extends StatelessWidget {
  const _FooterActions({required this.state});
  final BeneficiaryRegistrationState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BeneficiaryRegistrationBloc>();
    final isManualIdentitySubmit = state.method == RegistrationMethod.manual &&
        state.step == BeneficiaryRegistrationStep.identity;
    final isFinalStep = state.step == BeneficiaryRegistrationStep.disbursement;

    final canContinue = switch (state.step) {
      BeneficiaryRegistrationStep.welcome =>
        state.method != RegistrationMethod.fastTrack ||
            (!state.isFaydaPosting && !state.awaitingFaydaSse),
      BeneficiaryRegistrationStep.identity => state.isIdentityStepComplete,
      BeneficiaryRegistrationStep.needs =>
        state.selectedCategories.isNotEmpty &&
            state.situationDescription.trim().isNotEmpty,
      BeneficiaryRegistrationStep.disbursement =>
        state.hasAcceptedCompliance &&
            state.accountOrMobileNumber.trim().isNotEmpty &&
            state.legalName.trim().isNotEmpty,
    };

    final continueLabel = switch (state.step) {
      BeneficiaryRegistrationStep.welcome when state.method == RegistrationMethod.fastTrack =>
        state.isFaydaPosting || state.awaitingFaydaSse
            ? 'Verifying with Fayda…'
            : state.faydaVerificationComplete
                ? 'Continue'
                : 'Continue with Fayda',
      BeneficiaryRegistrationStep.identity when isManualIdentitySubmit => 'Submit & Continue',
      BeneficiaryRegistrationStep.disbursement => 'Finish',
      _ => 'Continue',
    };

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  if (state.step == BeneficiaryRegistrationStep.welcome) {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/');
                    }
                    return;
                  }
                  bloc.add(const RegistrationStepWentBack());
                },
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                ),
                onPressed: !canContinue ||
                        state.isFaydaPosting ||
                        state.awaitingFaydaSse
                    ? null
                    : () {
                        if (isFinalStep) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Registration complete. Needs and disbursement details are saved locally.',
                              ),
                            ),
                          );
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/');
                          }
                          return;
                        }
                        if (isManualIdentitySubmit) {
                          bloc.add(const BeneficiarySubmissionRequested());
                        } else {
                          bloc.add(const RegistrationStepAdvanced());
                        }
                      },
                child: isManualIdentitySubmit && state.isSubmitting
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.textOnPrimary,
                        ),
                      )
                    : state.isFaydaPosting
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.textOnPrimary,
                            ),
                          )
                        : Text(continueLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
