import 'dart:async';
import 'dart:developer';

import 'package:graphql/client.dart';
import '../model/model.dart';
import 'mutation/mutation.dart' as mutation;
import 'query/query.dart' as query;
import 'subscription/subscription.dart' as subscription;

class ApiClient {
  final GraphQLClient _gqlClient;

  ApiClient({required GraphQLClient graphQLClient})
      : _gqlClient = graphQLClient;

  factory ApiClient.create(
      {required final String httpUrl,
      required final String wsUrl,
      required final String token}) {
    final httpLink = HttpLink(httpUrl);
    final wsLink =
        WebSocketLink(wsUrl, config: SocketClientConfig(autoReconnect: true));
    wsLink.connectOrReconnect();

    final authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );
    var link = authLink.concat(httpLink);
    link = Link.split((request) => request.isSubscription, wsLink, link);
    return ApiClient(
        graphQLClient: GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    ));
  }

  Future<Chat> createChat(
      {required final String accountId,
      required final String chatName,
      required final Set<String> memberIds}) async {
    final result = await _gqlClient.mutate(MutationOptions(
        document: gql(mutation.createChat),
        variables: <String, dynamic>{
          kCreateChatAccountId: accountId,
          kCreateChatName: chatName,
          kCreateChatMemberIds: memberIds.toList(),
        }));
    if (result.hasException) {
      throw MessageFailure(errorDescribe: result.exception.toString());
    } else if (result.data == null) {
      throw MessageFailure(errorDescribe: kErrorResultNull);
    }
    log('create chat ($chatName) success');
    final data = result.data![kCreateChat];
    log('data is ($data)');
    final chat = Chat.fromJson(data);
    return chat;
  }

  Future<List<Chat>> getChats({required final String accountId}) async {
    final List<Chat> chats = [];
    if (accountId.isEmpty) {
      return chats;
    }

    log('try to get account($accountId) chats');
    final result = await _gqlClient.query(QueryOptions(
        document: gql(query.getChats),
        variables: <String, dynamic>{
          kGetChatsAccountId: accountId,
        },
        fetchPolicy: FetchPolicy.networkOnly));
    if (result.hasException) {
      throw MessageFailure(errorDescribe: result.exception.toString());
    } else if (result.data == null) {
      throw MessageFailure(errorDescribe: kErrorResultNull);
    }
    final data = result.data![kGetChats];
    for (final chatData in data) {
      final chat = Chat.fromJson(chatData);
      chats.add(chat);
      log('api client getchats: get chat: ${chat.toJson()}');
    }
    return chats;
  }

  Future<Chat> getChat({required final String chatId}) async {
    try {
      log('try to get account($chatId) chats');
      final result = await _gqlClient.query(QueryOptions(
          document: gql(query.getChat),
          variables: <String, dynamic>{
            kGetChatChatId: chatId,
          },
          fetchPolicy: FetchPolicy.networkOnly));
      if (result.hasException) {
        throw MessageFailure(errorDescribe: result.exception.toString());
      } else if (result.data == null) {
        throw MessageFailure(errorDescribe: kErrorResultNull);
      }
      final data = result.data![kGetChat];
      final chat = Chat.fromJson(data);
      return chat;
    } catch (e) {
      log(e.toString());
      throw MessageFailure(errorDescribe: e.toString());
    }
  }

  Future<Message> createMessage(
      {required final String accountId,
      required final String chatId,
      required final String text}) async {
    final result = await _gqlClient.mutate(MutationOptions(
        document: gql(mutation.createMessage),
        variables: <String, dynamic>{
          kCreateMessageAccountId: accountId,
          kCreateMessageChatId: chatId,
          kCreateMessageText: text,
        }));
    if (result.hasException) {
      throw MessageFailure(errorDescribe: result.exception.toString());
    } else if (result.data == null) {
      throw MessageFailure(errorDescribe: kErrorResultNull);
    }
    log('create chat($chatId) msg success');
    final data = result.data![kCreateMessage];
    final message = Message.fromJson(data);
    return message;
  }

  Future<Chat> getMessages({required final String chatId}) async {
    try {
      log('try to get chat($chatId) messages');
      final result = await _gqlClient.query(QueryOptions(
          document: gql(query.getMessages),
          variables: <String, dynamic>{
            kGetMessagesChatId: chatId,
          },
          fetchPolicy: FetchPolicy.networkOnly));
      if (result.hasException) {
        throw MessageFailure(errorDescribe: result.exception.toString());
      } else if (result.data == null) {
        throw MessageFailure(errorDescribe: kErrorResultNull);
      }
      final data = result.data![kGetMessages];
      final chat = Chat.fromJson(data);
      return chat;
    } catch (e) {
      log(e.toString());
      throw MessageFailure(errorDescribe: e.toString());
    }
  }

  StreamSubscription subscribeNewMessage(
      {required String accountId,
      required void Function(MessageWithChatId) onMessage}) {
    try {
      final gqlDoc = gql(subscription.subscribeNewMessage);
      final subscriptionResultStream = _gqlClient.subscribe(
          SubscriptionOptions(document: gqlDoc, variables: <String, dynamic>{
        kNewMessageReceivedAccountId: accountId,
      }));
      log('begin to listen(chat: $accountId) message');
      final messageStreamSubscription =
          subscriptionResultStream.listen((result) {
        if (result.hasException) {
          log(result.exception.toString());
          return;
        }

        if (result.isLoading) {
          log('awaiting results');
          return;
        }
        log('new data: ${result.data}');
        final data = result.data![kNewMessageReceived];
        final messageWithChatId = MessageWithChatId.fromJson(data);
        onMessage(messageWithChatId);
      });
      return messageStreamSubscription;
    } catch (e) {
      log(e.toString());
      throw MessageFailure(errorDescribe: e.toString());
    }
  }
}
