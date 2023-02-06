import 'dart:developer';

import 'package:graphql/client.dart';
import 'queries/queries.dart' as queries;
import 'mutations/mutations.dart' as mutations;
import '../model/model.dart';
import '../constant/constant.dart';

// import 'package:normalize/utils.dart';
// import "package:gql/language.dart";
// import "package:gql/ast.dart";

// class AddNestedTypenameVisitor extends AddTypenameVisitor {
//   @override
//   visitOperationDefinitionNode(node) => node;
// }

// DocumentNode gql(String document) => transform(
//       parseString(document),
//       [AddNestedTypenameVisitor()],
//     );

class ContactApiClient {
  final GraphQLClient _graphQLClient;

  const ContactApiClient({required GraphQLClient graphQLClient})
      : _graphQLClient = graphQLClient;

  factory ContactApiClient.create(
      {required final String url, required final String token}) {
    final _httpLink = HttpLink(url);
    final _authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );

    Link _link = _authLink.concat(_httpLink);
    return ContactApiClient(
        graphQLClient: GraphQLClient(
      cache: GraphQLCache(),
      link: _link,
    ));
  }

  Future<List<String>> contact({required String id}) async {
    final List<String> contactIds = [];
    if (id.isEmpty) {
      return contactIds;
    }
    try {
      final result = await _graphQLClient.query(QueryOptions(
          document: gql(queries.getContact),
          variables: <String, dynamic>{kId: id},
          fetchPolicy: FetchPolicy.networkOnly));
      if (result.hasException) {
        if (result.exception!.graphqlErrors.isEmpty) {
          throw ContactFailure(errorDescribe: kErrorGraphqlErrorsIsEmpty);
        }
        final errorDescribe = result.exception!.graphqlErrors.first.message;
        final isUserNotExist = errorDescribe.contains(kUserNotExist);
        final errorCode = isUserNotExist
            ? ContactErrorCode.userUndefined
            : ContactErrorCode.undefined;
        throw ContactFailure(
            errorDescribe: result.exception.toString(), errorCode: errorCode);
      } else if (result.data == null) {
        throw ContactFailure(errorDescribe: kErrorResultNull);
      }

      final data = result.data![kAccount][kContact];

      for (final contactInfo in data) {
        contactIds.add(contactInfo[kId]);
      }
      return contactIds;
    } on ContactFailure {
      rethrow;
    } catch (e) {
      log(e.toString());
      throw ContactFailure(errorDescribe: e.toString());
    }
  }

  Future<ContactInput> updateContact(
      {required final String id,
      required final ContactInput contactInput}) async {
    try {
      final result = await _graphQLClient.mutate(MutationOptions(
          document: gql(mutations.updateContact),
          variables: <String, dynamic>{
            kId: id,
            kContactInput: contactInput,
          }));
      if (result.hasException) {
        final errorDescribe = result.exception!.graphqlErrors.first.message;
        final isUserNotExist = errorDescribe.contains(kUserNotExist);
        final errorCode = isUserNotExist
            ? ContactErrorCode.userUndefined
            : ContactErrorCode.undefined;
        throw ContactFailure(
            errorDescribe: result.exception.toString(), errorCode: errorCode);
      } else if (result.data == null) {
        throw ContactFailure(errorDescribe: kErrorResultNull);
      }
      return contactInput;
    } on ContactFailure {
      rethrow;
    } catch (e) {
      log(e.toString());
      throw ContactFailure(errorDescribe: e.toString());
    }
  }
}
