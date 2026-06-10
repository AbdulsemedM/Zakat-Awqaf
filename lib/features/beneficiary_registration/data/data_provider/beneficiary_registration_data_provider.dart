import '../models/beneficiary_create_request.dart';
import '../models/beneficiary_registration_result.dart';

abstract class BeneficiaryRegistrationDataProvider {
  Future<BeneficiaryRegistrationResult> createBeneficiary(
    BeneficiaryRegistrationRequest request,
  );
}
