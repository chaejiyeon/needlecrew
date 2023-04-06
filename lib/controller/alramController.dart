//
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
//
//
// class AlramController extends GetxController {
//   static AlramController get to => Get.find();
//
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   RxBool isChanged = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//   }
//
//
//   void setup() {
//     const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     // IOS / MacOS
//     const iosSetting = DarwinInitializationSettings(
//       requestAlertPermission: false,
//       requestBadgePermission: false,
//       requestSoundPermission: false,
//     );
//
//     const initSettings =
//         InitializationSettings(android: androidSetting, iOS: iosSetting);
//
//     _flutterLocalNotificationsPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
//       onDidReceiveBackgroundNotificationResponse:
//           onDidReceiveNotificationResponse,
//     );
//   }
//
//   Future onDidReceiveLocalNotification(
//       int id, String title, String body, String payload) async {
//     // IOS / MacOS
//     const darwinPlatformChannelSpecifics = DarwinNotificationDetails(
//         presentAlert: true, presentBadge: true, presentSound: true);
//
//     var platformChannelSpecifics =
//         NotificationDetails(iOS: darwinPlatformChannelSpecifics);
//
//     await _flutterLocalNotificationsPlugin.show(
//         0, title, body, platformChannelSpecifics);
//   }
//
//   Future onDidReceiveNotificationResponse(
//       NotificationResponse notificationResponse) async {
//     String? payload = notificationResponse.payload;
//
//     if (notificationResponse.payload != null) {
//       debugPrint("notification payload: $payload");
//     }
//   }
//
//   Future selectNotification(String? payload) async {
//
//   }
//
// }
