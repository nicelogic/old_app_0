import 'package:account_repository/account_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('get account from graphql server', () async {
    try {
      final accountRepository =
          AccountRepository(httpUrl: 'http://127.0.0.1/test', token: '');
      final accountList = await accountRepository.queryAccount(idOrName: '1');
      for(final account in accountList){
        print(account.toJson());
      }
    } on AccountFailure catch (e) {
      print(e.errorDescribe);
    }

    expect('niceice', 'niceice');
  });
}
