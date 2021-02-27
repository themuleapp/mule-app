import 'dart:io' show Platform;

class NotificationMessage {
  String type;
  String title;
  String body;

  NotificationMessage(Map<String, dynamic> message) {
    if (Platform.isIOS) {
      this.type = message['type'];
      this.title = message['aps']['alert']['title'];
      this.body = message['aps']['alert']['body'];
    } else {
      this.type = message['data']['type'];
      this.title = message['notification']['title'];
      this.body = message['notification']['body'];
    }
  }
}
