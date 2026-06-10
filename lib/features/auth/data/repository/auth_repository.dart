import '../models/login_request.dart';

abstract class AuthRepository {
  Future<void> login(LoginRequest request);
  Future<void> logout();
  Future<bool> hasSession();
}
