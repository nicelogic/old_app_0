part of 'add_contact_bloc.dart';

class AddContactsState extends Equatable {
  final Map<String, Account> _accounts;
  Map<String, Account> get accounts => _accounts;

  const AddContactsState(final Map<String, Account> account)
      : _accounts = account;
       
  @override
  List<Object> get props => [accounts];
}
