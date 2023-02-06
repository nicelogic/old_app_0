import 'package:chat_ui_kit/chat_ui_kit.dart';
import 'package:message_repository/message_repository.dart';
import 'package:contacts_repository/contacts_repository.dart';

import 'dart:math';

import 'package:app/feature/chat/chat.dart';

enum ChatMessageType {
  image,
  video,
  audio,
  text,
  addUser,
  leaveChat,
  renameChat,
  typingStart,
  typingStop,
  delete
}

class ChatMessage extends MessageBase {
  String? messageid; //usually a UUID
  String? chatId;
  ChatMessageType? type;
  @override
  ChatUser? author;
  @override
  String? text;
  String?
      attachment; //URL for the incoming attachment once downloaded and stored locally
  int? creationTimestamp; //server creation timestamp

  ChatMessage(
      {id,
      this.chatId,
      this.type = ChatMessageType.text,
      required this.author,
      required this.text,
      this.attachment,
      required this.creationTimestamp}) {
    messageid = id;
    if (messageid == null || messageid?.isEmpty == true) {
      messageid = _generateRandomString(10);
    }
    creationTimestamp ??= 0;
  }

  Message toMessage() {
    return Message(
        id: id,
        text: text ?? '',
        sender: Contact(id: author?.id ?? '', name: author?.name ?? ''),
        date: creationTimestamp.toString());
  }

  @override
  String get id => messageid != null ? messageid! : "";

  @override
  DateTime get createdAt =>
      DateTime.fromMillisecondsSinceEpoch(creationTimestamp!);

  @override
  String get url => attachment ?? "";

  @override
  MessageBaseType get messageType {
    if (type == ChatMessageType.text) return MessageBaseType.text;
    if (type == ChatMessageType.image) return MessageBaseType.image;
    if (type == ChatMessageType.audio) return MessageBaseType.audio;
    if (type == ChatMessageType.video) return MessageBaseType.video;
    return MessageBaseType.other;
  }

  bool get isTypeMedia {
    return type == ChatMessageType.video || type == ChatMessageType.image;
  }

  bool get isTypeEvent {
    return !isUserMessage && type != ChatMessageType.delete;
  }

  /// Helper message to check if the message is a user input,
  /// as opposed to generated events like renaming, leaving a chat
  bool get isUserMessage {
    final List<ChatMessageType> userTypes = [
      ChatMessageType.text,
      ChatMessageType.image,
      ChatMessageType.video,
      ChatMessageType.audio
    ];
    return userTypes.contains(type);
  }

  bool get hasAttachment => attachment != null && attachment!.isNotEmpty;

  String messageText(String localUserId) {
    if (type == ChatMessageType.renameChat) {
      if (author?.id == localUserId) {
        //current user renamed the chat
        return "You renamed the chat";
      } else {
        //another user renamed the chat
        return "${author?.name} renamed the chat to '$text'";
      }
    } else {
      //type message, check if it's a file attachment
      if (!hasAttachment) return text ?? "";
      if (type == ChatMessageType.audio) {
        return "Voice";
      } else if (type == ChatMessageType.video) {
        return "Video";
      } else if (type == ChatMessageType.image) {
        return "Image";
      } else {
        return text ?? "";
      }
    }
  }

  String _generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }
}
