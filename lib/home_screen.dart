import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notifications/access_token_firebase.dart';
import 'package:flutter_notifications/local_notification_screen.dart';
import 'package:flutter_notifications/notification_services.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? token;
  AccessTokenFirebase accessToken = AccessTokenFirebase();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  notificationServices.checkAndRequestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.getDeviceToken().then((value) async {
      setState(() {
        token = value;
      });

      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: token ?? "no"));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                  child: Text(token ?? "no")),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LocalNotificationScreen(
                              flutterLocalNotificationsPlugin:
                                  flutterLocalNotificationsPlugin)));
                },
                child: Text("Test Local Notifications"),
              ),
              ElevatedButton(
                onPressed: () async {
                  String token = "await accessToken.getAccessToken()";
                  print(token);
                  notificationServices.getDeviceToken().then((value) async {
                    var data = {
                      'message': {
                        'token': value.toString(),
                        'notification': {'title': 'Hassan', 'body': "Body"}
                      }
                    };
                    await http.post(
                        Uri.parse(
                            "https://fcm.googleapis.com/v1/projects/flutter-notifications-3c7b8/messages:send"),
                        body: jsonEncode(data),
                        headers: {
                          'Content-Type': 'application/json; charset=UTF-8',
                          'Authorization': 'Bearer $token'
                        }).then((value) {
                          print(value.body);
                    });

                  });
                },
                child: Text("Send Notification"),
              ),
            ],
          )),
    );
  }
}
