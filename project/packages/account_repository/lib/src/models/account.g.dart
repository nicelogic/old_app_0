// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WechatAccount _$WechatAccountFromJson(Map<String, dynamic> json) {
  return WechatAccount(
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$WechatAccountToJson(WechatAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

Account _$AccountFromJson(Map<String, dynamic> json) {
  return Account(
    id: json['id'] as String,
    name: json['name'] as String? ?? '请填入昵称',
    signature: json['signature'] as String? ?? '',
    wechatAccount: json['wechatAccount'] == null
        ? null
        : WechatAccount.fromJson(json['wechatAccount'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'signature': instance.signature,
      'wechatAccount': instance.wechatAccount,
    };
