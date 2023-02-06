import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:account_repository/account_repository.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

void main() async {
  // TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  final token = await testAuthGql();
  await testAccountGql(token);
}

Future<String> testAuthGql() async {
  final authenticationRepository =
      AuthenticationRepository(url: 'https://niceice.cn/auth');
  const String userName = '';
  final result = await authenticationRepository.signUpWithUserName(
      userName: userName, password: '123');
  log(result.result);
  log(result.token);
  return result.token;
}

Future<void> testAccountGql(final String token) async {
  final accountRepository =
      AccountRepository(httpUrl: 'http://localhost', token: "");
  accountRepository.resetApiClient(token);
  Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
  final id = decodedToken['id'];
  try {
    final result = await accountRepository.getAccount(id);
    log(result.id);
    log(result.name);
  } on AccountFailure catch (e) {
    log(e.errorDescribe);
  }

  // final _httpLink = HttpLink('https://niceice.cn/account');
  // final link = Link.from([_httpLink]);
  // final client = GraphQLClient(
  //   cache: GraphQLCache(),
  //   link: link,
  // );

  // final gqlStr = getAccount(id);
  // log(gqlStr);
  // final result = await client.query(QueryOptions(document: gql(gqlStr)));
  // log(result.toString());
}
