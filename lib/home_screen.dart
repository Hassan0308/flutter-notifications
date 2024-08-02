import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notifications/notification_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
   // notificationServices.checkAndRequestNotificationPermission();
    notificationServices.firebaseInit();
    notificationServices.getDeviceToken().then((value) =>
        print(value),

    );
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:Center(
        child: ElevatedButton(
          onPressed: (){},
          child: Text("Click"),
        ),
      ),

    );
  }
}
