abstract class BeneficiaryRegistrationRepository {
  Future<void> registerBeneficiary({
    required String fullName,
    required String phone,
  });
}
