// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatState _$ChatStateFromJson(Map<String, dynamic> json) => ChatState(
      chats: (json['chats'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Chat.fromJson(e as Map<String, dynamic>)),
      ),
      lastMessageWithChatIdForNotification:
          json['lastMessageWithChatIdForNotification'] == null
              ? null
              : MessageWithChatId.fromJson(
                  json['lastMessageWithChatIdForNotification']
                      as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatStateToJson(ChatState instance) => <String, dynamic>{
      'lastMessageWithChatIdForNotification':
          instance.lastMessageWithChatIdForNotification?.toJson(),
      'chats': instance.chats.map((k, e) => MapEntry(k, e.toJson())),
    };
