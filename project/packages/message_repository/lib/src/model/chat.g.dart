// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      id: json['_id'] as String,
      name: json['name'] as String,
      members: (json['members'] as List<dynamic>)
          .map((e) => Contact.fromJson(e as Map<String, dynamic>))
          .toSet(),
      lastMessage: json['lastMessage'] == null
          ? Message.empty()
          : Message.fromJson(json['lastMessage'] as Map<String, dynamic>),
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'lastMessage': instance.lastMessage,
      'members': instance.members.toList(),
      'messages': instance.messages,
    };
