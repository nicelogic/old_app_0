import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';
import '../model/model.dart';

part 'authentication_state.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final AuthenticationResult authenticationResult;

  @override
  List<Object> get props => [status, authenticationResult];
  const AuthenticationState({
    this.status = AuthenticationStatus.unknown,
    this.authenticationResult = AuthenticationResult.empty,
  });

  const AuthenticationState.unknown() : this();

  const AuthenticationState.authenticated(AuthenticationResult result)
      : this(
            status: AuthenticationStatus.authenticated,
            authenticationResult: result);

  const AuthenticationState.unauthenticated(AuthenticationResult result)
      : this(
            status: AuthenticationStatus.unauthenticated,
            authenticationResult: result);

  factory AuthenticationState.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationStateFromJson(json);
  Map<String, dynamic> toJson() => _$AuthenticationStateToJson(this);
}
