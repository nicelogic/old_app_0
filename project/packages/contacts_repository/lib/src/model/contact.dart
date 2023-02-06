import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
// ignore: must_be_immutable
class Contact extends Equatable {
  final String _id;
  @JsonKey(name: '_id')
  String get id => _id;
  final String _name;
  @JsonKey(defaultValue: '')
  String get name => _name;
  const Contact({required String id, required String name})
      : _id = id,
        _name = name;

  const Contact.empty()
      : _id = '',
        _name = '';

  @override
  List<Object> get props => [_id, _name];

  factory Contact.fromJson(Map<String, dynamic> json) {
    final contact = _$ContactFromJson(json);
    return contact;
  }
  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
