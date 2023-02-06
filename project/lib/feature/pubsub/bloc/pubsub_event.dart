part of 'pubsub_bloc.dart';

abstract class PubsubEvent extends Equatable {
  final Publication _publication;
  Publication get publication => _publication;

  const PubsubEvent(final Publication publication) : _publication = publication;

  @override
  List<Object> get props => [_publication];
}

class PubsubAddContactReq extends PubsubEvent {
  const PubsubAddContactReq(Publication publication) : super(publication);
}

class PubsubAddContactAck extends PubsubEvent {
  const PubsubAddContactAck(Publication publication) : super(publication);
}

