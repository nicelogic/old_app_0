part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class AccountChanged extends AccountEvent {
  final Account _account;

  const AccountChanged(this._account);

  @override
  List<Object> get props => [_account];
}

class AccountRequest extends AccountEvent {
  const AccountRequest(this._account);

  final Account _account;

  @override
  List<Object> get props => [_account];
}
