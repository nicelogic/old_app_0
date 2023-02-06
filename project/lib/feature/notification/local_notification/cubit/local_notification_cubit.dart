// ignore_for_file: nullable_type_in_catch_clause

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

part 'local_notification_state.dart';

class LocalNotificationCubit extends Cubit<LocalNotificationState> {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  LocalNotificationCubit() : super(LocalNotificationInitial());

  init() async {
    emit(LocalNotificationInitializing());

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logo');

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification: (
              int id,
              String? title,
              String? body,
              String? payload,
            ) async {});

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        log('notification payload: $payload');
        final chatId = payload;
        emit(LocalNewMessageNotification(chatId: chatId));
      }
    });

    if (!kIsWeb) {
      const channel = AndroidNotificationChannel(
        'message', // id
        'message', // title
        description:
            'This channel is used for message notifications.', // description
        importance: Importance.max,
      );

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    emit(LocalNotificationInitialized());
  }

  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  Future<void> showNewMessageNotification(
      {required final String title,
      required final String body,
      required final String chatId,
      required final String senderAvatarUrl}) async {
    if (kIsWeb) {
      log('web platform, not support notification');
      return;
    }

    final largeIcon =
        ByteArrayAndroidBitmap(await _getByteArrayFromUrl(senderAvatarUrl));
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('message', 'message',
            channelDescription: 'message channel',
            largeIcon: largeIcon,
            importance: Importance.max,
            priority: Priority.high,
            enableLights: true,
            ticker: 'ticker');
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: chatId);
  }
}
