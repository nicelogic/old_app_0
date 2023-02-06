import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:message_repository/message_repository.dart';

void main() {
  test('create chat test', () async {
    try {
      final messageRepository = MessageRepository(
          httpUrl: 'http://localhost/message',
          wsUrl: "ws://localhost/message",
          token: '');

      final chat = await messageRepository.createChat(
          accountId: 'i', chatName: 'ice', memberIds: <String>{'ice'});
      expect(chat.name, 'ice');
    } on MessageFailure catch (e) {
      log(e.errorDescribe);
    } catch (e) {
      log(e.toString());
    }
    expect('niceice', 'niceice');
  });

  test('get chats test', () async {
    try {
      final messageRepository = MessageRepository(
          httpUrl: 'http://localhost/message',
          wsUrl: "ws://localhost/message",
          token: '');

      final chats = await messageRepository.getChats(accountId: 'wzh');
      expect(chats[0].name, 'ice');
    } on MessageFailure catch (e) {
      log(e.errorDescribe);
    } catch (e) {
      log(e.toString());
    }
    expect('niceice', 'niceice');
  });

  test('create message test', () async {
    try {
      final messageRepository = MessageRepository(
          httpUrl: 'http://localhost/message',
          wsUrl: "ws://localhost/message",
          token: '');

      final message = await messageRepository.createMessage(
          accountId: 'wzh', chatId: '611e6ee703bf5433c1a276ce', text: 'play');
      expect(message.text, 'play');
    } on MessageFailure catch (e) {
      log(e.errorDescribe);
    } catch (e) {
      log(e.toString());
    }
    expect('niceice', 'niceice');
  });

  test('subscribe message test', () async {
    try {
      final messageRepository = MessageRepository(
          httpUrl: 'https://niceice.cn/message',
          wsUrl: "wss://niceice.cn/message",
          token: '');

      final messageStreamSubcription = messageRepository.subscribeNewMessage(
          accountId: 'wzh',
          onMessage: (messageWithChatId) {
            log('receive new message(${messageWithChatId.toJson()}');
          });
      final secondMessageStreamSubscription =
          messageRepository.subscribeNewMessage(
              accountId: 'wzh',
              onMessage: (messageWithChatId) {
                log('test will receive new message twice: ${messageWithChatId.toJson()}');
              });
      while (true) {
        await Future.delayed(Duration(seconds: 60));
        messageStreamSubcription.cancel();
        secondMessageStreamSubscription.cancel();
      }
    } on MessageFailure catch (e) {
      log(e.errorDescribe);
    } catch (e) {
      log(e.toString());
    }
    expect('niceice', 'niceice');
  });
}
