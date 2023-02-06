import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:pubsub_repository/pubsub_repository.dart';

void main() {
  test('pubsub graphql test', () async {
    try {
      // final httpLink = HttpLink('https://niceice.cn/pubsub');
      // final wsLink = WebSocketLink('wss://niceice.cn/pubsub',
      //     config: SocketClientConfig(autoReconnect: true));
      // // wsLink.connectOrReconnect();

      // final authLink = AuthLink(
      //   getToken: () async => 'Bearer ',
      // );
      // var link = authLink.concat(httpLink);
      // link =
      //     Link.split((request) => request.isSubscription, wsLink, link);
      // final client = GraphQLClient(
      //   cache: GraphQLCache(),
      //   link: link,
      // );
      while (true) {
        log('sleep');
        await Future.delayed(Duration(seconds: 10));
      }
    } on PubsubFailure catch (e) {
      log(e.errorDescribe);
    }
    expect('niceice', 'niceice');
  });

  test('pubsub sub test', () async {
    try {
      final pubsubRepository = PubsubRepository(
          httpUrl: 'http://127.0.0.1:4000/graphql',
          wsUrl: "ws://127.0.0.1:4000/graphql",
          token: '');
      pubsubRepository.sub(
          accountId: '88',
          onPublication: (publication) {
            log('receive publication(${publication.id}');
          });

      while (true) {
        await Future.delayed(Duration(seconds: 10));
      }
    } on PubsubFailure catch (e) {
      log(e.errorDescribe);
    }
    expect('niceice', 'niceice');
  });

  test('pubsub pub test', () async {
    try {
      final pubsubRepository = PubsubRepository(
          httpUrl: 'http://127.0.0.1:4000/graphql',
          wsUrl: "ws://127.0.0.1:4000/graphql",
          token: '');

      await pubsubRepository.pub(
          accountId: '1',
          targetId: '2',
          event: 'add_contact_req',
          info: '{}',
          state: 'create');
    } on PubsubFailure catch (e) {
      log(e.errorDescribe);
    }
    expect('niceice', 'niceice');
  });

  test('pubsub query test', () async {
    try {
      final pubsubRepository = PubsubRepository(
          httpUrl: 'https://api.github.com/graphql',
          wsUrl: "wss://1.15.174.162/pubsub",
          token: '');
      final publications = await pubsubRepository.getPublicationsAndNotify(
          accountId: 'wzh', event: 'add_contact_req');
      for (final publication in publications) {
        log(publication.toString());
      }
    } on PubsubFailure catch (e) {
      log(e.errorDescribe);
    }
    expect('niceice', 'niceice');
  });
}
