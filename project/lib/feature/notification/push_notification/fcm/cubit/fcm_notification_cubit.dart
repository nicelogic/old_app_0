// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:typed_data';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;

// part 'fcm_notification_state.dart';

// // //this functin must put top level
// // Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// //   // If you're going to use other Firebase services in the background, such as Firestore,
// //   // make sure you call `initializeApp` before using other Firebase services.
// //   await Firebase.initializeApp();

// //   //background or terminal will trigger this callback
// //   //but if in background, use lcoal notification
// //   //we only need the callback: onMessageOpenedApp
// //   log("Handling a background message: ${message.messageId}");
// // }
// // await Firebase.initializeApp();
// // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
// // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
// //   log('A new onMessageOpenedApp event was published!');
// // });

// class FcmNotificationCubit extends Cubit<FcmNotificationState> {
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   String? _token;
//   late Stream<String> _tokenStream;
//   int _messageCount = 0;
//   // FirebaseMessaging? _messaging;

//     FcmNotificationCubit() : super(FcmNotificationInitial());


//   init() async {

//     /// Update the iOS foreground notification presentation options to allow
//     /// heads up notifications.
//     _messaging = FirebaseMessaging.instance;
//     await _messaging?.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     final settings = await _messaging?.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: false,
//       sound: true,
//     );
//     log('User granted permission: ${settings?.authorizationStatus}');

//     try {
//       if (!kIsWeb) {
//         log('android in china, template not support get token');
//       } else {
//         // _token = await _messaging?.getToken(
//         //     vapidKey:
//         //         'BPE9KBUZNDLEnP63YEYkyU_ToqR15F81ADxGmnOMiaHExd1-PThDxB777CPC1KfXnKUaLSEN441dbKqhHZDIO9I');
//         _token = await _messaging?.getToken(
//             vapidKey:
//                 'BGpdLRsMJKvFDD9odfPk92uBg-JbQbyoiZdah0XlUyrjG4SDgUsE1iC_kdRgt4Kn0CO7K3RTswPZt61NNuO0XoA');
//         log('token: {$_token}');
//         _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
//         _tokenStream.listen((token) {
//           _token = token;
//           log('token refresh: $_token');
//         });
//       }
//     } on PlatformException catch (e) {
//       log(e.message ?? 'fcm get token fail');
//     } catch (e) {
//       log(e.toString());
//     }
//   }

//   Future<Uint8List> _getByteArrayFromUrl(String url) async {
//     final http.Response response = await http.get(Uri.parse(url));
//     return response.bodyBytes;
//   }

//   Future<void> showNewMessageNotification(
//       {required final String title,
//       required final String body,
//       required final String chatId,
//       required final String senderAvatarUrl}) async {
//     if (kIsWeb) {
//       log('web platform, not support notification');
//       return;
//     }

//     final largeIcon =
//         ByteArrayAndroidBitmap(await _getByteArrayFromUrl(senderAvatarUrl));
//     AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails('message', 'message',
//             channelDescription: 'message channel',
//             largeIcon: largeIcon,
//             importance: Importance.max,
//             priority: Priority.high,
//             enableLights: true,
//             ticker: 'ticker');
//     NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     await _flutterLocalNotificationsPlugin
//         .show(0, title, body, platformChannelSpecifics, payload: chatId);
//   }

//   Future<void> sendPushMessage() async {
//     if (_token == null) {
//       log('Unable to send FCM message, no token exists.');
//       return;
//     }

//     try {
//       await http.post(
//         Uri.parse('https://api.rnfirebase.io/messaging/send'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: constructFCMPayload(_token),
//       );
//       log('FCM request for device sent!');
//     } catch (e) {
//       log(e.toString());
//     }
//   }

//   String constructFCMPayload(String? token) {
//     _messageCount++;
//     return jsonEncode({
//       'token': token,
//       'data': {
//         'via': 'FlutterFire Cloud Messaging!!!',
//         'count': _messageCount.toString(),
//       },
//       'notification': {
//         'title': 'Hello FlutterFire!',
//         'body': 'This notification (#$_messageCount) was created via FCM!',
//       },
//     });
//   }
// }
