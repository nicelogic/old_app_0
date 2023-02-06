import 'dart:developer';

import 'package:graphql/client.dart';
import 'queries/queries.dart' as queries;
import 'mutations/mutations.dart' as mutations;
import 'subscriptions/subscriptions.dart' as subscriptions;
import '../models/models.dart';
import '../util/util.dart';

class PubSubApiClient {
  final GraphQLClient _gqlClient;
  Stream<QueryResult>? _subscriptionResultStream;

  PubSubApiClient({required GraphQLClient graphQLClient})
      : _gqlClient = graphQLClient;

  factory PubSubApiClient.create(
      {required final String httpUrl,
      required final String wsUrl,
      required final String token}) {
    final httpLink = HttpLink(httpUrl);
    final wsLink =
        WebSocketLink(wsUrl, config: SocketClientConfig(autoReconnect: true));
    //because to establish wss connect to receive subscribe
    // but should after get all thins then subscribe
    //need optimize
    wsLink.connectOrReconnect();

    final authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );
    var link = authLink.concat(httpLink);
    link = Link.split((request) => request.isSubscription, wsLink, link);
    return PubSubApiClient(
        graphQLClient: GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    ));
  }

  Future<List<Publication>> getPublications(
      {required String accountId, required String event}) async {
    final List<Publication> publications = [];
    try {
      log('try to get account($accountId) publications: $event');
      final result = await _gqlClient.query(QueryOptions(
          document: gql(queries.getPubs),
          variables: <String, dynamic>{
            kGetPublicationsAccountId: accountId,
            kGetPublicationsEvent: event
          },
          fetchPolicy: FetchPolicy.networkOnly));
      if (result.hasException) {
        throw PubsubFailure(errorDescribe: result.exception.toString());
      } else if (result.data == null) {
        throw PubsubFailure(errorDescribe: kErrorResultNull);
      }
      final data = result.data![kGetPublications];
      for (final publicationInfo in data) {
        final publication = toPublication(publicationInfo);
        publications.add(publication);
        log('get pubilication: $publication');
      }
    } catch (e) {
      log(e.toString());
      throw PubsubFailure(errorDescribe: e.toString());
    }
    return publications;
  }

  Future<Publication> pub(
      {required String accountId,
      required String targetId,
      required String event,
      required String info,
      required String state}) async {
    try {
      final result = await _gqlClient.mutate(MutationOptions(
          document: gql(mutations.pub),
          variables: <String, dynamic>{
            kPublishAccountId: accountId,
            kPublishTargetId: targetId,
            kPublishEvent: event,
            kPublishInfo: info,
            kPublishState: state
          }));
      if (result.hasException) {
        throw PubsubFailure(errorDescribe: result.exception.toString());
      } else if (result.data == null) {
        throw PubsubFailure(errorDescribe: kErrorResultNull);
      }
      log('publish to($targetId) success');
      final data = result.data![kPublish];
      final publication = toPublication(data);
      return publication;
    } on PubsubFailure {
      rethrow;
    } catch (e) {
      log(e.toString());
      throw PubsubFailure(errorDescribe: e.toString());
    }
  }

  Future<Publication> replyPub(
      {required String id,
      required String event,
      required String info,
      required String state}) async {
    try {
      final result = await _gqlClient.mutate(MutationOptions(
          document: gql(mutations.replyPub),
          variables: <String, dynamic>{
            kReplyPublishId: id,
            kReplyPublishEvent: event,
            kReplyPublishInfo: info,
            kReplyPublishState: state
          }));
      if (result.hasException) {
        throw PubsubFailure(errorDescribe: result.exception.toString());
      } else if (result.data == null) {
        throw PubsubFailure(errorDescribe: kErrorResultNull);
      }
      log('reply ($id) success');
      final data = result.data![kReplyPublish];
      final publication = toPublication(data);
      return publication;
    } on PubsubFailure {
      rethrow;
    } catch (e) {
      log(e.toString());
      throw PubsubFailure(errorDescribe: e.toString());
    }
  }

  void sub(
      {required String accountId,
      required void Function(Publication) onPublication}) async {
    try {
      final gqlDoc = gql(subscriptions.sub);
      _subscriptionResultStream = _gqlClient.subscribe(
          SubscriptionOptions(document: gqlDoc, variables: <String, dynamic>{
        kPublicationReceivedAccountId: accountId,
      }));
      log('begin to listen($accountId)');
      _subscriptionResultStream!.listen((result) {
        if (result.hasException) {
          log(result.exception.toString());
          return;
        }

        if (result.isLoading) {
          log('awaiting results');
          return;
        }
        log('new data: ${result.data}');
        final data = result.data![kPublicationReceived];
        final publication = toPublication(data);
        onPublication(publication);
      });
    } catch (e) {
      log(e.toString());
      throw PubsubFailure(errorDescribe: e.toString());
    }
  }
}
