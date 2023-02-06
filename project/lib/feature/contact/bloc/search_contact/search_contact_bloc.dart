import 'package:app/feature/account/account.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:account_repository/account_repository.dart';
import 'package:contacts_repository/contacts_repository.dart';

part 'search_contact_event.dart';
part 'search_contact_state.dart';

class SearchContactsBloc
    extends Bloc<SearchContactsEvent, SearchContactsState> {
  final AccountRepository _accountRepository;
  final AccountBloc _accountBloc;
  SearchContactsBloc(
      {required AccountRepository accountRepository,
      required AccountBloc accountBloc})
      : _accountRepository = accountRepository,
        _accountBloc = accountBloc,
        super(const SearchContactsState.initial()) {
    _accountBloc.stream.listen((accountState) async {
      if (accountState.account.id.isEmpty) {
        add(SearchContactsLogout());
      }
    });
    on<SearchContacts>(_onSearchContact, transformer: sequential());
    on<SearchContactsLogout>(
        (event, emit) => emit(const SearchContactsState.initial()),
        transformer: sequential());
  }

  _onSearchContact(
      SearchContacts event, Emitter<SearchContactsState> emit) async {
    final key = event.key;
    final accounts = await _accountRepository.queryAccount(idOrName: key);
    Set<Contact> contacts = <Contact>{};
    for (final account in accounts) {
      contacts.add(Contact(id: account.id, name: account.name));
    }
    emit(SearchContactsState(searchContacts: contacts));
  }
}
