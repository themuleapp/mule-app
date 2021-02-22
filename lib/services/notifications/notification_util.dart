import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mule/services/mule_api_service.dart';
import 'package:mule/models/req/deviceToken/device_token_req.dart';

class NotificationUtil {
  static void deleteDeviceToken() async {
    final FirebaseMessaging fcm = FirebaseMessaging();

    String fcmToken = await fcm.getToken();
    muleApiService.deleteDeviceToken(DeviceTokenReq(deviceToken: fcmToken));
  }
}
