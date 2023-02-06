import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'account.g.dart';

@JsonSerializable()
class Account extends Equatable {
  final String id;
  final String name;
  final String signature;
  final String wechatId;

  const Account(
      {this.id = '', this.name = '', this.signature = '', this.wechatId = ''});

  static const empty = Account();

  Account copyWith(
      {String? id, String? name, String? signature, String? wechatId}) {
    return Account(
        id: id ?? this.id,
        name: name ?? this.name,
        signature: signature ?? this.signature,
        wechatId: wechatId ?? this.wechatId);
  }

  @override
  List<Object> get props => [id, signature, name, wechatId];

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
