import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app/app.dart';
import 'package:app/platform/platform.dart';
import 'package:app/config/config.dart';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:account_repository/account_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pubsub_repository/pubsub_repository.dart';
import 'package:contacts_repository/contacts_repository.dart';
import 'package:message_repository/message_repository.dart';
import 'package:p2p_signaling_repository/p2p_signaling_repository.dart';
import 'package:object_storage_repository/object_storage_repository.dart';
import 'package:flutter_bugly/flutter_bugly.dart';

initApp({
  required final Directory blocCacheDir,
}) async {
  platformAdaptation();
  await Config.instance().loadConfigs();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cacheDir = kIsWeb
      ? HydratedStorage.webStorageDirectory
      : await getApplicationDocumentsDirectory();
  await initApp(blocCacheDir: cacheDir);
  // HttpOverrides.global = DevHttpOverrides();

  log('bloc cache dir: ${cacheDir.path}');
  final storage = await HydratedStorage.build(
    storageDirectory: cacheDir,
  );

  BlocOverrides.runZoned(
    () {
      HydratedBlocOverrides.runZoned(
        () async {
          if (kIsWeb) {
            await runAppImpl();
          } else {
            FlutterBugly.postCatchedException(() async {
              await runAppImpl();
            });
          }
        },
        storage: storage,
      );
    },
    blocObserver: AppBlocObserver(),
  );
}

runAppImpl() async {
  final authenticationRepository =
      AuthenticationRepository(url: Config.instance().authenticationServiceUrl);
  final token = await authenticationRepository.getToken();
  final accountRepository = AccountRepository(
      httpUrl: Config.instance().accountServiceUrl, token: token);
  final contactRepository = ContactsRepository(
    accountRepository: accountRepository,
    httpUrl: Config.instance().accountServiceUrl,
    token: token,
  );
  runApp(App(
    key: Key(Config.instance().appName),
    authenticationRepository: authenticationRepository,
    accountRepository: accountRepository,
    pubsubRepository: PubsubRepository(
        httpUrl: Config.instance().pubsubServiceUrl,
        wsUrl: Config.instance().pubsubServiceSubscriptionUrl,
        token: token),
    contactRepository: contactRepository,
    messageRepository: MessageRepository(
        httpUrl: Config.instance().messageServiceUrl,
        wsUrl: Config.instance().messageServiceSubscriptionUrl,
        token: token),
    p2pSignalingRepository:
        P2pSignalingRepository(wsUrl: Config.instance().rtcSignalingServiceUrl),
    objectStorageRepository: ObjectStorageRepository(
      httpUrl: Config.instance().httpServerUrl,
      accessKey: Config.instance().objectStorageAccessKey,
      secretKey: Config.instance().objectStorageSecretKey,
      port: Config.instance().objectStoragePort,
    ),
  ));
}

// class DevHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }