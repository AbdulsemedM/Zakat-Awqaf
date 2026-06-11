/// API body for `POST /api/beneficiaries/v1/accounts/set-password`.
class SetPasswordRequest {
  const SetPasswordRequest({
    required this.beneficiaryId,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.passwordSetupToken,
  });

  final int beneficiaryId;
  final String phone;
  final String password;
  final String confirmPassword;
  final String passwordSetupToken;

  Map<String, dynamic> toJson() => {
        'beneficiaryId': beneficiaryId,
        'phone': phone.trim(),
        'password': password,
        'confirmPassword': confirmPassword,
      };
}
