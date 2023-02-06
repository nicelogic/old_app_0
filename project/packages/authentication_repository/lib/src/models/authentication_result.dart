import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'authentication_result.g.dart';

@JsonSerializable()
class AuthenticationResult extends Equatable {
  final String _token;
  final String _result;

  const AuthenticationResult({String token = '', String result = ''})
      : _token = token,
        _result = result;

  static const empty = AuthenticationResult(token: '', result: '');

  String get token => _token;
  String get result => _result;

  AuthenticationResult copyWith({String? token, String? result}) {
    return AuthenticationResult(
        token: token ?? this.token, result: result ?? this.result);
  }

  @override
  List<Object> get props => [_token, _result];

  factory AuthenticationResult.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResultFromJson(json);
  Map<String, dynamic> toJson() => _$AuthenticationResultToJson(this);
}
