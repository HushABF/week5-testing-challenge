// TODO: Write your tests here for the LoginUseCase
//
// Your test file must cover:
// 1. Calling login with valid credentials returns an AppUser
// 2. Calling login with an empty email throws a ValidationException
//    BEFORE the repository is ever called (verify mockRepo is never called)
// 3. Calling login with an empty password throws a ValidationException
//    BEFORE the repository is ever called
// 4. When the repository throws an AuthException, it propagates correctly
//
// Follow the TDD cycle:
//   Step 1 — Write the test
//   Step 2 — Run it and confirm it FAILS (flutter test)
//   Step 3 — Fix the bug in login_usecase.dart
//   Step 4 — Run again and confirm it PASSES

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:week5_testing_challenge/features/auth/domain/entities/app_user.dart';
import 'package:week5_testing_challenge/features/auth/domain/repositories/auth_repository.dart';
import 'package:week5_testing_challenge/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late LoginUseCase loginUseCase;

  final fakeUser = const AppUser(
    id: 'user-1',
    email: 'test@test.com',
    username: 'TestUser',
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockRepository);
  });

  // Write your tests below this line

// 1. Calling login with valid credentials returns an AppUser

  test('Calling login with valid credentials returns an AppUser', () async {
    when(
      () => mockRepository.login('test@test.com', 'correct-password'),
    ).thenAnswer(
      (_) async => fakeUser,
    );

    final result = await loginUseCase.call('test@test.com', "correct-password");

    verify(() => mockRepository.login('test@test.com', "correct-password"))
        .called(1);

    expect(result, fakeUser);
  });

// 2. Calling login with an empty email throws a ValidationException
//    BEFORE the repository is ever called (verify mockRepo is never called)
  test(
      'Calling login with an empty email throws a ValidationException, BEFORE the repository is ever called ',
      () async {
    await expectLater(() => loginUseCase.call('', 'any-password'),
        throwsA(isA<ValidationException>()));

    verifyNever(() => mockRepository.login(any(), any()));
  });

// 3. Calling login with an empty password throws a ValidationException
//    BEFORE the repository is ever called
  test(
      'Calling login with an empty password throws a ValidationException, BEFORE the repository is ever called ',
      () async {
    await expectLater(
        () async => await loginUseCase.call('anyemail@gmail.com', ''),
        throwsA(isA<ValidationException>()));

    verifyNever(() => mockRepository.login(any(), any()));
  });

// 4. When the repository throws an AuthException, it propagates correctly
  test(' When the repository throws an AuthException, it propagates correctly',
      () async {
    when(
      () => mockRepository.login('email@gmail.com', 'password'),
    ).thenThrow(AuthException('Wrong input'));

    await expectLater(
        () async => await loginUseCase.call('email@gmail.com', 'password'),
        throwsA(isA<AuthException>()));
  });
}
