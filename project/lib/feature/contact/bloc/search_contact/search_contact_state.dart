part of 'search_contact_bloc.dart';

class SearchContactsState extends Equatable {
  final Set<Contact> _searchContacts;
  Set<Contact> get searchContacts => _searchContacts;
  final Set<Contact> _addContacts;
  Set<Contact> get addContacts => _addContacts;

  const SearchContactsState(
      {Set<Contact> searchContacts = const <Contact>{},
      Set<Contact> addContacts = const <Contact>{}})
      : _searchContacts = searchContacts,
        _addContacts = addContacts;

  const SearchContactsState.initial() : this();

  @override
  List<Object> get props => [_searchContacts, _addContacts];
}
