import 'package:chat_ui_kit/chat_ui_kit.dart';

import 'package:app/feature/message/message.dart';
import 'chat_user.dart';

class UikitChat {
  String? id; //usually a UUID
  String? name;
  String? ownerId;
  int unreadCount;

  UikitChat({this.id, this.name, this.ownerId, this.unreadCount = 0});
}

class ChatWithMembers extends ChatBase {
  UikitChat? chat;
  @override
  List<ChatUser> members;
  @override
  ChatMessage? lastMessage;

  ChatWithMembers({this.chat, required this.members, this.lastMessage});

  @override
  int get unreadCount => chat?.unreadCount ?? 0;

  @override
  String get name {
    final _name = (chat?.name);
    if (_name != null && _name.isNotEmpty) return chat!.name!;
    return membersWithoutSelf.map((e) => e.name).toList().join(", ");
  }

  @override
  String get id => chat?.id ?? "";

  List<ChatUser> get membersWithoutSelf {
    List<ChatUser> membersWithoutSelf = [];
    for (ChatUser chatUser in members) {
      membersWithoutSelf.add(chatUser);
    }
    return membersWithoutSelf;
  }

  bool get isGroupChat => members.length > 2;
}
