import 'package:pubsub_repository/src/models/publication.dart';
import 'dart:async';
import 'api/api.dart';

class PubsubRepository {
  PubSubApiClient _apiClient;
  final String _httpUrl;
  final String _wsUrl;
  StreamController<Publication> _publicationStreamController =
      StreamController<Publication>.broadcast();
  Stream<Publication> get publicationStream =>
      _publicationStreamController.stream;

  PubsubRepository(
      {required String httpUrl, required String wsUrl, required String token})
      : _httpUrl = httpUrl,
        _wsUrl = wsUrl,
        _apiClient = PubSubApiClient.create(
            httpUrl: httpUrl, wsUrl: wsUrl, token: token);

  void resetApiClient(final String token) {
    _apiClient =
        PubSubApiClient.create(httpUrl: _httpUrl, wsUrl: _wsUrl, token: token);
  }

  Future<List<Publication>> getPublicationsAndNotify(
      {required String accountId, required String event}) async {
    final publications =
        await getPublications(accountId: accountId, event: event);
    for (final publication in publications) {
      _publicationStreamController.add(publication);
    }
    return publications;
  }

  Future<List<Publication>> getPublications(
      {required String accountId, required String event}) async {
    final publications =
        await _apiClient.getPublications(accountId: accountId, event: event);
    return publications;
  }

  Future<Publication> pub(
      {required String accountId,
      required String targetId,
      required String event,
      required String info,
      required String state}) async {
    final publication = await _apiClient.pub(
        accountId: accountId,
        targetId: targetId,
        event: event,
        info: info,
        state: state);
    return publication;
  }

  Future<Publication> replyPub(
      {required String id,
      required String event,
      required String info,
      required String state}) async {
    final publication = await _apiClient.replyPub(
        id: id, event: event, info: info, state: state);
    return publication;
  }

  void sub(
      {required String accountId,
      required void Function(Publication) onPublication}) {
    _apiClient.sub(accountId: accountId, onPublication: onPublication);
  }
}
