// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['_id'] as String,
      text: json['text'] as String,
      sender: Contact.fromJson(json['sender'] as Map<String, dynamic>),
      date: json['date'] as String,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      '_id': instance.id,
      'text': instance.text,
      'sender': instance.sender,
      'date': instance.date,
    };

MessageWithChatId _$MessageWithChatIdFromJson(Map<String, dynamic> json) =>
    MessageWithChatId(
      id: json['_id'] as String,
      message: Message.fromJson(json['message'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MessageWithChatIdToJson(MessageWithChatId instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'message': instance.message,
    };
