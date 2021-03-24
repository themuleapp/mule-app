import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mule/models/data/notification_message.dart';
import 'package:mule/models/req/deviceToken/device_token_req.dart';
import 'package:mule/screens/requests/requests_screen.dart';
import 'package:mule/services/notifications/notification_util.dart';
import 'package:mule/widgets/alert_widget.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/services/mule_api_service.dart';
import 'package:mule/services/notifications/notification_types.dart';
import 'package:mule/stores/global/user_info_store.dart';

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
    print('Token is $fcmToken');
    // Make a request to save the token on the backend
    await muleApiService
        .uploadDeviceToken(DeviceTokenReq(deviceToken: fcmToken));
  }

  Future<dynamic> _foregroundMessageHandler(
      Map<String, dynamic> message) async {
    await GetIt.I.get<UserInfoStore>().updateActiveOrder();

    // Unify message form
    NotificationMessage notificationMessage = NotificationMessage(message);

    switch (notificationMessage.type) {
      case MULE_NEW_REQUEST:
        NotificationUtil.displaySnackbar(
            title: notificationMessage.title,
            body: notificationMessage.body,
            context: context,
            onHandle: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RequestsScreen()));
            });
        break;
      case USER_REQUEST_ACCEPTED:
        NotificationUtil.displaySnackbar(
            title: notificationMessage.title,
            body: notificationMessage.body,
            context: context,
            onHandle: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RequestsScreen()));
            });
        break;
      case MULE_DELIVERY_CONFIRMED:
        // TODO
        createDialogWidget(
          context,
          notificationMessage.title,
          notificationMessage.body
        );
        break;
      case USER_DELIVERED_CONFIRMED:
        NotificationUtil.displaySnackbar(
          title: notificationMessage.title,
          body: notificationMessage.body,
          context: context,
        );
        break;
      case USER_CANCELLED:
        NotificationUtil.displaySnackbar(
          title: notificationMessage.title,
          body: notificationMessage.body,
          context: context,
        );
        break;
      case MULE_CANCELLED:
        NotificationUtil.displaySnackbar(
          title: notificationMessage.title,
          body: notificationMessage.body,
          context: context,
        );
        break;
      case USER_REQUEST_TIMEOUT:
        NotificationUtil.displaySnackbar(
          title: notificationMessage.title,
          body: notificationMessage.body,
          context: context,
        );
        break;
      default:
        print('UNKNOWN NOTIFICATION TYPE!');
        print("Recieved new request $message");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.body;
  }
}
