// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
      id: json['_id'] as String,
      name: json['name'] as String? ?? '',
    );

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
    };
