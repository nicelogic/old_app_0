import 'models/models.dart';
import 'dart:async';
import 'api/api.dart';

class AccountRepository {
  AccountApiClient _accountApiClient;
  final String _httpUrl;

  AccountRepository({required String httpUrl, required String token})
      : _httpUrl = httpUrl,
        _accountApiClient = AccountApiClient.create(url: httpUrl, token: token);

  void resetApiClient(final String token) {
    _accountApiClient = AccountApiClient.create(url: _httpUrl, token: token);
  }

  Future<Account> getAccount(final String id) async {
    final account = await _accountApiClient.account(id: id);
    return account;
  }

  Future<Account> me(final String id) async {
    final account = await _accountApiClient.account(id: id);
    return account;
  }

  Future<Account> createAccount(final String id) async {
    final account = await _accountApiClient.createAccount(id: id);
    return account;
  }

  Future<Account> updateAccount(
      {required String id, required String info}) async {
    final account = await _accountApiClient.updateAccount(id: id, info: info);
    return account;
  }

  Future<List<Account>> queryAccount({required String idOrName}) async {
    return await _accountApiClient.queryAccount(idOrName: idOrName);
  }
}
