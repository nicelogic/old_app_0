// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';

// import 'package:authentication_repository/authentication_repository.dart';
// import 'package:account_repository/account_repository.dart';

// part 'login_state.dart';
// part './model/login_status.dart';

// class LoginCubit extends Cubit<LoginState> {
//   // final AuthenticationRepository _authenticationRepository;
//   // final AccountRepository _accountRepository;

//   LoginCubit(
//       {required AuthenticationRepository authenticationRepository,
//       required AccountRepository accountRepository})
//       : _authenticationRepository = authenticationRepository,
//         _accountRepository = accountRepository,
//         super(const LoginState());

//   // Future<void> signUpWithUserName(
//   //     {required String userName, required String password}) async {
//   //   emit(state.copyWith(status: LoginStatus.authenticating));
//   //   try {
//   //     final authenticationResult = await _authenticationRepository
//   //         .signUpWithUserName(userName: userName, password: password);
//   //     final id = authenticationResult.token;
//   //     await _accountRepository.me(id);
//   //     emit(state.copyWith(status: LoginStatus.authenticationSuccess));
//   //   } on AuthenticationFailure {
//   //     emit(state.copyWith(status: LoginStatus.authenticationFailure));
//   //   } on AccountFailure {
//   //     emit(state.copyWith(status: LoginStatus.accountFailure));
//   //   }
//   // }

//   Future<void> signInWithUserName(
//       {required String userName, required String password}) async {
//     emit(state.copyWith(status: LoginStatus.authenticating));
//     try {
//       // final authticationResult = await _authenticationRepository
//       //     .signupWithUserName(userName: userName, password: password);
//       emit(state.copyWith(status: LoginStatus.authenticationSuccess));
//     } on AuthenticationFailure {
//       emit(state.copyWith(status: LoginStatus.authenticationFailure));
//     } on AccountFailure {
//       emit(state.copyWith(status: LoginStatus.accountFailure));
//     }
//   }

//   // Future<void> logInWithFaceReconition({required BuildContext context}) async {
//   //   emit(state.copyWith(status: LoginStatus.authenticating));
//   //   try {
//   //     final account = await _authenticationRepository.loginWithFaceReconition();
//   //     await _accountRepository
//   //         .getAccountByWechat(WechatAccount(id: account.id));
//   //     emit(state.copyWith(status: LoginStatus.authenticationSuccess));
//   //   } on AuthenticationFailure {
//   //     emit(state.copyWith(status: LoginStatus.authenticationFailure));
//   //   } on AccountFailure {
//   //     emit(state.copyWith(status: LoginStatus.AccountFailure));
//   //   }
//   // }

//   // Future<void> logInWithWechat() async {
//   //   emit(state.copyWith(status: LoginStatus.authenticating));
//   //   try {
//   //     final wechatAccount = await _authenticationRepository.loginWithWechat();
//   //     await _accountRepository
//   //         .getAccountByWechat(WechatAccount(id: wechatAccount.id));
//   //     emit(state.copyWith(status: LoginStatus.authenticationSuccess));
//   //   } on AuthenticationFailure {
//   //     emit(state.copyWith(status: LoginStatus.authenticationFailure));
//   //   } on AccountFailure {
//   //     emit(state.copyWith(status: LoginStatus.AccountFailure));
//   //   }
//   // }
// }
