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

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:week5_testing_challenge/features/auth/domain/entities/app_user.dart';
import 'package:week5_testing_challenge/features/auth/domain/usecases/login_usecase.dart';
import 'package:week5_testing_challenge/features/auth/domain/usecases/logout_usecase.dart';
import 'package:week5_testing_challenge/features/auth/presentation/bloc/auth_bloc.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late AuthBloc authBloc;

  final fakeUser = const AppUser(
    id: 'user-1',
    email: 'test@test.com',
    username: 'TestUser',
  );

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();

    authBloc = AuthBloc(
        loginUseCase: mockLoginUseCase, logoutUseCase: mockLogoutUseCase);
  });

  // Write your tests below this line

// 1. LoginSubmitted with valid credentials emits [AuthLoading, AuthAuthenticated]
  blocTest<AuthBloc, AuthState>(
    'LoginSubmitted with valid credentials emits [AuthLoading, AuthAuthenticated]',
    setUp: () {
      when(
        () => mockLoginUseCase.call('test@test.com', 'correct-password'),
      ).thenAnswer(
        (_) async => fakeUser,
      );
    },
    build: () => authBloc,
    act: (bloc) =>
        bloc.add(LoginSubmitted('test@test.com', 'correct-password')),
    expect: () => [AuthLoading(), AuthAuthenticated(fakeUser)],
  );

// 2. LoginSubmitted with invalid credentials emits [AuthLoading, AuthError]

  blocTest<AuthBloc, AuthState>(
    'LoginSubmitted with invalid credentials emits [AuthLoading, AuthError]',
    setUp: () {
      when(
        () => mockLoginUseCase.call('test@test.com', 'wrong-password'),
      ).thenThrow(AuthException('Invalid Credentials'));
    },
    build: () => authBloc,
    act: (bloc) => bloc.add(LoginSubmitted('test@test.com', 'wrong-password')),
    expect: () => [AuthLoading(), isA<AuthError>()],
  );
  

// 3. LogoutRequested — the logout use case must be called BEFORE
//    AuthUnauthenticated is emitted, not after.

  test(
      'LogoutRequested — the logout use case must be called BEFORE AuthUnauthenticated is emitted, not after.',
      () async {
    final Completer<void> completer = Completer<void>();

    when(
      () => mockLogoutUseCase.call(),
    ).thenAnswer((_) => completer.future);

    authBloc.add(LogoutRequested());
    await Future.delayed(Duration.zero); // let the event loop process

    expect(authBloc.state, isNot(isA<AuthUnauthenticated>()));

    completer.complete();
    await Future.delayed(Duration.zero); // let the event loop process

    expect(authBloc.state, isA<AuthUnauthenticated>());
  });
}
