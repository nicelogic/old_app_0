import 'package:chat_ui_kit/chat_ui_kit.dart';
import 'package:contacts_repository/contacts_repository.dart';

class ChatUser extends UserBase {
  final String _id;
  @override
  String get id => _id;

  final String _name;
  @override
  String get name => _name;

  final String _avatarURL;
  @override
  String get avatar => _avatarURL;

  ChatUser({required id, required name, required avatarURL})
      : _id = id,
        _name = name,
        _avatarURL = avatarURL;

  Contact toContact() {
    return Contact(id: _id, name: _name);
  }
}
