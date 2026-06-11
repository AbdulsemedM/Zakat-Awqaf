import '../models/login_request.dart';
import '../models/set_password_request.dart';

abstract class AuthRepository {
  Future<void> login(LoginRequest request);

  Future<void> setBeneficiaryPassword(SetPasswordRequest request);

  Future<void> logout();
  Future<bool> hasSession();
}
