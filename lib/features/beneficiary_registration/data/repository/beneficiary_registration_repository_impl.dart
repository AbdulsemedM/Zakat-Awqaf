import 'package:injectable/injectable.dart';

import '../data_provider/beneficiary_registration_data_provider.dart';
import '../models/beneficiary_create_request.dart';
import '../models/beneficiary_registration_result.dart';
import '../models/company_beneficiary_create_request.dart';
import 'beneficiary_registration_repository.dart';

@LazySingleton(as: BeneficiaryRegistrationRepository)
class BeneficiaryRegistrationRepositoryImpl
    implements BeneficiaryRegistrationRepository {
  BeneficiaryRegistrationRepositoryImpl(this._dataProvider);

  final BeneficiaryRegistrationDataProvider _dataProvider;

  @override
  Future<BeneficiaryRegistrationResult> register(
    BeneficiaryRegistrationRequest request,
  ) {
    return _dataProvider.createBeneficiary(request);
  }

  @override
  Future<BeneficiaryRegistrationResult> registerCompany(
    CompanyBeneficiaryCreateRequest request,
  ) {
    return _dataProvider.createCompany(request);
  }

  @override
  Future<BeneficiaryRegistrationResult> uploadCompanyDocument({
    required String companyId,
    required String uploadToken,
    required String documentCode,
    required String filePath,
  }) {
    return _dataProvider.uploadCompanyDocument(
      companyId: companyId,
      uploadToken: uploadToken,
      documentCode: documentCode,
      filePath: filePath,
    );
  }
}
