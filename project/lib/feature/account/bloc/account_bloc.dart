import 'dart:async';
import 'dart:developer';

import 'package:app/feature/account/model/model.dart';
import 'package:app/feature/authentication/authentication.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:account_repository/account_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'account_event.dart';
part 'account_state.dart';
part 'account_bloc.g.dart';

class AccountBloc extends HydratedBloc<AccountEvent, AccountState> {
  final AccountRepository _accountRepository;
  final AuthenticationBloc _authenticationBloc;
  late StreamSubscription _authenticationBlocSubscription;

  AccountBloc(
      {required AccountRepository accountRepository,
      required AuthenticationBloc authenticationBloc})
      : _accountRepository = accountRepository,
        _authenticationBloc = authenticationBloc,
        super(const AccountState()) {
    _authenticationBlocSubscription =
        _authenticationBloc.stream.listen((state) {
      log('receive authentication state stream: $state');
      if (state.status == AuthenticationStatus.unauthenticated) {
        add(const AccountChanged(Account.empty));
      }
    });

    on<AccountRequest>(_onAccountRequest, transformer: sequential());
    on<AccountChanged>(_onAccountChanged, transformer: sequential());
  }

  @override
  Future<void> close() {
    _authenticationBlocSubscription.cancel();
    return super.close();
  }

  Future<Account> me(final String id) async {
    final account = await _accountRepository.me(id);
    add(AccountChanged(account));
    return account;
  }

  Future<Account> createAccount(final String id) async {
    final account = await _accountRepository.createAccount(id);
    add(AccountChanged(account));
    return account;
  }

  Future<Account> updateAccount(
      {required String id, required String info}) async {
    final account = await _accountRepository.updateAccount(id: id, info: info);
    add(AccountChanged(account));
    return account;
  }

  FutureOr<void> _onAccountRequest(
      AccountRequest event, Emitter<AccountState> emit) async {
    try {
      final account = await _accountRepository.getAccount(event._account.id);
      emit(AccountState(account: account));
    } on AccountFailure catch (e) {
      log(e.toString());
      emit(const AccountState.serverError());
    }
  }

  FutureOr<void> _onAccountChanged(
      AccountChanged event, Emitter<AccountState> emit) async {
    emit(AccountState(account: event._account));
  }

  @override
  AccountState fromJson(Map<String, dynamic> json) {
    try {
      return AccountState.fromJson(json);
    } catch (err) {
      return const AccountState.unknown();
    }
  }

  @override
  Map<String, dynamic> toJson(AccountState state) => state.toJson();
}
