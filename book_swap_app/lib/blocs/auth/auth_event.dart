// lib/presentation/blocs/auth/auth_event.dart
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}
class SignUpRequested extends AuthEvent {
  final String email, password, displayName;
  SignUpRequested(this.email, this.password, this.displayName);
  @override List<Object?> get props => [email];
}
class SignInRequested extends AuthEvent {
  final String email, password;
  SignInRequested(this.email, this.password);
  @override List<Object?> get props => [email];
}
class SignOutRequested extends AuthEvent {}
class ResendEmailVerification extends AuthEvent {}
