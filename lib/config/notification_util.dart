import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/models/req/deviceToken/device_token_req.dart';

class NotificationUtil {
  static void deleteDeviceToken() async {
    final FirebaseMessaging fcm = FirebaseMessaging();

    String fcmToken = await fcm.getToken();
    httpClient.deleteDeviceToken(DeviceTokenReq(deviceToken: fcmToken));
  }

  static void displaySnackbar(
      {@required String title, @required String body, @required BuildContext context, Function onHandle = null}) {
    showFlash(
      context: context,
      // duration: const Duration(seconds: 2),
      persistent: true,
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          boxShadows: [BoxShadow(blurRadius: 4)],
          barrierBlur: 3.0,
          barrierColor: Colors.black38,
          barrierDismissible: true,
          style: FlashStyle.floating,
          position: FlashPosition.top,
          child: FlashBar(
            title: Text(title, style: TextStyle( fontSize: 25.0)),
            message: Text(body),
            showProgressIndicator: true,
            actions: [
              // If there's a handle function display it!
              if (onHandle != null) FlatButton(
                  onPressed: () {
                    onHandle();
                    controller.dismiss();
                  },
                  child: Text('GO', style: TextStyle(color: AppTheme.lightBlue)),
                ),
              FlatButton(
                onPressed: () => controller.dismiss(),
                child: Text('DISMISS', style: TextStyle(color: AppTheme.lightBlue)),
              )
            ],
          ),
        );
      },
    );
  }
}
