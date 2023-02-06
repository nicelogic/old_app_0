import 'dart:async';
import 'dart:developer';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'authentication_state.dart';
import 'package:app/router/router.dart' as router;

part 'authentication_event.dart';

class AuthenticationBloc
    extends HydratedBloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc(
    AuthenticationRepository authenticationRepository,
  )   : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationLogoutRequested>(_onAuthenticationLogout,
        transformer: sequential());
    on<AuthenticationResultChanged>(_onAuthenticationAccountChanged,
        transformer: sequential());
  }

  @override
  Future<void> close() {
    return super.close();
  }

  Future<AuthenticationResult> signUpWithUserName(
      {required String userName, required String password}) async {
    final result = await _authenticationRepository.signUpWithUserName(
        userName: userName, password: password);
    add(AuthenticationResultChanged(result));
    return result;
  }

  Future<AuthenticationResult> signInWithUserName(
      {required String userName, required String password}) async {
    final result = await _authenticationRepository.signInWithUserName(
        userName: userName, password: password);
    add(AuthenticationResultChanged(result));
    return result;
  }

  _onAuthenticationLogout(AuthenticationLogoutRequested event,
      Emitter<AuthenticationState> emit) async {
    router.isAuthenticated = false;
    log('AuthGuard: isAuthenticated: ${router.isAuthenticated}');
    emit(const AuthenticationState.unauthenticated(
        AuthenticationResult(result: 'logout')));
  }

  _onAuthenticationAccountChanged(AuthenticationResultChanged event,
      Emitter<AuthenticationState> emit) async {
    final isAuthenticated = event._authenticationResult.result == 'success';
    router.isAuthenticated = isAuthenticated;
    log('AuthGuard: isAuthenticated: ${router.isAuthenticated}');
    emit(isAuthenticated
        ? AuthenticationState.authenticated(event._authenticationResult)
        : AuthenticationState.unauthenticated(event._authenticationResult));
  }

  @override
  AuthenticationState fromJson(Map<String, dynamic> json) {
    try {
      return AuthenticationState.fromJson(json);
    } catch (err) {
      return const AuthenticationState.unauthenticated(AuthenticationResult(
          result: 'load authentication result from json fail'));
    }
  }

  @override
  Map<String, dynamic> toJson(AuthenticationState state) => state.toJson();
}
