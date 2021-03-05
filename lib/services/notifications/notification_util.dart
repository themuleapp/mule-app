import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/services/mule_api_service.dart';
import 'package:mule/models/req/deviceToken/device_token_req.dart';

class NotificationUtil {
  static void deleteDeviceToken() async {
    final FirebaseMessaging fcm = FirebaseMessaging();

    String fcmToken = await fcm.getToken();
    muleApiService.deleteDeviceToken(DeviceTokenReq(deviceToken: fcmToken));
  }

  static void displaySnackbar(
      {@required String title,
      @required String body,
      @required BuildContext context,
      Function onHandle = null}) {
    showFlash(
      context: context,
      duration: const Duration(seconds: 5),
      persistent: true,
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: Colors.black87,
          borderRadius: BorderRadius.circular(8.0),
          borderColor: Colors.blue,
          position: FlashPosition.top,
          style: FlashStyle.floating,
          enableDrag: false,
          onTap: () => controller.dismiss(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: DefaultTextStyle(
              style: TextStyle(color: Colors.white),
              child: Text(
                body,
              ),
            ),
          ),
        );
      },
    );
  }
}
