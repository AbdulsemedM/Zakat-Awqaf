import '../models/login_request.dart';
import '../models/login_response_dto.dart';
import '../models/set_password_request.dart';

abstract class AuthDataProvider {
  Future<LoginResponseDto> login(LoginRequest request);

  Future<void> setBeneficiaryPassword(SetPasswordRequest request);
}
