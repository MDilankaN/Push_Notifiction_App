import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:push_notification_poc/main.dart';
import 'package:push_notification_poc/screens/notification_view.dart';

Future<void> handelBackgroundMsg(RemoteMessage message) async {
  print('received BackgroundMsg');
  if (message.notification != null) {
    print('title ${message.notification!.title}');
    print('body ${message.notification!.body}');
  }
  print('data ${message.data}');
}

class FirebaseApi {
  final _firebase = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'High Importance Channel',
      description: 'High Importance Notification',
      importance: Importance.defaultImportance);

  final _localNotification = FlutterLocalNotificationsPlugin();

  void handelMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState
        ?.pushNamed(NotificationView.route, arguments: message);
  }

  Future initNotification() async {
    FirebaseMessaging.instance.getInitialMessage().then(handelMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handelMessage);
    FirebaseMessaging.onBackgroundMessage(handelBackgroundMsg);
    FirebaseMessaging.onMessage.listen((event) {
      final notification = event.notification;
      if (notification == null) return;

      _localNotification.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                _androidChannel.id, _androidChannel.name,
                channelDescription: _androidChannel.description,
                icon: '@mipmap/ic_launcher'),
          ),
          payload: jsonEncode(event.toMap()));
    });
  }

  Future initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _localNotification.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) {
        if (payload.notificationResponseType ==
            NotificationResponseType.selectedNotification) {
          RemoteMessage remoteMessage =
              RemoteMessage.fromMap(jsonDecode(payload.payload!));
          handelMessage(remoteMessage);
        }
      },
    );

    final platform = _localNotification.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> initNotifications() async {
    await _firebase.requestPermission();
    final fCMToken = await _firebase.getToken();
    print(fCMToken);
    initNotification();
    initLocalNotifications();
  }
}
