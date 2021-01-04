import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/config/notification_types.dart';
import 'package:mule/models/req/uploadDeviceToken/upload_device_token_req.dart';
import 'package:mule/screens/requests/requests_screen.dart';

class NotificationHandler extends StatefulWidget {
  final Widget body;

  const NotificationHandler({this.body});

  @override
  _NotificationHandlerState createState() => _NotificationHandlerState();
}

class _NotificationHandlerState extends State<NotificationHandler> {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    print('HERERERERERERERE');
    super.initState();
    if (Platform.isIOS) {
      // When permission is given send the token to the server
      _fcm.onIosSettingsRegistered.listen((event) => _saveDeviceToken());
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      _saveDeviceToken();
    }

    _fcm.configure(
      // App in foreground
      onMessage: _foregroundMessageHandler,
      // App in background
      // onResume: ,
      // App terminated
      // onLaunch: ,
      // onBackgroundMessage: (Map<String, dynamic> message) async {},
    );
  }

  _saveDeviceToken() async {
    String fcmToken = await _fcm.getToken();
    print('WAAAAAAAAAAAAAAAAAAAAAAAAAA');
    print('Token is $fcmToken');
    // Make a request to save the token on the backend
    await httpClient
        .uploadDeviceToken(UploadDeviceTokenReq(deviceToken: fcmToken));
  }

  Future<dynamic> _foregroundMessageHandler(
      Map<String, dynamic> message) async {
    print('Here');
    print(message);
    print(message['data']['type']);
    switch (message['data']['type']) {
      case MULE_NEW_REQUEST:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => RequestsScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.body;
  }
}
