import 'dart:async';

import 'api/api.dart';
import 'model/model.dart';

class MessageRepository {
  ApiClient _apiClient;
  final String _httpUrl;
  final String _wsUrl;

  MessageRepository(
      {required String httpUrl, required String wsUrl, required String token})
      : _httpUrl = httpUrl,
        _wsUrl = wsUrl,
        _apiClient =
            ApiClient.create(httpUrl: httpUrl, wsUrl: wsUrl, token: token);

  void resetApiClient(final String token) {
    _apiClient =
        ApiClient.create(httpUrl: _httpUrl, wsUrl: _wsUrl, token: token);
  }

  Future<Chat> createChat(
      {required final String accountId,
      required final String chatName,
      required final Set<String> memberIds}) async {
    final chat = await _apiClient.createChat(
        accountId: accountId, chatName: chatName, memberIds: memberIds);
    return chat;
  }

  Future<List<Chat>> getChats({required final String accountId}) async {
    final chats = await _apiClient.getChats(accountId: accountId);
    return chats;
  }

  Future<Chat> getChat({required final String chatId}) async {
    final chat = await _apiClient.getChat(chatId: chatId);
    return chat;
  }

  Future<Message> createMessage(
      {required final String accountId,
      required final String chatId,
      required final String text}) async {
    final message = await _apiClient.createMessage(
        accountId: accountId, chatId: chatId, text: text);
    return message;
  }

  Future<Chat> getMessages({required final String chatId}) async {
    final chat = await _apiClient.getMessages(chatId: chatId);
    return chat;
  }

  StreamSubscription subscribeNewMessage(
      {required final String accountId,
      required void Function(MessageWithChatId) onMessage}) {
    return _apiClient.subscribeNewMessage(accountId: accountId, onMessage: onMessage);
  }
}
