import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'message_screen.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var deviceToken;

  Future<void> initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      _handleOnTapNotification(message, context);
    });
  }

  void _handleOnTapNotification(RemoteMessage message, BuildContext context) {
    if (message.data['type'] == "msg") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MessageScreen()));
    }
  }

  Future<void> _showNotifications(RemoteMessage message) async {
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
            generateRandomNum(), "Important Notification",
            importance: Importance.max);
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      androidNotificationChannel.id,
      androidNotificationChannel.name,
      channelDescription: "Your channel desc",
      importance: Importance.high,
      priority: Priority.high,
      ticker: "ticker",
      //after adding icon issue solve
      icon: '@mipmap/ic_launcher',
    );
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentBanner: true,
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  String generateRandomNum() => Random.secure().nextInt(10000).toString();

  //When app is open to user
  Future<void> firebaseInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((notification) {
      print("Notifications");
      print(notification.notification!.title.toString());
      print(notification.notification!.body.toString());
      print(notification.data);
      if (Platform.isAndroid) {
        initLocalNotifications(context, notification);
      }
      _showNotifications(notification);
    });
  }

  Future<void> checkAndRequestNotificationPermission() async {
    NotificationSettings settings = await messaging.getNotificationSettings();
    print("Check notification permission... + ${settings.authorizationStatus}");

    if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      requestNotificationPermission();
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      requestNotificationPermission();
    } else {
      handleNotificationPermissionStatus(settings);
    }
  }

  Future<void> requestNotificationPermission() async {
    print("Requesting notification permission...");
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      carPlay: true,
      badge: true,
      criticalAlert: true,
      announcement: true,
      sound: true,
    );
    handleNotificationPermissionStatus(settings);
  }

  void handleNotificationPermissionStatus(NotificationSettings settings) {
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Granted");
      Fluttertoast.showToast(msg: "Granted");
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print("Denied");
      Fluttertoast.showToast(msg: "Denied");
    } else {
      print("Something else");
      Fluttertoast.showToast(msg: "Something else");
    }
  }

  //Generate FCM Token
  Future<String?> getDeviceToken() async {
    deviceToken = await messaging.getToken();
    return deviceToken;
  }

  // when token update then call and update db values
  void onRefreshToken() {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print("refresh");
    });
  }

  //When app is terminated then handle on tap
  Future<void> setupInteractMessage(BuildContext context) async {
    //When app is terminated then handle on tap
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleOnTapNotification(initialMessage, context);
    }
    //When app is on background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      _handleOnTapNotification(event, context);
    });
  }
}
