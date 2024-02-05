import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebase = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebase.requestPermission();
    final fCMToken = await _firebase.getToken();
    print(fCMToken);
  }
}
