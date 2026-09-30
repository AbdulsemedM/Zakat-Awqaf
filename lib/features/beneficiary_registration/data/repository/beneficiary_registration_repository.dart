import '../models/beneficiary_create_request.dart';
import '../models/beneficiary_registration_result.dart';
import '../models/company_beneficiary_create_request.dart';
import '../models/registration_code_validation.dart';

abstract class BeneficiaryRegistrationRepository {
  Future<RegistrationCodeValidation> validateRegistrationCode(String code);

  Future<BeneficiaryRegistrationResult> register(
    BeneficiaryRegistrationRequest request,
  );

  Future<BeneficiaryRegistrationResult> registerCompany(
    CompanyBeneficiaryCreateRequest request,
  );

  Future<BeneficiaryRegistrationResult> uploadCompanyDocument({
    required String companyId,
    required String uploadToken,
    required String documentCode,
    required String filePath,
  });
}
