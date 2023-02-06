import 'dart:developer';

import 'package:graphql/client.dart';
import 'mutations/mutations.dart' as mutations;
import 'queries/queries.dart' as queries;
import '../models/models.dart';
import '../constant/constant.dart';

class AuthenticationApiClient {
  final GraphQLClient _graphQLClient;

  const AuthenticationApiClient({required GraphQLClient graphQLClient})
      : _graphQLClient = graphQLClient;

  factory AuthenticationApiClient.create({String url = ''}) {
    final _httpLink = HttpLink(url);
    final link = Link.from([_httpLink]);
    return AuthenticationApiClient(
        graphQLClient: GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    ));
  }

  Future<AuthenticationResult> signUpWithUserName(
      {required String userName, required String password}) async {
    try {
      final gqlStr = mutations.signUpWithUserName;
      final signUpResult = await _graphQLClient.mutate(
          MutationOptions(document: gql(gqlStr), variables: <String, dynamic>{
        kInput: {kUserName: userName, kPassword: password}
      }));
      if (signUpResult.hasException) {
        throw AuthFailure(errorDescribe: signUpResult.exception.toString());
      }
      if (signUpResult.data == null) {
        throw AuthFailure(
            errorDescribe: '$kSignUpWithUserName $kErrorResultDataIsNull');
      }

      final data = signUpResult.data![kSignUpWithUserName];
      final authenticationResult = AuthenticationResult.fromJson(data);
      if (authenticationResult.result != kSuccess) {
        throw AuthFailure(errorDescribe: authenticationResult.result);
      }
      return authenticationResult;
    } on ServerException catch (e) {
      log(e.toString());
      throw AuthFailure(errorDescribe: e.toString());
    } on AuthFailure catch (e) {
      log(e.errorDescribe);
      rethrow;
    } catch (e) {
      log(e.toString());
      throw AuthFailure(errorDescribe: e.toString());
    }
  }

  Future<AuthenticationResult> signInWithUserName(
      {required String userName, required String password}) async {
    try {
      final gqlStr = queries.signInWithUserName;
      final signInResult = await _graphQLClient.query(QueryOptions(
          document: gql(gqlStr),
          fetchPolicy: FetchPolicy.networkOnly,
          variables: <String, dynamic>{
            kInput: {kUserName: userName, kPassword: password}
          }));
      if (signInResult.hasException) {
        throw AuthFailure(errorDescribe: signInResult.exception.toString());
      }
      if (signInResult.data == null) {
        throw AuthFailure(
            errorDescribe: '$kSignInWithUserName $kErrorResultDataIsNull');
      }

      final data = signInResult.data![kSignInWithUserName];
      final authenticationResult = AuthenticationResult.fromJson(data);
      if (authenticationResult.result != kSuccess) {
        throw AuthFailure(errorDescribe: authenticationResult.result);
      }
      return authenticationResult;
    } on String catch (e) {
      log(e);
      throw AuthFailure(errorDescribe: e);
    } on ServerException catch (e) {
      log(e.toString());
      throw AuthFailure(errorDescribe: e.toString());
    } on AuthFailure catch (e) {
      log(e.errorDescribe);
      rethrow;
    } catch (e) {
      log(e.toString());
      throw AuthFailure(errorDescribe: e.toString());
    }
  }
}
