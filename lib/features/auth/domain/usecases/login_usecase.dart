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

  // BUG 1:
  // This use case should throw a ValidationException when email or password
  // is empty BEFORE making any repository call.
  // Currently it skips validation and calls the repository regardless,
  // which means an empty email gets sent to Firebase directly — causing
  // a cryptic Firebase error instead of a clean validation message.
  Future<AppUser> call(String email, String password) async {
    return await _repository.login(email, password);
  }
}
