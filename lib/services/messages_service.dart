import 'package:url_launcher/url_launcher.dart';

class MessagesService {
  void sendSms(String number) => launch("sms:$number");
}
