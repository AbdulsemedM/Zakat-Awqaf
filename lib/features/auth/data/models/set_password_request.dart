/// API body for `POST /api/beneficiaries/v1/accounts/set-password`.
class SetPasswordRequest {
  const SetPasswordRequest({
    required this.beneficiaryId,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });

  final int beneficiaryId;
  final String phone;
  final String password;
  final String confirmPassword;

  Map<String, dynamic> toJson() => {
        'beneficiaryId': beneficiaryId,
        'phone': phone.trim(),
        'password': password,
        'confirmPassword': confirmPassword,
      };
}
