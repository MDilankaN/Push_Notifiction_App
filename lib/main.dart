import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:push_notification_poc/screens/home.dart';
import 'package:push_notification_poc/screens/notification_view.dart';

import 'api/firebase_api.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAFV8oUxutL-p4SpXTqplwl3HrupbHj9gA",
          projectId: "push-notifications-a7786",
          messagingSenderId: "169921728748",
          appId: "1:169921728748:android:c0971be7f9f3673f1855c9"));
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Notifications',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      navigatorKey: navigatorKey,
      routes: {
        NotificationView.route: (context) => const NotificationView(),
      },
    );
  }
}
