import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  static const route = '/notification-view';

  @override
  Widget build(BuildContext context) {
    final RemoteMessage message =
        ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Notification View"),
          Text('title ${message.notification!.title}'),
          Text('body ${message.notification!.body}'),
        ],
      )),
    );
  }
}
