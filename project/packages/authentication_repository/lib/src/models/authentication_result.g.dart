// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticationResult _$AuthenticationResultFromJson(Map<String, dynamic> json) {
  return AuthenticationResult(
    token: json['token'] as String,
    result: json['result'] as String,
  );
}

Map<String, dynamic> _$AuthenticationResultToJson(
        AuthenticationResult instance) =>
    <String, dynamic>{
      'token': instance.token,
      'result': instance.result,
    };
