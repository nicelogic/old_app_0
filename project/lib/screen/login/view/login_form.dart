import 'dart:developer';

import 'package:app/feature/account/account.dart';
import 'package:app/feature/authentication/authentication.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:app/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:account_repository/account_repository.dart';
import 'package:contacts_repository/contacts_repository.dart';
import 'package:object_storage_repository/object_storage_repository.dart';
import 'package:ice_util/ice_util.dart';
import 'package:http/http.dart';
import 'package:app/config/config.dart';
import 'package:app/router/router.dart' as router;

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return BlocListener<LoginCubit, LoginState>(
    //   listener: (context, state) {
    //     String prompt = '';
    //     if (state.status == LoginStatus.authenticationSuccess) {
    //       prompt = Configs.getInstance().authenticationSuccessPromt;
    //       ScaffoldMessenger.of(context).removeCurrentSnackBar();
    //       context.read<RouterCubit>().popPage();
    //       return;
    //     }
    //     if (state.status == LoginStatus.authenticating) {
    //       prompt = Configs.getInstance().authenticating;
    //     } else if (state.status == LoginStatus.authenticationFailure) {
    //       prompt = Configs.getInstance().authenticationFailedPromt +
    //           ', ' +
    //           state.errorDescribe;
    //     } else if (state.status == LoginStatus.AccountFailure) {
    //       prompt = Configs.getInstance().getAccountFailed;
    //     }
    //     ScaffoldMessenger.of(context)
    //       ..hideCurrentSnackBar()
    //       ..showSnackBar(SnackBar(content: Text(prompt)));
    //   },
    // child: Align(
    //   alignment: const Alignment(0, -1 / 3),
    //   child: SingleChildScrollView(
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Image.asset(
    //           Configs.getInstance().logoPath,
    //           height: 120,
    //         ),
    //         const SizedBox(height: 16),
    //         Text(
    //           Configs.getInstance().appName,
    //           style: Theme.of(context).textTheme.headline6!.apply(
    //               color: Theme.of(context).primaryColor,
    //               fontStyle: FontStyle.italic),
    //         ),
    //         const SizedBox(height: 26.0),
    //         _FaceReconitionLoginButton(),
    //       ],
    //     ),
    //   ),
    // ),
    return FlutterLogin(
        footer: '闽ICP备20007006号',
        userType: LoginUserType.name,
        userValidator: (user) => null,
        hideForgotPasswordButton: true,
        title: Config.instance().appName,
        logo: Assets.images.logo.logo.path,
        onSignup: (data) async {
          final accountRepository = context.read<AccountRepository>();
          final contactRepository = context.read<ContactsRepository>();
          final accountBloc = context.read<AccountBloc>();
          String id = '';
          try {
            final authenticationRepository =
                context.read<AuthenticationRepository>();
            final authenticationBloc = context.read<AuthenticationBloc>();
            await authenticationBloc.signUpWithUserName(
                userName: data.name!, password: data.password!);
            final token = await authenticationRepository.getToken();
            id = await authenticationRepository.getId();
            accountRepository.resetApiClient(token);
            contactRepository.resetApiClient(token);
            await context.read<ObjectStorageRepository>().uploadImage(
                userId: id,
                objectName: Config.instance().objectStorageUserAvatar,
                data: ByteStream.fromBytes(generateDefaultUserAvatar(id[0])));
            await accountBloc.me(id);
          } on AuthFailure catch (e) {
            return e.errorDescribe;
          } on AccountFailure catch (e) {
            if (e.errorCode != AccountErrorCode.UserUndefined) {
              return e.errorDescribe;
            }
            try {
              await accountBloc.createAccount(id);
            } on AccountFailure catch (e) {
              return e.errorDescribe;
            }
          }
          router.isAuthenticated = true;
          return null;
        },
        onLogin: (data) async {
          final accountRepository = context.read<AccountRepository>();
          final contactRepository = context.read<ContactsRepository>();
          final accountBloc = context.read<AccountBloc>();
          String id = '';
          try {
            final authenticationRepository =
                context.read<AuthenticationRepository>();
            final authenticationBloc = context.read<AuthenticationBloc>();
            await authenticationBloc.signInWithUserName(
                userName: data.name, password: data.password);
            final token = await authenticationRepository.getToken();
            id = await authenticationRepository.getId();
            accountRepository.resetApiClient(token);
            contactRepository.resetApiClient(token);
            await accountBloc.me(id);
            router.isAuthenticated = true;
          } on AuthFailure catch (e) {
            log(e.errorDescribe);
            return e.errorDescribe;
          } on AccountFailure catch (e) {
            if (e.errorCode != AccountErrorCode.UserUndefined) {
              log(e.errorDescribe);
              return e.errorDescribe;
            } else {
              if (id != '') {
                await accountBloc.createAccount(id);
              }
            }
          }
          return null;
        },
        onSubmitAnimationCompleted: () {
          context.router.replace(const AppNavigationRoute());
        },
        onRecoverPassword: _loginUser2,
        messages: LoginMessages(userHint: 'UserName'));
  }
}

Future<String?>? _loginUser2(String s) {
  return null;
}

// class _FaceReconitionLoginButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     //final theme = Theme.of(context);
//     return ElevatedButton.icon(
//       label: Text(
//         Configs.getInstance().useFaceReconitionLogin,
//         style: TextStyle(color: Colors.white),
//       ),
//       icon: const Icon(FontAwesomeIcons.smile, color: Colors.yellowAccent),
//       onPressed: () =>
//           context.read<LoginCubit>().logInWithFaceReconition(context: context),
//     );
//   }
// }

// class _WechatLoginButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     //final theme = Theme.of(context);
//     return ElevatedButton.icon(
//       label: Text(
//         Configs.getInstance().useWechatLogin,
//         style: TextStyle(color: Colors.white),
//       ),
//       icon: const Icon(FontAwesomeIcons.weixin, color: Colors.green),
//       onPressed: () => context.read<LoginCubit>().logInWithWechat(),
//     );
//   }
// }
