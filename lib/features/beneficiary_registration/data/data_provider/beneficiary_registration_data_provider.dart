import '../models/beneficiary_create_request.dart';
import '../models/beneficiary_registration_result.dart';
import '../models/company_beneficiary_create_request.dart';

abstract class BeneficiaryRegistrationDataProvider {
  Future<BeneficiaryRegistrationResult> createBeneficiary(
    BeneficiaryRegistrationRequest request,
  );

  Future<BeneficiaryRegistrationResult> createCompany(
    CompanyBeneficiaryCreateRequest request,
  );

  Future<BeneficiaryRegistrationResult> uploadCompanyDocument({
    required String companyId,
    required String uploadToken,
    required String documentCode,
    required String filePath,
  });
}
