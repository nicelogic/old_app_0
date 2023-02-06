import 'package:app/feature/upgrade/whole/cubit/wholeupgrade_cubit.dart';
import 'package:app/router/router.dart' as router;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/theme/theme.dart';
import 'package:app/config/config.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:account_repository/account_repository.dart';
import 'package:pubsub_repository/pubsub_repository.dart';
import 'package:contacts_repository/contacts_repository.dart';
import 'package:message_repository/message_repository.dart';
import 'package:p2p_signaling_repository/p2p_signaling_repository.dart';
import 'package:object_storage_repository/object_storage_repository.dart';

import 'package:app/feature/notification/notification.dart';
import 'package:app/feature/account/account.dart';
import 'package:app/feature/authentication/authentication.dart';
import 'package:app/feature/chat/chat.dart';
import 'package:app/feature/contact/contact.dart';
import 'package:app/feature/pubsub/pubsub_bloc.dart';
import 'package:app/feature/message/message.dart';

class App extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  final AccountRepository _accountRepository;
  final PubsubRepository _pubsubRepository;
  final ContactsRepository _contactRepository;
  final MessageRepository _messageRepository;
  final P2pSignalingRepository _p2pSignalingRepository;
  final ObjectStorageRepository _objectStorageRepository;

  const App(
      {required Key key,
      required AuthenticationRepository authenticationRepository,
      required AccountRepository accountRepository,
      required PubsubRepository pubsubRepository,
      required ContactsRepository contactRepository,
      required MessageRepository messageRepository,
      required P2pSignalingRepository p2pSignalingRepository,
      required ObjectStorageRepository objectStorageRepository})
      : _authenticationRepository = authenticationRepository,
        _accountRepository = accountRepository,
        _pubsubRepository = pubsubRepository,
        _contactRepository = contactRepository,
        _messageRepository = messageRepository,
        _p2pSignalingRepository = p2pSignalingRepository,
        _objectStorageRepository = objectStorageRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final authenticationBloc = AuthenticationBloc(_authenticationRepository);
    final accountBloc = AccountBloc(
        accountRepository: _accountRepository,
        authenticationBloc: authenticationBloc);

    final contactBloc = ContactsBloc(
        accountRepository: _accountRepository,
        contactRepository: _contactRepository,
        pubsubRepository: _pubsubRepository,
        accountBloc: accountBloc);
    final pubsubBloc = PubsubBloc(
        pubsubRepository: _pubsubRepository,
        accountBloc: accountBloc,
        contactBloc: contactBloc);
    final addContactBloc = AddContactsBloc(
        accountRepository: _accountRepository,
        pubsubRepository: _pubsubRepository,
        accountBloc: accountBloc);
    pubsubBloc.setAddContactBloc(addContactBloc);
    final chatBloc = ChatBloc(
        messageReposiotry: _messageRepository, accountBloc: accountBloc);
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthenticationRepository>(
            create: (_) => _authenticationRepository,
          ),
          RepositoryProvider<AccountRepository>(
            create: (_) => _accountRepository,
          ),
          RepositoryProvider<PubsubRepository>(
            create: (_) => _pubsubRepository,
          ),
          RepositoryProvider(create: (_) => _contactRepository),
          RepositoryProvider(create: (_) => _messageRepository),
          RepositoryProvider(create: (_) => _p2pSignalingRepository),
          RepositoryProvider(create: (_) => _objectStorageRepository)
        ],
        child: MultiBlocProvider(providers: [
          BlocProvider<WholeUpgradeCubit>(
              lazy: false,
              create: (_) =>
                  WholeUpgradeCubit(buglyAppId: Config.instance().buglyAppId)
                    ..init()),
          BlocProvider<LocalNotificationCubit>(
            lazy: false,
            create: (_) => LocalNotificationCubit(),
          ),
          BlocProvider<AuthenticationBloc>(
              lazy: false,
              create: (BuildContext context) => authenticationBloc),
          BlocProvider<AccountBloc>(
              lazy: false, create: (BuildContext context) => accountBloc),
          BlocProvider<PubsubBloc>(
            create: (BuildContext context) => pubsubBloc,
            lazy: false,
          ),
          BlocProvider<ContactsBloc>(
            create: (_) => contactBloc,
          ),
          BlocProvider<AddContactsBloc>(
            create: (_) => addContactBloc,
            lazy: false,
          ),
          BlocProvider<ChatBloc>(lazy: false, create: (_) => chatBloc),
          BlocProvider<MessageBloc>(
              lazy: false,
              create: (_) => MessageBloc(
                  messageReposiotry: _messageRepository,
                  chatBloc: chatBloc,
                  accountBloc: accountBloc))
        ], child: const AppView()));
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _appRouter = router.AppRouter(authGuard: router.AuthGuard());

  @override
  Widget build(BuildContext context) {
    final notificationCubit = context.read<LocalNotificationCubit>();
    notificationCubit.init();
    return MaterialApp.router(
      title: Config.instance().appName,
      theme: appTheme,
      routeInformationParser: _appRouter.defaultRouteParser(),
      routerDelegate: _appRouter.delegate(),
    );
  }
}

  // Future<void> initAutoStart() async {
  //   try {
  //     //only first time request
  //     const kHasRequestedAutoStartPermissionKey =
  //         'hasRequestedAutoStartPermission';
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     final hasRequestedAutoStartPermission =
  //         prefs.getBool(kHasRequestedAutoStartPermissionKey) ?? false;

  //     if (!hasRequestedAutoStartPermission) {
  //       await prefs.setBool(kHasRequestedAutoStartPermissionKey, true);
  //       final isAutoStart = await isAutoStartAvailable;
  //       if (isAutoStart ?? false) {
  //         await getAutoStartPermission();
  //       }
  //     }
  //   } on PlatformException catch (e) {
  //     log(e.message ?? '');
  //   }
  //   setState(() {
  //     _requestPermissionInitialized = true;
  //   });
  // }

