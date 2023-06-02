part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  final bool isCreator;

  const Authenticated(this.user, this.isCreator);

  @override
  List<Object> get props => [user, isCreator];
}

class Unauthenticated extends AuthState {}
