import 'package:app/feature/account/account.dart';
import 'package:app/feature/contact/contact.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:app/feature/pubsub/pubsub_bloc.dart';
import 'package:account_repository/account_repository.dart';
import 'package:pubsub_repository/pubsub_repository.dart';

part 'add_contact_event.dart';
part 'add_contact_state.dart';

class AddContactsBloc extends Bloc<AddContactsEvent, AddContactsState> {
  final AccountRepository _accountRepository;
  final PubsubRepository _pubsubRepository;
  final AccountBloc _accountBloc;
  AddContactsBloc(
      {required AccountRepository accountRepository,
      required PubsubRepository pubsubRepository,
      required AccountBloc accountBloc})
      : _accountRepository = accountRepository,
        _pubsubRepository = pubsubRepository,
        _accountBloc = accountBloc,
        super(const AddContactsState({})) {
    _accountBloc.stream.listen((event) async {
      if (event.account.id.isNotEmpty) {
        _pubsubRepository.getPublicationsAndNotify(
            accountId: event.account.id, event: kAddContactReq);
      } else {
        add(AddContactsLogout());
      }
    });
    on<AddContactsReq>(_onAddContacts, transformer: sequential());
    on<DelContacts>(_onDelContacts, transformer: sequential());
    on<AddContactsLogout>((event, emit) => emit(const AddContactsState({})),
        transformer: sequential());
  }

  _onAddContacts(AddContactsReq event, Emitter<AddContactsState> emit) async {
    final accountId = event.addContactEvent.publication.accountId;
    if (accountId.isEmpty) {
      return;
    }
    final account = await _accountRepository.getAccount(accountId);
    final accounts = Map<String, Account>.from(state.accounts);
    accounts[event.addContactEvent.publication.id] = account;
    emit(AddContactsState(accounts));
  }

  _onDelContacts(DelContacts event, Emitter<AddContactsState> emit) async {
    final accounts = Map<String, Account>.from(state.accounts);
    accounts.remove(event.publicationId);
    emit(AddContactsState(accounts));
  }
}
