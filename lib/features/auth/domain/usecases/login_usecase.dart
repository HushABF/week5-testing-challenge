import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
}

class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);
}

class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

// FIX: Was missing input validation — empty credentials went straight to Firebase,
  // causing cryptic backend errors instead of a clean user-facing validation message.
  Future<AppUser> call(String email, String password) async {
    if (email.trim().isEmpty) {
      throw ValidationException('email can not be empty');
    }

    if (password.trim().isEmpty) {
      throw ValidationException('password can not be empty');
    }
    return await _repository.login(email, password);
  }
}
