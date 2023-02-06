import 'dart:convert';
import 'dart:developer';

import 'package:account_repository/src/models/models.dart';
import 'package:graphql/client.dart';
import 'queries/queries.dart' as queries;
import 'mutations/mutations.dart' as mutations;
import '../constant/constant.dart';

class AccountApiClient {
  final GraphQLClient _graphQLClient;

  const AccountApiClient({required GraphQLClient graphQLClient})
      : _graphQLClient = graphQLClient;

  factory AccountApiClient.create(
      {required final String url, required final String token}) {
    final _httpLink = HttpLink(url);
    final _authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );

    Link _link = _authLink.concat(_httpLink);
    return AccountApiClient(
        graphQLClient: GraphQLClient(
      cache: GraphQLCache(),
      link: _link,
    ));
  }

  Future<Account> account({required String id}) async {
    try {
      final result = await _graphQLClient.query(QueryOptions(
        document: gql(queries.getAccount),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: <String, dynamic>{kId: id},
      ));
      if (result.hasException) {
        final errorDescribe = result.exception.toString();
        final isUserNotExist = errorDescribe.indexOf(kUserNotExist) != -1;
        final errorCode = isUserNotExist
            ? AccountErrorCode.UserUndefined
            : AccountErrorCode.Undefined;
        throw AccountFailure(
            errorDescribe: result.exception.toString(), errorCode: errorCode);
      } else if (result.data == null) {
        throw AccountFailure(errorDescribe: kErrorResultNull);
      }

      final data = result.data![kAccount][kInfo];
      final accountJson = jsonDecode(data);
      return Account.fromJson(accountJson);
    } on AccountFailure {
      rethrow;
    } catch (e) {
      log(e.toString());
      throw AccountFailure(errorDescribe: e.toString());
    }
  }

  Future<Account> createAccount({required String id}) async {
    try {
      final accountInfo = '{"id": "$id"}';
      final result = await _graphQLClient.mutate(MutationOptions(
          document: gql(mutations.createAccount),
          variables: <String, dynamic>{kId: id, kInfo: accountInfo}));
      if (result.hasException) {
        throw AccountFailure(errorDescribe: result.exception.toString());
      } else if (result.data == null) {
        throw AccountFailure(errorDescribe: kErrorResultNull);
      }

      final data = result.data![kCreateAccount][kInfo];
      final accountJson = jsonDecode(data);
      return Account.fromJson(accountJson);
    } on AccountFailure {
      rethrow;
    } catch (e) {
      log(e.toString());
      throw AccountFailure(errorDescribe: e.toString());
    }
  }

  Future<Account> updateAccount(
      {required String id, required String info}) async {
    try {
      final result = await _graphQLClient.mutate(MutationOptions(
          document: gql(mutations.updateAccount),
          variables: <String, dynamic>{
            kId: id,
            kInfo: info,
          }));
      if (result.hasException) {
        final errorDescribe = result.exception.toString();
        final isUserNotExist = errorDescribe.indexOf(kUserNotExist) != -1;
        final errorCode = isUserNotExist
            ? AccountErrorCode.UserUndefined
            : AccountErrorCode.Undefined;
        throw AccountFailure(
            errorDescribe: result.exception.toString(), errorCode: errorCode);
      } else if (result.data == null) {
        throw AccountFailure(errorDescribe: kErrorResultNull);
      }

      final data = result.data![kUpdateAccount][kInfo];
      final accountJson = jsonDecode(data);
      return Account.fromJson(accountJson);
    } on AccountFailure {
      rethrow;
    } catch (e) {
      log(e.toString());
      throw AccountFailure(errorDescribe: e.toString());
    }
  }

  Future<List<Account>> queryAccount({required String idOrName}) async {
    try {
      final gqlStr = queries.queryAccount;
      final result = await _graphQLClient.query(QueryOptions(
          document: gql(gqlStr),
          variables: <String, dynamic>{kIdOrName: idOrName}));
      if (result.hasException) {
        throw AccountFailure(errorDescribe: result.exception.toString());
      } else if (result.data == null) {
        throw AccountFailure(errorDescribe: kErrorResultNull);
      }

      final data = result.data![kQueryAccount];
      final List<Account> accountList = [];
      for (final cloudAccount in data) {
        if (cloudAccount['info'] == null) {
          accountList.add(Account(id: cloudAccount['id']));
        } else {
          final accountJson = jsonDecode(cloudAccount['info']);
          accountList.add(Account.fromJson(accountJson));
        }
      }
      return accountList;
    } on AccountFailure {
      rethrow;
    } catch (e) {
      log('query account exception: ${e.toString()}');
      throw AccountFailure(errorDescribe: e.toString());
    }
  }
}
