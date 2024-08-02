import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;




  Future<void> firebaseInit()async{
    FirebaseMessaging.onMessage.listen((notification) {
      print("Notifications");
      print(notification.notification!.title.toString());
      print(notification.notification!.body.toString());

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
   return await messaging.getToken();
  }
  // when token update then call and update db values
  void onRefreshToken(){
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print("refresh");
    });
  }
}
