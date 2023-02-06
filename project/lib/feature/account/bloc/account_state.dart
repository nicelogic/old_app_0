
part of 'account_bloc.dart';

@JsonSerializable(explicitToJson: true)
class AccountState extends Equatable {
  final Account account;
  final AccountStatus accountStatus;

  const AccountState(
      {this.account = Account.empty, this.accountStatus = AccountStatus.got});

  const AccountState.unknown() : this();

  const AccountState.serverError()
      : this(accountStatus: AccountStatus.serverError);

  const AccountState.got(Account account) : this(account: account);

  @override
  List<Object> get props => [account, accountStatus];

  factory AccountState.fromJson(Map<String, dynamic> json) =>
      _$AccountStateFromJson(json);
  Map<String, dynamic> toJson() => _$AccountStateToJson(this);
}
