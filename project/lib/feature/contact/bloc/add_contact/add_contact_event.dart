part of 'add_contact_bloc.dart';

abstract class AddContactsEvent extends Equatable {
  const AddContactsEvent();

  @override
  List<Object> get props => [];
}

class AddContactsReq extends AddContactsEvent {
  final PubsubAddContactReq _addContactEvent;
  PubsubAddContactReq get addContactEvent => _addContactEvent;

  const AddContactsReq(final PubsubAddContactReq addContactEvent)
      : _addContactEvent = addContactEvent;

  @override
  List<Object> get props => [_addContactEvent];
}

class DelContacts extends AddContactsEvent {
  final String _publicationId;
  String get publicationId => _publicationId;

  const DelContacts(final String publicationId) : _publicationId = publicationId;

  @override
  List<Object> get props => [_publicationId];
}

class AddContactsLogout extends AddContactsEvent {}
