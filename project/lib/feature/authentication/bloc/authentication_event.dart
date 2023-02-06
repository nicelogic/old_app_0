part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationResultChanged extends AuthenticationEvent {
  const AuthenticationResultChanged(this._authenticationResult);

  final AuthenticationResult _authenticationResult;

  @override
  List<Object> get props => [_authenticationResult];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}
