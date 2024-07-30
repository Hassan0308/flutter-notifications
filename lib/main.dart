import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'local_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  InitializationSettings initializationSettings = initializePlatformSpecifics();

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(
      MyApp(flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin));
}

InitializationSettings initializePlatformSpecifics() {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  return initializationSettings;
}

class MyApp extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  MyApp({required this.flutterLocalNotificationsPlugin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Notifications App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LocalNotificationScreen(
          flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin),
    );
  }
}
