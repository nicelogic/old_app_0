import 'package:contacts_repository/contacts_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'message.dart';

part 'chat.g.dart';

@JsonSerializable()
// ignore: must_be_immutable
class Chat extends Equatable {
  final String _id;
  @JsonKey(name: '_id')
  String get id => _id;
  final String _name;
  String get name => _name;
  @JsonKey(defaultValue: {
    '_id': '',
    'date': '',
    'text': '',
    'sender': {'id': '', 'name': ''}
  })
  Message lastMessage;

  final Set<Contact> _members;
  Set<Contact> get members => _members;
  final List<Message> _messages;
  @JsonKey(defaultValue: [])
  List<Message> get messages => _messages;

  Chat(
      {required String id,
      required String name,
      required Set<Contact> members,
      required this.lastMessage,
      required List<Message> messages})
      : _id = id,
        _name = name,
        _members = members,
        _messages = messages;

  Chat copyWith(
      {final String? id,
      final String? name,
      final Set<Contact>? members,
      final Message? lastMessage,
      final List<Message>? messages}) {
    return Chat(
        id: id ?? this._id,
        name: name ?? this._name,
        members: members ?? this._members,
        lastMessage: lastMessage ?? this.lastMessage,
        messages: messages ?? this._messages);
  }

  @override
  List<Object> get props => [_id, _name, _members, _messages, lastMessage];

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
  Map<String, dynamic> toJson() => _$ChatToJson(this);
}
