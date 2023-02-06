// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactsState _$ContactStateFromJson(Map<String, dynamic> json) => ContactsState(
      (json['contacts'] as List<dynamic>)
          .map((e) => Contact.fromJson(e as Map<String, dynamic>))
          .toSet(),
      json['contactNum'] as int,
    );

Map<String, dynamic> _$ContactStateToJson(ContactsState instance) =>
    <String, dynamic>{
      'contacts': instance.contacts.map((e) => e.toJson()).toList(),
      'contactNum': instance.contactNum,
    };
