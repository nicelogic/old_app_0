import 'package:app/config/config.dart';

import '../model/model.dart';
import 'package:app/feature/message/message.dart';
import 'package:contacts_repository/contacts_repository.dart';
import 'package:message_repository/message_repository.dart';

ChatUser? toChatUser(final Contact? contact) {
  return contact == null
      ? null
      : ChatUser(
          id: contact.id,
          name: contact.name,
          avatarURL: Config.instance().objectStorageUserAvatarUrl(contact.id));
}

ChatWithMembers? toChatWithMembers(
    {required final Chat chat, required final String accountId}) {
  final chatMembers = chat.members;
  chatMembers.removeWhere((element) => element.id == accountId);
  if (chatMembers.isEmpty) {
    return null;
  }

  final List<ChatUser> members = chatMembers
      .map((contact) => ChatUser(
          id: contact.id,
          name: contact.name == '' ? contact.id : contact.name,
          avatarURL: Config.instance().objectStorageUserAvatarUrl(contact.id)))
      .toList();
  final int? date =
      chat.lastMessage.date.isEmpty ? null : int.parse(chat.lastMessage.date);
  final chatWithMembers = ChatWithMembers(
      lastMessage: ChatMessage(
          author: toChatUser(chat.lastMessage.id.isEmpty ? null : chat.lastMessage.sender),
          text: chat.lastMessage.text,
          creationTimestamp: date),
      chat: UikitChat(id: chat.id, ownerId: accountId, unreadCount: 0),
      members: members);
  return chatWithMembers;
}
