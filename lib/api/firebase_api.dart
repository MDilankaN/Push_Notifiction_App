import 'package:firebase_messaging/firebase_messaging.dart';
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

  void handelMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState
        ?.pushNamed(NotificationView.route, arguments: message);
  }

  Future initNotification() async {
    FirebaseMessaging.instance.getInitialMessage().then(handelMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handelMessage);
    FirebaseMessaging.onBackgroundMessage(handelBackgroundMsg);
  }

  Future<void> initNotifications() async {
    await _firebase.requestPermission();
    final fCMToken = await _firebase.getToken();
    print(fCMToken);
    initNotification();
  }
}
