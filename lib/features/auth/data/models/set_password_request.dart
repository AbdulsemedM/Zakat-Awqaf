/// API body for `POST /api/beneficiaries/v1/accounts/set-password`.
/// Token is sent via `X-Password-Setup-Token` header, not in the body.
class SetPasswordRequest {
  const SetPasswordRequest({
    required this.password,
    required this.confirmPassword,
    required this.passwordSetupToken,
  });

  final String password;
  final String confirmPassword;
  final String passwordSetupToken;

  Map<String, dynamic> toJson() => {
        'password': password,
        'confirmPassword': confirmPassword,
      };
}
