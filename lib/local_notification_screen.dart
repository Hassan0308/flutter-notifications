import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationScreen extends StatefulWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  LocalNotificationScreen({required this.flutterLocalNotificationsPlugin});

  @override
  _LocalNotificationScreenState createState() => _LocalNotificationScreenState();
}

class _LocalNotificationScreenState extends State<LocalNotificationScreen> {


  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      //  'your_channel_description',
        icon: 'app_icon',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      playSound: true,
       timeoutAfter: 5000,
      styleInformation: DefaultStyleInformation(true, true)
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await widget.flutterLocalNotificationsPlugin.show(
      0,
      'Test Local Notification',
      'Test Body',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  //
  Future<void> scheduleNotification() async {
    var androidChannelSpecifics = const AndroidNotificationDetails(
      'CHANNEL_ID 1',
      'CHANNEL_NAME 1',
     // "CHANNEL_DESCRIPTION 1",
      icon: 'app_icon',
     // sound: RawResourceAndroidNotificationSound('my_sound'),
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
      enableLights: true,
      color: Color.fromARGB(255, 255, 0, 0),
      ledColor: Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 1000,
      ledOffMs: 500,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      timeoutAfter: 5000,
      styleInformation: DefaultStyleInformation(true, true),
    );
    // var iosChannelSpecifics = IOSNotificationDetails(
    //   sound: 'my_sound.aiff',
    // );
    var platformChannelSpecifics = NotificationDetails(
     android:  androidChannelSpecifics,
     // iosChannelSpecifics,
    );
    await widget.flutterLocalNotificationsPlugin.periodicallyShowWithDuration(
      0,
      'Test Title',
      'Test Body',
      Duration(seconds: 60),
      platformChannelSpecifics,
      payload: 'Test Payload',
    );
  }


  @override
  void initState() {
   // scheduleNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Local Notifications App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _showNotification,
          child: Text('Show Notification'),
        ),
      ),
    );
  }
}