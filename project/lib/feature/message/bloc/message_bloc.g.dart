// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageState _$MessageStateFromJson(Map<String, dynamic> json) => MessageState(
      chats: (json['chats'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Chat.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$MessageStateToJson(MessageState instance) =>
    <String, dynamic>{
      'chats': instance.chats.map((k, e) => MapEntry(k, e.toJson())),
    };
