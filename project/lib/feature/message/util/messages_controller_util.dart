import 'package:app/feature/message/message.dart';
import 'package:chat_ui_kit/chat_ui_kit.dart';

class MessagesControllerUtil {
  static addMessages(
      {required final MessagesListController messagesController,
      required final List<ChatMessage> messages,
      required final chatId}) {
    List<ChatMessage> updatedMessages = [];
    List<ChatMessage> addedMessages = [];
    for (var message in messages) {
      messagesController.getById(message.id) == null
          ? addedMessages.add(message)
          : updatedMessages.add(message);
    }
    addedMessages = addedMessages.reversed.toList();
    messagesController.insertAll(0, addedMessages);
    // updatedMessages.forEach((element) {
    //   messagesController.updateById(element);
    // });
  }
}
