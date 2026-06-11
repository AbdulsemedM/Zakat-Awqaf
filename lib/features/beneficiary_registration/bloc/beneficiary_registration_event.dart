import 'package:equatable/equatable.dart';

import '../data/models/institution_subtype.dart';
import 'beneficiary_registration_state.dart';

sealed class BeneficiaryRegistrationEvent extends Equatable {
  const BeneficiaryRegistrationEvent();

  @override
  List<Object?> get props => [];
}

final class BeneficiaryRegistrationStarted extends BeneficiaryRegistrationEvent {
  const BeneficiaryRegistrationStarted();
}

final class RegistrationMethodSelected extends BeneficiaryRegistrationEvent {
  const RegistrationMethodSelected(this.method);
  final RegistrationMethod method;

  @override
  List<Object?> get props => [method];
}

final class RegistrationStepAdvanced extends BeneficiaryRegistrationEvent {
  const RegistrationStepAdvanced();
}

final class RegistrationStepWentBack extends BeneficiaryRegistrationEvent {
  const RegistrationStepWentBack();
}

final class NationalIdUpdated extends BeneficiaryRegistrationEvent {
  const NationalIdUpdated(this.nationalId);
  final String nationalId;

  @override
  List<Object?> get props => [nationalId];
}

final class FaydaRegistrationRequested extends BeneficiaryRegistrationEvent {
  const FaydaRegistrationRequested();
}

final class FaydaSseCompletedSuccessfully extends BeneficiaryRegistrationEvent {
  const FaydaSseCompletedSuccessfully();
}

final class FaydaSseStreamFinished extends BeneficiaryRegistrationEvent {
  const FaydaSseStreamFinished();
}

final class FaydaSseConnectionFailed extends BeneficiaryRegistrationEvent {
  const FaydaSseConnectionFailed(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

final class FaydaSseRetryRequested extends BeneficiaryRegistrationEvent {
  const FaydaSseRetryRequested();
}

final class FirstNameUpdated extends BeneficiaryRegistrationEvent {
  const FirstNameUpdated(this.value);
  final String value;

  @override
  List<Object?> get props => [value];
}

final class FatherNameUpdated extends BeneficiaryRegistrationEvent {
  const FatherNameUpdated(this.value);
  final String value;

  @override
  List<Object?> get props => [value];
}

final class GrandFatherNameUpdated extends BeneficiaryRegistrationEvent {
  const GrandFatherNameUpdated(this.value);
  final String value;

  @override
  List<Object?> get props => [value];
}

final class PhoneNumberUpdated extends BeneficiaryRegistrationEvent {
  const PhoneNumberUpdated(this.value);
  final String value;

  @override
  List<Object?> get props => [value];
}

final class EmailUpdated extends BeneficiaryRegistrationEvent {
  const EmailUpdated(this.value);
  final String value;

  @override
  List<Object?> get props => [value];
}

final class ProfilePicturePicked extends BeneficiaryRegistrationEvent {
  const ProfilePicturePicked(this.fileName);
  final String fileName;

  @override
  List<Object?> get props => [fileName];
}

final class ProfilePictureRemoved extends BeneficiaryRegistrationEvent {
  const ProfilePictureRemoved();
}

final class GenderUpdated extends BeneficiaryRegistrationEvent {
  const GenderUpdated(this.value);
  final Gender value;

  @override
  List<Object?> get props => [value];
}

final class BirthdateUpdated extends BeneficiaryRegistrationEvent {
  const BirthdateUpdated(this.value);
  final DateTime? value;

  @override
  List<Object?> get props => [value];
}

final class AddressUpdated extends BeneficiaryRegistrationEvent {
  const AddressUpdated(this.value);
  final String value;

  @override
  List<Object?> get props => [value];
}

final class RegionUpdated extends BeneficiaryRegistrationEvent {
  const RegionUpdated(this.value);
  final String value;

  @override
  List<Object?> get props => [value];
}

final class CityUpdated extends BeneficiaryRegistrationEvent {
  const CityUpdated(this.value);
  final String value;

  @override
  List<Object?> get props => [value];
}

final class NotesUpdated extends BeneficiaryRegistrationEvent {
  const NotesUpdated(this.value);
  final String value;

  @override
  List<Object?> get props => [value];
}

final class AsnafCategoryToggled extends BeneficiaryRegistrationEvent {
  const AsnafCategoryToggled(this.category);
  final AsnafCategory category;

  @override
  List<Object?> get props => [category];
}

final class SituationDescriptionUpdated extends BeneficiaryRegistrationEvent {
  const SituationDescriptionUpdated(this.description);
  final String description;

  @override
  List<Object?> get props => [description];
}

final class SupportingProofPicked extends BeneficiaryRegistrationEvent {
  const SupportingProofPicked(this.fileName);
  final String fileName;

  @override
  List<Object?> get props => [fileName];
}

final class SupportingProofRemoved extends BeneficiaryRegistrationEvent {
  const SupportingProofRemoved();
}

final class PayoutMethodSelected extends BeneficiaryRegistrationEvent {
  const PayoutMethodSelected(this.method);
  final PayoutMethod method;

  @override
  List<Object?> get props => [method];
}

final class AccountOrMobileUpdated extends BeneficiaryRegistrationEvent {
  const AccountOrMobileUpdated(this.value);
  final String value;

  @override
  List<Object?> get props => [value];
}

final class LegalNameUpdated extends BeneficiaryRegistrationEvent {
  const LegalNameUpdated(this.value);
  final String value;

  @override
  List<Object?> get props => [value];
}

final class ComplianceToggled extends BeneficiaryRegistrationEvent {
  const ComplianceToggled(this.accepted);
  final bool accepted;

  @override
  List<Object?> get props => [accepted];
}

final class BeneficiarySubmissionRequested extends BeneficiaryRegistrationEvent {
  const BeneficiarySubmissionRequested();
}

final class TradingNameUpdated extends BeneficiaryRegistrationEvent {
  const TradingNameUpdated(this.value);
  final String value;

  @override
  List<Object?> get props => [value];
}

final class TradeRegistrationNumberUpdated extends BeneficiaryRegistrationEvent {
  const TradeRegistrationNumberUpdated(this.value);
  final String value;

  @override
  List<Object?> get props => [value];
}

final class TaxIdentificationNumberUpdated extends BeneficiaryRegistrationEvent {
  const TaxIdentificationNumberUpdated(this.value);
  final String value;

  @override
  List<Object?> get props => [value];
}

final class VatRegistrationNumberUpdated extends BeneficiaryRegistrationEvent {
  const VatRegistrationNumberUpdated(this.value);
  final String value;

  @override
  List<Object?> get props => [value];
}

final class InstitutionSubtypeUpdated extends BeneficiaryRegistrationEvent {
  const InstitutionSubtypeUpdated(this.value);
  final InstitutionSubtype value;

  @override
  List<Object?> get props => [value];
}

final class AuthorityToActRequiredToggled extends BeneficiaryRegistrationEvent {
  const AuthorityToActRequiredToggled(this.required);
  final bool required;

  @override
  List<Object?> get props => [required];
}

final class InstitutionRegistrationRequested extends BeneficiaryRegistrationEvent {
  const InstitutionRegistrationRequested();
}

final class InstitutionDocumentPicked extends BeneficiaryRegistrationEvent {
  const InstitutionDocumentPicked({
    required this.documentCode,
    required this.filePath,
  });

  final String documentCode;
  final String filePath;

  @override
  List<Object?> get props => [documentCode, filePath];
}

final class InstitutionDocumentUploadRequested extends BeneficiaryRegistrationEvent {
  const InstitutionDocumentUploadRequested(this.documentCode);
  final String documentCode;

  @override
  List<Object?> get props => [documentCode];
}

final class InstitutionRegistrationFinished extends BeneficiaryRegistrationEvent {
  const InstitutionRegistrationFinished();
}

final class PasswordUpdated extends BeneficiaryRegistrationEvent {
  const PasswordUpdated(this.value);
  final String value;

  @override
  List<Object?> get props => [value];
}

final class ConfirmPasswordUpdated extends BeneficiaryRegistrationEvent {
  const ConfirmPasswordUpdated(this.value);
  final String value;

  @override
  List<Object?> get props => [value];
}

final class SetPasswordRequested extends BeneficiaryRegistrationEvent {
  const SetPasswordRequested();
}
