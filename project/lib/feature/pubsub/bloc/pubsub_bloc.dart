import 'dart:async';
import 'dart:developer';

import 'package:app/feature/contact/contact.dart';
import 'package:equatable/equatable.dart';
import 'package:pubsub_repository/pubsub_repository.dart';
import 'package:app/feature/account/account.dart';
import 'package:bloc/bloc.dart';

part 'pubsub_event.dart';
part 'pubsub_state.dart';

class PubsubBloc extends Bloc<PubsubEvent, PubsubState> {
  final PubsubRepository _pubsubRepository;
  final AccountBloc _accountBloc;
  AddContactsBloc? _addContactBloc;
  final ContactsBloc _contactBloc;
  late StreamSubscription<Publication> _publicationStreamSubscription;
  late StreamSubscription<AccountState> _accountStreamSubscription;
  PubsubBloc(
      {required PubsubRepository pubsubRepository,
      required AccountBloc accountBloc,
      required ContactsBloc contactBloc,
      AddContactsBloc? addContactBloc})
      : _pubsubRepository = pubsubRepository,
        _accountBloc = accountBloc,
        _contactBloc = contactBloc,
        _addContactBloc = addContactBloc,
        super(PubsubInitial()) {
    final accountId = _accountBloc.state.account.id;
    if (accountId.isNotEmpty) {
      _pubsubRepository.sub(
          accountId: accountId, onPublication: handlePublication);
    }
    _accountStreamSubscription = _accountBloc.stream.listen((state) {
      final accountId = state.account.id;
      if (accountId.isNotEmpty) {
        _pubsubRepository.sub(
            accountId: accountId, onPublication: handlePublication);
      }
    });

    _publicationStreamSubscription =
        _pubsubRepository.publicationStream.listen((publication) {
      handlePublication(publication);
    });
    on<PubsubAddContactReq>((event, emit) {
      _addContactBloc?.add(AddContactsReq(event));
    });
    on<PubsubAddContactAck>((event, emit) {
      _contactBloc.add(AddContactsAck(event));
    });
  }

  @override
  Future<void> close() {
    _accountStreamSubscription.cancel();
    _publicationStreamSubscription.cancel();
    return super.close();
  }

  handlePublication(final Publication publication) {
    log('pubsubBloc receive event: ${publication.event}');
    if (publication.event == kAddContactReq) {
      add(PubsubAddContactReq(publication));
    } else if (publication.event == kAddContactAck) {
      add(PubsubAddContactAck(publication));
    }
  }

  setAddContactBloc(AddContactsBloc addContactBloc) {
    _addContactBloc = addContactBloc;
  }
}
