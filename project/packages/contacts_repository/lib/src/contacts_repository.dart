import 'package:account_repository/account_repository.dart';
import 'model/model.dart';
import 'dart:async';
import 'api/api.dart';

class ContactsRepository {
  final AccountRepository _accountRepository;
  ContactApiClient _apiClient;
  final String _httpUrl;

  ContactsRepository(
      {required AccountRepository accountRepository,
      required String httpUrl,
      required String token})
      : _accountRepository = accountRepository,
        _httpUrl = httpUrl,
        _apiClient = ContactApiClient.create(url: httpUrl, token: token);

  void resetApiClient(final String token) {
    _apiClient = ContactApiClient.create(url: _httpUrl, token: token);
  }

  Future<Set<Contact>> contact({required String id}) async {
    final contactIds = await _apiClient.contact(id: id);
    final contacts = <Contact>{};
    for (final id in contactIds) {
      final account = await _accountRepository.getAccount(id);
      contacts.add(Contact(id: account.id, name: account.name));
    }
    return contacts;
  }

  Future<ContactUpdate> updateContact(
      {required String id, required ContactInput contactInput}) async {
    await _apiClient.updateContact(id: id, contactInput: contactInput);
    final account = await _accountRepository.getAccount(contactInput.id);
    final contactUpdate = ContactUpdate(
        contact: Contact(id: account.id, name: account.name),
        event: contactInput.event);
    return contactUpdate;
  }
}
