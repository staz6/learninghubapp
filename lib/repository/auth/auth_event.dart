part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class SignedOut extends AuthEvent {}

class LogInRequested extends AuthEvent {
  final String email;
  final String password;

  const LogInRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}
class SignUpRequested extends AuthEvent {
  final String username;
  final String fullname;
  final String email;
  final String password;
  final Function(String message) onFailure;

  const SignUpRequested({required this.username, required this.fullname, required this.email, required this.password, required this.onFailure});
}
