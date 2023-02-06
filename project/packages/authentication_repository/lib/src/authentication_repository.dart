import 'dart:async';

import 'models/models.dart';
import 'api/api.dart';
import 'constant/constant.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationFailure implements Exception {}

class AuthenticationRepository {
  AuthenticationApiClient _authenticationApiClient;

  AuthenticationRepository({required String url})
      : _authenticationApiClient = AuthenticationApiClient.create(url: url);

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(kToken) ?? '';
  }

  Future<String> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(kId) ?? '';
  }

  Future<AuthenticationResult> signUpWithUserName(
      {required String userName, required String password}) async {
    final result = await _authenticationApiClient.signUpWithUserName(
        userName: userName, password: password);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(result.token);
    await prefs.setString(kToken, result.token);
    await prefs.setString(kId, decodedToken[kId]);
    return result;
  }

  Future<AuthenticationResult> signInWithUserName(
      {required String userName, required String password}) async {
    final result = await _authenticationApiClient.signInWithUserName(
        userName: userName, password: password);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(result.token);
    await prefs.setString(kToken, result.token);
    await prefs.setString(kId, decodedToken[kId]);
    return result;
  }

  // Future<Account> loginWithMail() async {
  //   try {
  //     await Future.delayed(const Duration(seconds: 1));
  //     const account = Account(
  //         id: 'niceice220',
  //         name: 'ice',
  //         signature: '干就完事了',
  //         wechatId: 'niceice220');
  //     _streamController.add(account);
  //     return account;
  //   } on Exception {
  //     throw AuthenticationFailure();
  //   }
  // }

//   Future<Account> loginWithFaceReconition() async {
//     try {
//       await Future.delayed(const Duration(seconds: 1));
//       const account = Account(
//           id: 'niceice220',
//           name: 'ice',
//           signature: '干就完事了',
//           wechatId: 'niceice220');
//       _streamController.add(account);
//       return account;
//     } on Exception {
//       throw AuthenticationFailure();
//     }
//   }

//   Future<Account> loginWithWechat() async {
//     try {
//       await Future.delayed(const Duration(seconds: 1));
//       const account = Account(
//           id: 'niceice220',
//           name: 'ice',
//           signature: '干就完事了',
//           wechatId: 'niceice220');
//       _streamController.add(account);
//       return account;
//     } on Exception {
//       throw AuthenticationFailure();
//     }
//   }
// }
}
