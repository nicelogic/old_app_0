import 'package:app/feature/chat/chat.dart';
import 'package:app/feature/message/message.dart';

import 'package:message_repository/message_repository.dart';

List<ChatMessage> toMessages(final Chat chat) {
  return chat.messages
      .map((e) => ChatMessage(
          id: e.id,
          chatId: chat.id,
          type: ChatMessageType.text,
          author: toChatUser(e.sender),
          text: e.text,
          creationTimestamp: int.parse(e.date)))
      .toList();
}

ChatMessage toMessage(
    {required final Message message, required final String chatId}) {
  return ChatMessage(
      id: message.id,
      chatId: chatId,
      type: ChatMessageType.text,
      author: toChatUser(message.sender),
      text: message.text,
      creationTimestamp: int.parse(message.date));
}
  // String? messageid; //usually a UUID
  // String? chatId;
  // ChatMessageType? type;
  // ChatUser? author;
  // String? text;
  // String?
  //     attachment; //URL for the incoming attachment once downloaded and stored locally
  // int? creationTimestamp; //server creation timestamp