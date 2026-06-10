import '../models/login_request.dart';
import '../models/login_response_dto.dart';

abstract class AuthDataProvider {
  Future<LoginResponseDto> login(LoginRequest request);
}
