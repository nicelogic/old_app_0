import 'dart:async';

import 'package:app/feature/account/account.dart';
import 'package:app/feature/contact/contact.dart';
import 'package:app/feature/pubsub/bloc/pubsub_bloc.dart';
import 'package:app/config/constant.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:account_repository/account_repository.dart';
import 'package:contacts_repository/contacts_repository.dart';
import 'package:pubsub_repository/pubsub_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact_event.dart';
part 'contact_state.dart';
part 'contact_bloc.g.dart';

class ContactsBloc extends HydratedBloc<ContactsEvent, ContactsState> {
  final AccountRepository _accountRepository;
  final ContactsRepository _contactRepository;
  final PubsubRepository _pubsubRepository;
  final AccountBloc _accountBloc;
  late StreamSubscription<ContactUpdate> _contactEventSubcription;

  ContactsBloc(
      {required AccountRepository accountRepository,
      required ContactsRepository contactRepository,
      required PubsubRepository pubsubRepository,
      required AccountBloc accountBloc})
      : _accountRepository = accountRepository,
        _contactRepository = contactRepository,
        _pubsubRepository = pubsubRepository,
        _accountBloc = accountBloc,
        super(const ContactsState(<Contact>{}, 0)) {
    _accountBloc.stream.listen((event) async {
      if (event.account.id.isNotEmpty) {
        final contacts = await _contactRepository.contact(id: event.account.id);
        add(GetContactsEvent(contacts));
      } else {
        add(ContactsLogout());
      }
    });

    on<GetContactsEvent>(_onGetContacts, transformer: sequential());
    on<UpdateContactsEvent>(_onUpdateContact, transformer: sequential());
    on<AddContactsAck>(_onAddContactAck, transformer: sequential());
    on<ContactsLogout>(
        (event, emit) => emit(const ContactsState(<Contact>{}, 0)),
        transformer: sequential());
  }

  @override
  Future<void> close() {
    _contactEventSubcription.cancel();
    return super.close();
  }

  Future<Set<Contact>> contact({required String id}) async {
    final contacts = await _contactRepository.contact(id: id);
    add(GetContactsEvent(contacts));
    return contacts;
  }

  Future<ContactUpdate> updateContact(
      {required String id, required ContactInput contactInput}) async {
    final contactUpdate = await _contactRepository.updateContact(
        id: id, contactInput: contactInput);
    add(UpdateContactsEvent(contactUpdate));
    return contactUpdate;
  }

  _onGetContacts(GetContactsEvent event, Emitter<ContactsState> emit) async {
    emit(ContactsState(event.contacts, event.contacts.length));
    final id = _accountBloc.state.account.id;
    _pubsubRepository.getPublicationsAndNotify(
        accountId: id, event: kAddContactAck);
  }

  _onUpdateContact(
      UpdateContactsEvent event, Emitter<ContactsState> emit) async {
    if (event.contactUpdate.event == kAddContact) {
      emit(state.add(event.contactUpdate.contact));
    }
  }

  _onAddContactAck(AddContactsAck event, Emitter<ContactsState> emit) async {
    final accountId = event.addContactAck.publication.accountId;
    final account = await _accountRepository.getAccount(accountId);
    emit(state.add(Contact(id: account.id, name: account.name)));

    final id = _accountBloc.state.account.id;
    await _contactRepository.updateContact(
        id: id, contactInput: ContactInput(event: kAddContact, id: account.id));
    await _pubsubRepository.replyPub(
        id: event.addContactAck.publication.id,
        event: kAddContactAck,
        info: '{}',
        state: kPublicationStateClose);
  }

  @override
  ContactsState? fromJson(Map<String, dynamic> json) {
    return ContactsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ContactsState state) => state.toJson();
}
