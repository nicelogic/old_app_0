import '../models/models.dart';

Publication toPublication(final dynamic data) {
  final publication = Publication(
      id: data['_id'],
      accountId: data['accountId'],
      targetId: data['targetId'],
      event: data['event'],
      info: data['info'],
      state: data['state'],
      replyEvent: data['replyEvent'],
      replyInfo: data['replyInfo']);
  return publication;
}
