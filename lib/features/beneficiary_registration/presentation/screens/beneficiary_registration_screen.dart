import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/app_logo.dart';
import '../../../../core/l10n/l10n.dart';
import '../../bloc/beneficiary_registration_bloc.dart';
import '../../bloc/beneficiary_registration_event.dart';
import '../../bloc/beneficiary_registration_state.dart';
import '../../data/models/asnaf_category.dart';
import '../../data/models/institution_subtype.dart';
import '../pages/fayda_verification_webview_page.dart';
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
              current.errorMessage != previous.errorMessage &&
              !current.passwordSetupComplete,
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
              current.passwordSetupComplete &&
              !previous.passwordSetupComplete &&
              current.method != RegistrationMethod.institution,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.regPasswordSuccess)),
            );
            context.go('/');
          },
        ),
        BlocListener<BeneficiaryRegistrationBloc, BeneficiaryRegistrationState>(
          listenWhen: (previous, current) =>
              current.submissionSuccess &&
              !previous.submissionSuccess &&
              current.method == RegistrationMethod.institution,
          listener: (context, state) {
            final l10n = context.l10n;
            final id = state.createdBeneficiaryId;
            final message = id != null && id.isNotEmpty
                ? l10n.regInstitutionComplete(id)
                : l10n.regInstitutionCompleteGeneric;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
            context.go('/');
          },
        ),
        BlocListener<BeneficiaryRegistrationBloc, BeneficiaryRegistrationState>(
          listenWhen: (previous, current) =>
              current.submissionSuccess &&
              !previous.submissionSuccess &&
              current.method == RegistrationMethod.fastTrack &&
              current.step == BeneficiaryRegistrationStep.disbursement,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.regCompleteLocal)),
            );
            context.go('/');
          },
        ),
      ],
      child: BlocBuilder<BeneficiaryRegistrationBloc, BeneficiaryRegistrationState>(
        builder: (context, state) {
          final l10n = context.l10n;
          final theme = Theme.of(context);
          return Theme(
            data: theme.copyWith(
              inputDecorationTheme: theme.inputDecorationTheme.copyWith(
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerLowest.withValues(
                  alpha: 0.9,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.8),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.8),
                  ),
                ),
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                ),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            child: Scaffold(
              backgroundColor: theme.colorScheme.surface,
              appBar: AppBar(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                elevation: 0,
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
                        l10n.regTitle,
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
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.11),
                        Theme.of(context).colorScheme.surface,
                      ],
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _RegistrationHeroBanner(state: state),
                        const SizedBox(height: 12),
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
              ),
              bottomNavigationBar: _FooterActions(state: state),
            ),
          );
        },
      ),
    );
  }
}

class _RegistrationHeroBanner extends StatelessWidget {
  const _RegistrationHeroBanner({required this.state});

  final BeneficiaryRegistrationState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final methodTitle = switch (state.method) {
      RegistrationMethod.fastTrack => l10n.regMethodFastTrack,
      RegistrationMethod.manual => l10n.regMethodManual,
      RegistrationMethod.institution => l10n.regMethodInstitution,
    };
    final methodDescription = switch (state.method) {
      RegistrationMethod.fastTrack => l10n.regMethodFastTrackDesc,
      RegistrationMethod.manual => l10n.regMethodManualDesc,
      RegistrationMethod.institution => l10n.regMethodInstitutionDesc,
    };

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.86),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.24),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.textOnPrimary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.volunteer_activism_outlined,
              color: AppColors.textOnPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  methodTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  methodDescription,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textOnPrimary.withValues(alpha: 0.95),
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
      case BeneficiaryRegistrationStep.institutionDetails:
        return _InstitutionDetailsStep(state: state);
      case BeneficiaryRegistrationStep.setPassword:
        return _SetPasswordStep(state: state);
      case BeneficiaryRegistrationStep.institutionDocuments:
        return _InstitutionDocumentsStep(state: state);
    }
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({required this.state});
  final BeneficiaryRegistrationState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<BeneficiaryRegistrationBloc>();
    return Column(
      children: [
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.regSecureIdentityTitle, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                l10n.regChooseMethodSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              PayoutMethodTile(
                title: l10n.regFastTrackFaydaTitle,
                subtitle: l10n.regFastTrackFaydaSubtitle,
                icon: Icons.qr_code_scanner_rounded,
                selected: state.method == RegistrationMethod.fastTrack,
                onTap: () => bloc.add(
                  const RegistrationMethodSelected(RegistrationMethod.fastTrack),
                ),
              ),
              const SizedBox(height: 12),
              PayoutMethodTile(
                title: l10n.regManualTitle,
                subtitle: l10n.regManualSubtitle,
                icon: Icons.edit_document,
                selected: state.method == RegistrationMethod.manual,
                onTap: () => bloc.add(
                  const RegistrationMethodSelected(RegistrationMethod.manual),
                ),
              ),
              const SizedBox(height: 12),
              PayoutMethodTile(
                title: l10n.regInstitutionCardTitle,
                subtitle: l10n.regInstitutionCardSubtitle,
                icon: Icons.business_outlined,
                selected: state.method == RegistrationMethod.institution,
                onTap: () => bloc.add(
                  const RegistrationMethodSelected(RegistrationMethod.institution),
                ),
              ),
            ],
          ),
        ),
        if (state.method == RegistrationMethod.fastTrack) ...[
          const SizedBox(height: 12),
          SectionCard(
            child: TextField(
              onChanged: (v) => bloc.add(RegistrationCodeUpdated(v)),
              decoration: InputDecoration(
                labelText: l10n.regRegistrationCodeLabel,
                hintText: l10n.regRegistrationCodeHint,
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        SectionCard(
          child: Column(
            children: [
              const Icon(Icons.lock_outline, size: 28),
              const SizedBox(height: 8),
              Text(
                l10n.regEncryptedPrivate,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.regEncryptedPrivateBody,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
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
                  l10n.regVerificationInterrupted,
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
                  label: Text(l10n.regReopenVerification),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () =>
                      bloc.add(const FaydaSseRetryRequested()),
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.regRetryListening),
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
    final l10n = context.l10n;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(l10n.commonTakePhoto),
                onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(l10n.commonChooseGallery),
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
        SnackBar(
          content: Text(context.l10n.regCameraPermissionError),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<BeneficiaryRegistrationBloc>();
    final birthdateText = state.birthdate == null
          ? l10n.regSelectBirthdate
          : MaterialLocalizations.of(context).formatMediumDate(state.birthdate!);
    return Column(
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.regManualIdentityTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: (v) => bloc.add(RegistrationCodeUpdated(v)),
                  decoration: InputDecoration(
                    labelText: l10n.regRegistrationCodeLabel,
                    hintText: l10n.regRegistrationCodeHint,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (v) => bloc.add(FirstNameUpdated(v)),
                        decoration: InputDecoration(labelText: l10n.regFirstName),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => bloc.add(FatherNameUpdated(v)),
                        decoration: InputDecoration(labelText: l10n.regLastName),
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
                        decoration: InputDecoration(labelText: l10n.regGrandfatherName),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        onChanged: (v) => bloc.add(PhoneNumberUpdated(v)),
                        decoration: InputDecoration(
                          labelText: l10n.regPhoneNumber,
                          hintText: l10n.regPhoneHint,
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
                        decoration: InputDecoration(labelText: l10n.regEmail),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<Gender>(
                        initialValue: state.gender,
                        items: [
                          DropdownMenuItem(value: Gender.male, child: Text(l10n.regMale)),
                          DropdownMenuItem(value: Gender.female, child: Text(l10n.regFemale)),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            bloc.add(GenderUpdated(value));
                          }
                        },
                        decoration: InputDecoration(labelText: l10n.regGender),
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
                DropdownButtonFormField<AsnafCategory>(
                  key: ValueKey(state.selectedCategory),
                  initialValue: state.selectedCategory,
                  items: AsnafCategory.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      bloc.add(AsnafCategorySelected(value));
                    }
                  },
                  decoration: InputDecoration(
                    labelText: l10n.regBeneficiaryCategory,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  maxLines: 2,
                  onChanged: (v) => bloc.add(NotesUpdated(v)),
                  decoration: InputDecoration(
                    labelText: l10n.regNotes,
                    hintText: l10n.regNotesHint,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _pickProfileImage(context),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: Text(l10n.regUploadProfilePicture),
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
    final l10n = context.l10n;
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
              l10n.regVerifyingFaydaBanner,
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<BeneficiaryRegistrationBloc>();
    return Column(
      children: [
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.regNeedsAssessment, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                maxLines: 4,
                onChanged: (v) => bloc.add(SituationDescriptionUpdated(v)),
                decoration: InputDecoration(
                  labelText: l10n.regSituationLabel,
                  hintText: l10n.regSituationHint,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => bloc.add(const SupportingProofPicked('hospital_bill_june.pdf')),
                icon: const Icon(Icons.upload_file_outlined),
                label: Text(l10n.regUploadProof),
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
    final l10n = context.l10n;
    final bloc = context.read<BeneficiaryRegistrationBloc>();
    return Column(
      children: [
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.regDisbursementSetup, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              PayoutMethodTile(
                title: l10n.regTelebirrTitle,
                subtitle: l10n.regTelebirrSubtitle,
                icon: Icons.account_balance_wallet_outlined,
                selected: state.payoutMethod == PayoutMethod.telebirrWallet,
                onTap: () =>
                    bloc.add(const PayoutMethodSelected(PayoutMethod.telebirrWallet)),
              ),
              const SizedBox(height: 10),
              PayoutMethodTile(
                title: l10n.regMpesaTitle,
                subtitle: l10n.regMpesaSubtitle,
                icon: Icons.phone_iphone_outlined,
                selected: state.payoutMethod == PayoutMethod.mPesa,
                onTap: () => bloc.add(const PayoutMethodSelected(PayoutMethod.mPesa)),
              ),
              const SizedBox(height: 10),
              PayoutMethodTile(
                title: l10n.regCoopbankTitle,
                subtitle: l10n.regCoopbankSubtitle,
                icon: Icons.account_balance_outlined,
                selected: state.payoutMethod == PayoutMethod.coopbank,
                onTap: () => bloc.add(const PayoutMethodSelected(PayoutMethod.coopbank)),
              ),
              const SizedBox(height: 14),
              TextField(
                onChanged: (v) => bloc.add(AccountOrMobileUpdated(v)),
                decoration: InputDecoration(labelText: l10n.regAccountOrMobile),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (v) => bloc.add(LegalNameUpdated(v)),
                decoration: InputDecoration(labelText: l10n.regFullLegalName),
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                value: state.hasAcceptedCompliance,
                contentPadding: EdgeInsets.zero,
                onChanged: (v) => bloc.add(ComplianceToggled(v ?? false)),
                title: Text(l10n.regAgreementTitle),
                subtitle: Text(l10n.regAgreementBody),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InstitutionDetailsStep extends StatelessWidget {
  const _InstitutionDetailsStep({required this.state});

  final BeneficiaryRegistrationState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<BeneficiaryRegistrationBloc>();
    return Column(
      children: [
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.regInstitutionRegistration,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<InstitutionSubtype>(
                key: ValueKey(state.institutionSubtype),
                initialValue: state.institutionSubtype,
                decoration: InputDecoration(
                  labelText: l10n.regInstitutionType,
                ),
                items: InstitutionSubtype.values
                    .map(
                      (subtype) => DropdownMenuItem(
                        value: subtype,
                        child: Text(subtype.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    bloc.add(InstitutionSubtypeUpdated(value));
                  }
                },
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (v) => bloc.add(LegalNameUpdated(v)),
                decoration: InputDecoration(labelText: l10n.regLegalName),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (v) => bloc.add(TradingNameUpdated(v)),
                decoration: InputDecoration(labelText: l10n.regTradingName),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (v) => bloc.add(TradeRegistrationNumberUpdated(v)),
                decoration: InputDecoration(
                  labelText: l10n.regTradeRegistrationNumber,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (v) => bloc.add(TaxIdentificationNumberUpdated(v)),
                decoration: InputDecoration(
                  labelText: l10n.regTin,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (v) => bloc.add(VatRegistrationNumberUpdated(v)),
                decoration: InputDecoration(
                  labelText: l10n.regVatOptional,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.phone,
                onChanged: (v) => bloc.add(PhoneNumberUpdated(v)),
                decoration: InputDecoration(
                  labelText: l10n.regPhoneNumber,
                  hintText: l10n.regPhoneHint,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (v) => bloc.add(EmailUpdated(v)),
                decoration: InputDecoration(labelText: l10n.regEmail),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (v) => bloc.add(RegionUpdated(v)),
                decoration: InputDecoration(labelText: l10n.regRegion),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (v) => bloc.add(CityUpdated(v)),
                decoration: InputDecoration(labelText: l10n.regCity),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (v) => bloc.add(AddressUpdated(v)),
                decoration: InputDecoration(labelText: l10n.regAddress),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (v) => bloc.add(NotesUpdated(v)),
                decoration: InputDecoration(
                  labelText: l10n.regNotesOptional,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: state.authorityToActDocumentRequired,
                onChanged: (value) =>
                    bloc.add(AuthorityToActRequiredToggled(value)),
                title: Text(l10n.regAuthorityDocTitle),
                subtitle: Text(l10n.regAuthorityDocBody),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<void> _pickInstitutionDocument(
  BuildContext context,
  String documentCode,
) async {
  final l10n = context.l10n;
  final source = await showModalBottomSheet<_DocumentPickSource>(
    context: context,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.commonTakePhoto),
              onTap: () =>
                  Navigator.of(sheetContext).pop(_DocumentPickSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.commonChooseGallery),
              onTap: () =>
                  Navigator.of(sheetContext).pop(_DocumentPickSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.attach_file_outlined),
              title: Text(l10n.commonChooseFile),
              onTap: () =>
                  Navigator.of(sheetContext).pop(_DocumentPickSource.file),
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
    String? filePath;
    switch (source) {
      case _DocumentPickSource.camera:
      case _DocumentPickSource.gallery:
        final picker = ImagePicker();
        final image = await picker.pickImage(
          source: source == _DocumentPickSource.camera
              ? ImageSource.camera
              : ImageSource.gallery,
          imageQuality: 85,
          maxWidth: 1400,
        );
        filePath = image?.path;
      case _DocumentPickSource.file:
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        );
        filePath = result?.files.single.path;
    }

    if (filePath == null || filePath.trim().isEmpty || !context.mounted) {
      return;
    }

    context.read<BeneficiaryRegistrationBloc>().add(
          InstitutionDocumentPicked(
            documentCode: documentCode,
            filePath: filePath,
          ),
        );
  } catch (_) {
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.regFilePickError),
      ),
    );
  }
}

enum _DocumentPickSource { camera, gallery, file }

class _InstitutionDocumentsStep extends StatelessWidget {
  const _InstitutionDocumentsStep({required this.state});

  final BeneficiaryRegistrationState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<BeneficiaryRegistrationBloc>();
    final documents = state.kycDocuments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.regUploadKycTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.regUploadKycBody,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (state.createdBeneficiaryId != null) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.regReference(state.createdBeneficiaryId!),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (documents.isEmpty)
          SectionCard(
            child: Text(l10n.regNoDocumentsRequired),
          )
        else
          ...documents.map((doc) {
            final pickedPath = state.pickedDocumentPaths[doc.code];
            final pickedName =
                pickedPath == null ? null : p.basename(pickedPath);
            final isUploading = state.uploadingDocumentCode == doc.code;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            doc.label,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (doc.uploaded)
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: doc.required
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        doc.required ? l10n.regRequired : l10n.regOptional,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                    if (pickedName != null && !doc.uploaded) ...[
                      const SizedBox(height: 8),
                      Text(
                        l10n.regSelectedFile(pickedName),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: doc.uploaded || isUploading
                                ? null
                                : () => _pickInstitutionDocument(
                                      context,
                                      doc.code,
                                    ),
                            icon: const Icon(Icons.attach_file_outlined),
                            label: Text(l10n.commonChooseFile),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textOnPrimary,
                            ),
                            onPressed: doc.uploaded ||
                                    isUploading ||
                                    pickedPath == null
                                ? null
                                : () => bloc.add(
                                      InstitutionDocumentUploadRequested(
                                        doc.code,
                                      ),
                                    ),
                            child: isUploading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.textOnPrimary,
                                    ),
                                  )
                                : Text(doc.uploaded ? l10n.regUploaded : l10n.regUpload),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}

class _SetPasswordStep extends StatefulWidget {
  const _SetPasswordStep({required this.state});

  final BeneficiaryRegistrationState state;

  @override
  State<_SetPasswordStep> createState() => _SetPasswordStepState();
}

class _SetPasswordStepState extends State<_SetPasswordStep> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<BeneficiaryRegistrationBloc>();
    final state = widget.state;

    return Column(
      children: [
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.regCreatePasswordTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.regCreatePasswordBody,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (state.createdBeneficiaryId != null) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.regReference(state.createdBeneficiaryId!),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 16),
              TextField(
                obscureText: _obscurePassword,
                onChanged: (v) => bloc.add(PasswordUpdated(v)),
                decoration: InputDecoration(
                  labelText: l10n.regPassword,
                  suffixIcon: IconButton(
                    onPressed: () => setState(
                      () => _obscurePassword = !_obscurePassword,
                    ),
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                obscureText: _obscureConfirm,
                onChanged: (v) => bloc.add(ConfirmPasswordUpdated(v)),
                decoration: InputDecoration(
                  labelText: l10n.regConfirmPassword,
                  suffixIcon: IconButton(
                    onPressed: () => setState(
                      () => _obscureConfirm = !_obscureConfirm,
                    ),
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.regPasswordRules,
                style: Theme.of(context).textTheme.bodySmall,
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
    final l10n = context.l10n;
    final bloc = context.read<BeneficiaryRegistrationBloc>();
    final isManualIdentitySubmit = state.method == RegistrationMethod.manual &&
        state.step == BeneficiaryRegistrationStep.identity;
    final isInstitutionDetailsSubmit =
        state.method == RegistrationMethod.institution &&
            state.step == BeneficiaryRegistrationStep.institutionDetails;
    final isFinalStep = state.step == BeneficiaryRegistrationStep.disbursement;
    final isInstitutionFinish =
        state.method == RegistrationMethod.institution &&
            state.step == BeneficiaryRegistrationStep.institutionDocuments;
    final isSetPasswordStep =
        state.step == BeneficiaryRegistrationStep.setPassword;

    final canContinue = switch (state.step) {
      BeneficiaryRegistrationStep.welcome => switch (state.method) {
          RegistrationMethod.fastTrack =>
            state.registrationCode.trim().isNotEmpty &&
                !state.isFaydaPosting &&
                !state.awaitingFaydaSse,
          _ => true,
        },
      BeneficiaryRegistrationStep.identity => state.isIdentityStepComplete,
      BeneficiaryRegistrationStep.institutionDetails =>
        state.isInstitutionDetailsComplete,
      BeneficiaryRegistrationStep.setPassword =>
        state.isSetPasswordStepComplete && !state.isSettingPassword,
      BeneficiaryRegistrationStep.institutionDocuments =>
        state.institutionRequiredKycComplete &&
            state.uploadingDocumentCode == null,
      BeneficiaryRegistrationStep.needs =>
        state.situationDescription.trim().isNotEmpty,
      BeneficiaryRegistrationStep.disbursement =>
        state.hasAcceptedCompliance &&
            state.accountOrMobileNumber.trim().isNotEmpty &&
            state.legalName.trim().isNotEmpty,
    };

    final continueLabel = switch (state.step) {
      BeneficiaryRegistrationStep.welcome when state.method == RegistrationMethod.fastTrack =>
        state.isFaydaPosting || state.awaitingFaydaSse
            ? l10n.regVerifyingFayda
            : state.faydaVerificationComplete
                ? l10n.commonContinue
                : l10n.regContinueWithFayda,
      BeneficiaryRegistrationStep.identity when isManualIdentitySubmit => l10n.regSubmitContinue,
      BeneficiaryRegistrationStep.institutionDetails when isInstitutionDetailsSubmit =>
        l10n.regSubmitContinue,
      BeneficiaryRegistrationStep.setPassword when state.method == RegistrationMethod.institution =>
        l10n.regSetPasswordContinue,
      BeneficiaryRegistrationStep.setPassword => l10n.regSetPasswordFinish,
      BeneficiaryRegistrationStep.institutionDocuments => l10n.commonFinish,
      BeneficiaryRegistrationStep.disbursement => l10n.commonFinish,
      _ => l10n.commonContinue,
    };

    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 10),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
          color: scheme.surface.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.55),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
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
                child: Text(l10n.commonBack),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                ),
                onPressed: !canContinue ||
                        state.isFaydaPosting ||
                        state.awaitingFaydaSse ||
                        state.uploadingDocumentCode != null ||
                        state.isSettingPassword
                    ? null
                    : () {
                        if (isSetPasswordStep) {
                          bloc.add(const SetPasswordRequested());
                          return;
                        }
                        if (isInstitutionFinish) {
                          bloc.add(const InstitutionRegistrationFinished());
                          return;
                        }
                        if (isFinalStep) {
                          bloc.add(const DisbursementRegistrationFinished());
                          return;
                        }
                        if (isManualIdentitySubmit) {
                          bloc.add(const BeneficiarySubmissionRequested());
                        } else if (isInstitutionDetailsSubmit) {
                          bloc.add(const InstitutionRegistrationRequested());
                        } else {
                          bloc.add(const RegistrationStepAdvanced());
                        }
                      },
                child: (isManualIdentitySubmit ||
                            isInstitutionDetailsSubmit ||
                            isSetPasswordStep) &&
                        (state.isSubmitting || state.isSettingPassword)
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
