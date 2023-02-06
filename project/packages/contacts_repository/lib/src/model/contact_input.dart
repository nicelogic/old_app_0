import 'package:json_annotation/json_annotation.dart';

part 'contact_input.g.dart';

@JsonSerializable()
class ContactInput {
  final String _id;
  String get id => _id;
  final String _event;
  String get event => _event;

  const ContactInput({required String id, required String event})
      : _id = id,
        _event = event;

  factory ContactInput.fromJson(Map<String, dynamic> json) =>
      _$ContactInputFromJson(json);
  Map<String, dynamic> toJson() => _$ContactInputToJson(this);
}
