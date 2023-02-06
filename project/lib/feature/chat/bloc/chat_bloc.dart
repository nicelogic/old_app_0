import 'dart:async';

import 'package:app/feature/account/bloc/account_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:message_repository/message_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';
part 'chat_bloc.g.dart';

class ChatBloc extends HydratedBloc<ChatEvent, ChatState> {
  final AccountBloc _accountBloc;
  final MessageRepository _messageRepository;
  late StreamSubscription<AccountState> _accountStreamSubscription;
  ChatBloc(
      {required final MessageRepository messageReposiotry,
      required final AccountBloc accountBloc})
      : _messageRepository = messageReposiotry,
        _accountBloc = accountBloc,
        super(ChatInitial()) {
    _accountBloc.stream.listen((accountState) async {
      if (accountState.account.id.isNotEmpty) {
        add(GetChatsEvent(accountState.account.id));
      } else {
        add(ChatLogout());
      }
    });
    on<GetChatsEvent>(_onGetChats, transformer: sequential());
    on<NewChatOrNewMessageEvent>(_onNewChatOrNewMessage,
        transformer: sequential());
    on<ChatLogout>((event, emit) => emit(ChatInitial()),
        transformer: sequential());
  }

  @override
  Future<void> close() {
    _accountStreamSubscription.cancel();
    return super.close();
  }

  _onGetChats(GetChatsEvent event, Emitter<ChatState> emit) async {
    final persistentChats = state.chats;
    emit(ChatState(chats: persistentChats));

    final chatList =
        await _messageRepository.getChats(accountId: event.accountId);
    final chats = {for (var chat in chatList) chat.id: chat};

    emit(ChatState(chats: chats));
  }

  _onNewChatOrNewMessage(
      NewChatOrNewMessageEvent event, Emitter<ChatState> emit) async {
    final chatId = event.chatId;
    final isExistChat = state.chats.containsKey(chatId);
    if (isExistChat) {
      final chats = Map<String, Chat>.from(state.chats);
      chats[chatId] = chats[chatId]!.copyWith(lastMessage: event.message);
      emit(ChatState(
          chats: chats,
          lastMessageWithChatIdForNotification:
              MessageWithChatId(message: event.message, id: chatId)));
    } else {
      final newChats = Map<String, Chat>.from(state.chats);
      final chat = await _messageRepository.getChat(chatId: chatId);
      newChats[chatId] = chat;
      emit(ChatState(
          chats: newChats,
          lastMessageWithChatIdForNotification:
              MessageWithChatId(message: event.message, id: chatId)));
    }
  }

  @override
  ChatState? fromJson(Map<String, dynamic> json) {
    final chatState = ChatState.fromJson(json);

    return chatState;
  }

  @override
  Map<String, dynamic>? toJson(ChatState state) {
    return state.toJson();
  }
}
