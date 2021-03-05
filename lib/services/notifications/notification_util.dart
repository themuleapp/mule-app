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
      // duration: const Duration(seconds: 2),
      persistent: true,
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: AppTheme.white,
          brightness: Brightness.light,
          boxShadows: [BoxShadow(blurRadius: 4)],
          barrierBlur: 3.0,
          barrierColor: AppTheme.darkestGrey,
          barrierDismissible: true,
          style: FlashStyle.floating,
          position: FlashPosition.top,
          child: FlashBar(
            title: Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: AppTheme.darkerText,
              ),
            ),
            message: Text(
              body,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppTheme.darkText,
              ),
            ),
            showProgressIndicator: true,
            progressIndicatorBackgroundColor: AppTheme.secondaryBlue,
            progressIndicatorValueColor:
                AlwaysStoppedAnimation<Color>(AppTheme.lightBlue),
            primaryAction: TextButton(
              onPressed: () => controller.dismiss(),
              child: Text(
                'Dismiss',
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: AppTheme.lightBlue,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
