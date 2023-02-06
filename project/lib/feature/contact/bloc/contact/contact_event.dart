part of 'contact_bloc.dart';

abstract class ContactsEvent extends Equatable {
  const ContactsEvent();

  @override
  List<Object> get props => [];
}

class GetContactsEvent extends ContactsEvent {
  final Set<Contact> _contacts;
  Set<Contact> get contacts => _contacts;

  const GetContactsEvent(Set<Contact> contacts) : _contacts = contacts;

  @override
  List<Object> get props => [_contacts];
}

class UpdateContactsEvent extends ContactsEvent {
  final ContactUpdate _contactUpdate;
  ContactUpdate get contactUpdate => _contactUpdate;

  const UpdateContactsEvent(ContactUpdate contactUpdate)
      : _contactUpdate = contactUpdate;

  @override
  List<Object> get props => [_contactUpdate];
}

class AddContactsAck extends ContactsEvent {
  final PubsubAddContactAck _addContactAck;
  PubsubAddContactAck get addContactAck => _addContactAck;

  const AddContactsAck(final PubsubAddContactAck addContactAck)
      : _addContactAck = addContactAck;

  @override
  List<Object> get props => [_addContactAck];
}

class ContactsLogout extends ContactsEvent {}
