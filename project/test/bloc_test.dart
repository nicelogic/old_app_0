import 'dart:developer';
import 'package:app/feature/message/message.dart';
import 'package:contacts_repository/contacts_repository.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:message_repository/message_repository.dart';

void main() {
  test('bloc equatable map test', () async {
    const state = MessageState(chats: <String, Chat>{});
    const chatId = 'a';
    final chat2 = Chat(
        id: '',
        name: '',
        members: const <Contact>{},
        messages: const [],
        lastMessage: const Message.empty());
    final chat = Chat(
        id: '',
        name: '',
        members: const <Contact>{},
        messages: const [],
        lastMessage: const Message.empty());
    state.chats[chatId] = chat2;
    final messages = chat.messages;
    messages.add(
        const Message(date: '', id: '', text: '', sender: Contact(id: '', name: '')));
    final updatedChat = chat.copyWith(messages: messages);
    final chats = Map<String, Chat>.from(state.chats);
    chats[chatId] = updatedChat;
    final nextState = state.copyWith(chats: chats);
    log('state messages num: ${state.chats[chatId]!.messages.length}');
    log('nextstate messages num: ${nextState.chats[chatId]!.messages.length}');

    // final aState = MessageState(chats: <String, Chat>{});
    // aState.chats['a'] = Chat(
    //     id: '', name: '', members: <Contact>{}, lastMessage: '', messages: []);
    // aState.chats['a'] = aState.chats['a']!.copyWith(lastMessage: 'hi');
    // final chats =
    // final bState = aState.copyWith(chats: );

    log('${state == nextState}');
    expect(state, nextState);
  });

  test('bloc equatable simple map test', () async {
    Map<String, Chat> aMap = {};
    aMap['a'] = Chat(
        id: '',
        name: '',
        members: const <Contact>{},
        messages: const [],
        lastMessage: const Message.empty());
    Map<String, Chat> bMap = {};
    bMap['a'] = Chat(
        id: '',
        name: '',
        members: const <Contact>{},
        messages: const [],
        lastMessage:
            const Message(id: '1', text: '', sender: Contact.empty(), date: ''));

    expect(aMap, bMap);
  });

  test('bloc equatable list test', () async {
    List<String> aList = [];
    aList.add('value');
    List<String> bList = [];
    bList.add('valu');

    expect(aList, bList);
  });
}
