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
        return Padding(
          padding: EdgeInsets.only(left: 12, right: 12),
          child: Flash(
            controller: controller,
            backgroundColor: AppTheme.lightBlue.withOpacity(1.0),
            borderRadius: BorderRadius.circular(8.0),
            barrierBlur: 80,
            position: FlashPosition.top,
            style: FlashStyle.floating,
            enableDrag: true,
            onTap: () => controller.dismiss(),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: FittedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: AppTheme.white,
                      ),
                    ),
                    Text(
                      body,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
