import 'dart:async';
import 'dart:developer';

import 'package:app/feature/account/account.dart';
import 'package:app/feature/chat/chat.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:message_repository/message_repository.dart';

part 'message_event.dart';
part 'message_state.dart';
part 'message_bloc.g.dart';

class MessageBloc extends HydratedBloc<MessageEvent, MessageState> {
  final AccountBloc _accountBloc;
  final ChatBloc _chatBloc;
  final MessageRepository _messageRepository;
  late StreamSubscription<AccountState> _accountStreamSubscription;
  StreamSubscription? _messageStreamSubscription;

  MessageBloc(
      {required final MessageRepository messageReposiotry,
      required final ChatBloc chatBloc,
      required final AccountBloc accountBloc})
      : _messageRepository = messageReposiotry,
        _chatBloc = chatBloc,
        _accountBloc = accountBloc,
        super(MessageInitial()) {
    final accountId = _accountBloc.state.account.id;
    if (accountId.isNotEmpty) {
      _messageStreamSubscription = _messageRepository.subscribeNewMessage(
          accountId: accountId, onMessage: onMessage);
    }
    _accountStreamSubscription = _accountBloc.stream.listen((state) {
      _messageStreamSubscription?.cancel();
      final accountId = state.account.id;
      if (accountId.isEmpty) {
        add(MessageLogout());
      } else {
        _messageStreamSubscription = _messageRepository.subscribeNewMessage(
            accountId: accountId, onMessage: onMessage);
      }
    });

    on<GetMessagesEvent>(_onGetMessages, transformer: sequential());
    on<NewSendMessageEvent>(_onNewSendMessage, transformer: sequential());
    on<NewReceivedMessageEvent>(_onNewMessage, transformer: sequential());
    on<MessageLogout>((event, emit) => emit(MessageInitial()),
        transformer: sequential());
  }

  @override
  Future<void> close() {
    _messageStreamSubscription?.cancel();
    _accountStreamSubscription.cancel();
    return super.close();
  }

  onMessage(final MessageWithChatId messageWithChat) {
    _chatBloc.add(
        NewChatOrNewMessageEvent(messageWithChat.id, messageWithChat.message));
    add(NewReceivedMessageEvent(
        chatId: messageWithChat.id, message: messageWithChat.message));
  }

  _onGetMessages(GetMessagesEvent event, Emitter<MessageState> emit) async {
    emit(MessageState(chats: state.chats));

    final chatId = event.chatId;
    final chat = await _messageRepository.getMessages(chatId: chatId);
    final chats = Map<String, Chat>.from(state.chats);
    chats[chat.id] = chat;

    emit(state.copyWith(chats: chats));
  }

  _onNewSendMessage(
      NewSendMessageEvent event, Emitter<MessageState> emit) async {
    await _messageRepository.createMessage(
        accountId: event.message.sender.id,
        chatId: event.chatId,
        text: event.message.text);
    await _onNewMessage(event, emit);
  }

  _onNewMessage(NewMessageEvent event, Emitter<MessageState> emit) async {
    final chatId = event.chatId;
    if (!state.chats.containsKey(chatId)) {
      log('_chatsMessageController not contain chat: $chatId');
      return;
    }

    final chats = Map<String, Chat>.from(state.chats);
    if (!chats.containsKey(chatId)) {
      final cloudChat = await _messageRepository.getChat(chatId: chatId);
      chats[chatId] = cloudChat;
    }
    final chat = chats[chatId]!;
    final messages = List<Message>.from(chat.messages);
    messages.add(event.message);
    final updatedChat = chat.copyWith(messages: messages);
    chats[chatId] = updatedChat;
    final nextState = state.copyWith(chats: chats);
    log('current state messages num: ${state.chats[chatId]!.messages.length}');
    log('next state messages num: ${nextState.chats[chatId]!.messages.length}');
    log('state euqal: ${state == nextState}');
    emit(nextState);
  }

  @override
  MessageState? fromJson(Map<String, dynamic> json) {
    final messageState = MessageState.fromJson(json);
    return messageState;
  }

  @override
  Map<String, dynamic>? toJson(MessageState state) {
    return state.toJson();
  }
}
