import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notifications/local_notification_screen.dart';
import 'package:flutter_notifications/notification_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String? token;
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  //  notificationServices.checkAndRequestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.getDeviceToken().then((value)  async {

      setState(() {
        token =  value;
      });

      print(value);

    }


    );
  }
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body:Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: token??"no"));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Copied to clipboard')),
                  );
                },
                child: Text(token??"no")),
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LocalNotificationScreen(flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin)));
              },
              child: Text("Test Local Notifications"),
            ),
            ElevatedButton(
              onPressed: (){
              },
              child: Text("Send Notification"),
            ),
          ],
        )
      ),

    );
  }
}
