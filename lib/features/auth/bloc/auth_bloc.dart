import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/common/utils/phone_e164.dart';
import '../data/auth_exception.dart';
import '../data/models/login_request.dart';
import '../data/repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repository) : super(const AuthInitial()) {
    on<AuthLoginSubmitted>(_onLoginSubmitted);
  }

  final AuthRepository _repository;

  Future<void> _onLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final username = PhoneE164.normalize(event.username.trim()) ??
        event.username.trim();
    final password = event.password;

    if (username.isEmpty) {
      emit(const AuthFailure('Enter your phone number.'));
      return;
    }
    if (password.isEmpty) {
      emit(const AuthFailure('Enter your password.'));
      return;
    }

    emit(const AuthLoading());
    try {
      await _repository.login(
        LoginRequest(username: username, password: password),
      );
      emit(const AuthSuccess());
    } on AuthException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
