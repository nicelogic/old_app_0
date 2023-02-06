part of 'search_contact_bloc.dart';

abstract class SearchContactsEvent extends Equatable {
  const SearchContactsEvent();

  @override
  List<Object> get props => [];
}

class SearchContacts extends SearchContactsEvent {
  final String _key;
  String get key => _key;

  const SearchContacts({required final String key}) : _key = key;

  @override
  List<Object> get props => [_key];
}

class SearchContactsLogout extends SearchContactsEvent {}


