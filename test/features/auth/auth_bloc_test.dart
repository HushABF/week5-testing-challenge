// TODO: Write your BLoC tests here for AuthBloc
//
// Your test file must cover:
// 1. LoginSubmitted with valid credentials emits [AuthLoading, AuthAuthenticated]
// 2. LoginSubmitted with invalid credentials emits [AuthLoading, AuthError]
// 3. LogoutRequested — the logout use case must be called BEFORE
//    AuthUnauthenticated is emitted, not after.
//    Hint: use a completer or a delayed mock to verify the order.
//
// Follow the TDD cycle:
//   Step 1 — Write the test
//   Step 2 — Run it and confirm it FAILS
//   Step 3 — Fix the bug in auth_bloc.dart
//   Step 4 — Run again and confirm it PASSES

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:week5_testing_challenge/features/auth/domain/entities/app_user.dart';
import 'package:week5_testing_challenge/features/auth/domain/repositories/auth_repository.dart';
import 'package:week5_testing_challenge/features/auth/domain/usecases/login_usecase.dart';
import 'package:week5_testing_challenge/features/auth/domain/usecases/logout_usecase.dart';
import 'package:week5_testing_challenge/features/auth/presentation/bloc/auth_bloc.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late LoginUseCase loginUseCase;
  late LogoutUseCase logoutUseCase;

  final fakeUser = const AppUser(
    id: 'user-1',
    email: 'test@test.com',
    username: 'TestUser',
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockRepository);
    logoutUseCase = LogoutUseCase(mockRepository);
  });

  // Write your tests below this line
}
