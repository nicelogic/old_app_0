
import 'package:contacts_repository/contacts_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message extends Equatable {
  final String _id;
  @JsonKey(name: '_id')
  String get id => _id;
  final String _text;
  String get text => _text;
  final Contact _sender;
  Contact get sender => _sender;
  final String _date;
  String get date => _date;

  const Message(
      {required String id,
      required String text,
      required Contact sender,
      required final String date})
      : _id = id,
        _text = text,
        _sender = sender,
        _date = date;

  const Message.empty()
      : _id = '',
        _text = '',
        _sender = const Contact.empty(),
        _date = '';

  @override
  List<Object> get props => [_id, _text, _sender, _date];

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

@JsonSerializable()
class MessageWithChatId extends Equatable {
  final String _id;
  @JsonKey(name: '_id')
  String get id => _id;
  final Message _message;
  Message get message => _message;

  const MessageWithChatId({required String id, required Message message})
      : _id = id,
        _message = message;

  @override
  List<Object> get props => [_id, _message];

  factory MessageWithChatId.fromJson(Map<String, dynamic> json) =>
      _$MessageWithChatIdFromJson(json);
  Map<String, dynamic> toJson() => _$MessageWithChatIdToJson(this);
}
