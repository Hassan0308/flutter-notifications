import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_notifications/keys.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

class AccessTokenFirebase{
  static String firebaseMessageScope = "https://www.googleapis.com/auth/firebase.messaging";

  Future<String> getAccessToken()async{
    final client = await clientViaServiceAccount(ServiceAccountCredentials.fromJson(
        {
         AppConstant.data
        }

        ,) ,[firebaseMessageScope] );
    final accessToken = client.credentials.accessToken.data;
    return accessToken;

  }

  Future<Object> getAccessToken2() async {
    final credentials = await FirebaseAuth.instance.signInWithCustomToken(
      await File('path/to/your/service_account_key.json').readAsString(),
    );

    final token = credentials.user?.getIdToken();
    return token??"";
  }
}
