import '../models/login_request.dart';
import '../models/otp_challenge.dart';
import '../models/set_password_request.dart';

/// Sign-in, sign-out and the account flows confirmed by an SMS code. The
/// code flows fail with `ApiException` (its `code` says why).
abstract class AuthRepository {
  Future<void> login(LoginRequest request);

  Future<void> setBeneficiaryPassword(SetPasswordRequest request);

  Future<void> logout();
  Future<bool> hasSession();

  /// [phone] in E.164.
  Future<OtpChallenge> startPasswordReset(String phone);

  Future<OtpChallenge> resendPasswordReset(String resetId);

  /// Every session of the account ends; the user signs in again.
  Future<void> confirmPasswordReset(
    String resetId, {
    required String code,
    required String newPassword,
  });

  Future<OtpChallenge> startDonorSignup({
    required String phone,
    required String fullName,
  });

  Future<OtpChallenge> resendDonorSignup(String signupId);

  /// Creates the donor account and signs in with it. `false` when the
  /// account was created but the user must sign in themselves.
  Future<bool> completeDonorSignup(
    String signupId, {
    required String otp,
    required String password,
  });

  /// Signed in. [newPhone] in E.164; the code goes to it.
  Future<OtpChallenge> startPhoneChange(String newPhone);

  Future<OtpChallenge> resendPhoneChange(String changeId);

  /// Changes the phone (the login). Every session of the account ends, so
  /// this one is closed on the phone too.
  Future<void> completePhoneChange(String changeId, {required String code});
}
