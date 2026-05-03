import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../domain/entities/app_user.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';

// ─── Events ────────────────────────────────────────────────────────────────
abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;
  LoginSubmitted(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class LogoutRequested extends AuthEvent {}

// ─── States ────────────────────────────────────────────────────────────────
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AppUser user;
  AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// ─── BLoC ──────────────────────────────────────────────────────────────────
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _loginUseCase.call(event.email, event.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // BUG 2:
  // The logout handler emits AuthUnauthenticated BEFORE calling logout.
  // If the logout call throws an exception (e.g. network error), the user
  // is already marked as unauthenticated in the UI even though their
  // session is still alive on the backend.
  // The correct order is: call logout first, then emit AuthUnauthenticated.
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthUnauthenticated());
    await _logoutUseCase.call();
  }
}
