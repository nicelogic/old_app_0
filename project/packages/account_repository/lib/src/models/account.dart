import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'account.g.dart';

@JsonSerializable()
class WechatAccount extends Equatable {
  final String id;

  const WechatAccount({this.id = ''});

  @override
  List<Object> get props => [id];

  factory WechatAccount.fromJson(Map<String, dynamic> json) =>
      _$WechatAccountFromJson(json);
  Map<String, dynamic> toJson() => _$WechatAccountToJson(this);
}

@JsonSerializable()
class Account extends Equatable {
  final String id;
  @JsonKey(defaultValue: '请设置昵称')
  final String name;
  @JsonKey(defaultValue: '')
  final String signature;
  final WechatAccount? wechatAccount;

  const Account(
      {this.id = '',
      this.name = '',
      this.signature = '',
      this.wechatAccount = const WechatAccount(id: '')});

  static const empty = Account();

  @override
  List<Object> get props => [id, name, signature];

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
