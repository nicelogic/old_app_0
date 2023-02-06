import 'dart:developer';

import 'package:app/feature/chat/model/model.dart';
import 'package:chat_ui_kit/chat_ui_kit.dart';
import 'package:message_repository/message_repository.dart';

import 'convert.dart';

class ChatsControllerUtil {
  static addChats(
      {required final ChatsListController chatsController,
      required final Map<String, Chat> chats,
      required final accountId}) {
    try {
      if (accountId == '') {
        log('accountId is null, ChatState from json return null');
        return null;
      }

      List<ChatWithMembers> updatedUikitChats = [];
      List<ChatWithMembers> addedUikitChats = [];
      chats.forEach((key, chat) {
        final chatWithMembers =
            toChatWithMembers(chat: chat, accountId: accountId);
        if (chatWithMembers != null) {
          chatsController.getById(chatWithMembers.id) == null
              ? addedUikitChats.add(chatWithMembers)
              : updatedUikitChats.add(chatWithMembers);
        }
      });

      sortFun(ChatWithMembers left, ChatWithMembers right) {
        return left.lastMessage!.creationTimestamp!
            .compareTo(right.lastMessage!.creationTimestamp!);
      }
      addedUikitChats.sort(sortFun);
      updatedUikitChats.sort(sortFun);
      addedUikitChats = addedUikitChats.reversed.toList();
      chatsController.insertAll(0, addedUikitChats);
      for (var element in updatedUikitChats) {
        chatsController.updateById(element);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
