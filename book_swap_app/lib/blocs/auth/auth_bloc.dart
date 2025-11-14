// lib/presentation/blocs/auth/auth_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firebase_auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthService authService;
  StreamSubscription<User?>? _sub;

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignUpRequested>(_onSignUp);
    on<SignInRequested>(_onSignIn);
    on<SignOutRequested>(_onSignOut);
    on<ResendEmailVerification>(_onResendVerification);

    _sub = authService.authStateChanges().listen((user) {
      if (user == null) {
        add(SignOutRequested());
      } else {
        add(AppStarted()); // re-evaluate state
      }
    });
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final user = authService.currentUser;
    if (user == null) {
      emit(AuthUnauthenticated());
      return;
    }

    await user.reload();
    if (!user.emailVerified) {
      emit(AuthEmailNotVerified(user.email ?? ''));
      return;
    }

    emit(AuthAuthenticated(user));
  }

  Future<void> _onSignUp(SignUpRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final u = await authService.signUp(
        email: e.email,
        password: e.password,
        displayName: e.displayName,
      );
      emit(AuthEmailNotVerified(u!.email ?? ''));
    } catch (err) {
      emit(AuthError(err.toString()));
    }
  }

  Future<void> _onSignIn(SignInRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final u = await authService.signIn(
        email: e.email,
        password: e.password,
      );
      emit(AuthAuthenticated(u!));
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'email-not-verified') {
        emit(AuthEmailNotVerified(e.email));
      } else {
        emit(AuthError(ex.message ?? ex.code));
      }
    } catch (err) {
      emit(AuthError(err.toString()));
    }
  }

  Future<void> _onSignOut(SignOutRequested e, Emitter<AuthState> emit) async {
    await authService.signOut();
    emit(AuthUnauthenticated());
  }

  Future<void> _onResendVerification(
      ResendEmailVerification e, Emitter<AuthState> emit) async {
    try {
      await authService.sendEmailVerification();
      // Keep the same state (user will confirm manually)
      final user = authService.currentUser;
      if (user == null) {
        emit(AuthUnauthenticated());
      } else {
        emit(AuthEmailNotVerified(user.email ?? ''));
      }
    } catch (err) {
      emit(AuthError(err.toString()));
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
