// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountState _$AccountStateFromJson(Map<String, dynamic> json) => AccountState(
      account: json['account'] == null
          ? Account.empty
          : Account.fromJson(json['account'] as Map<String, dynamic>),
      accountStatus:
          $enumDecodeNullable(_$AccountStatusEnumMap, json['accountStatus']) ??
              AccountStatus.got,
    );

Map<String, dynamic> _$AccountStateToJson(AccountState instance) =>
    <String, dynamic>{
      'account': instance.account.toJson(),
      'accountStatus': _$AccountStatusEnumMap[instance.accountStatus],
    };

const _$AccountStatusEnumMap = {
  AccountStatus.got: 'got',
  AccountStatus.serverError: 'serverError',
};
