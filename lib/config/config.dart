import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mule/models/data/location_data.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/stores/location/location_store.dart';

class Config {
  static final BASE_URL = 'https://whisperingmule.herokuapp.com/api/';
  // static final BASE_URL = 'http://10.0.2.2:3000/api/';
  static final TOKEN_KEY = 'token';
  static final LocationData pennStateLocation =
      LocationData(lat: 40.793429, lng: -77.860314);

  static void registerStoresWithGetIt() {
    GetIt.I.registerSingleton<UserInfoStore>(UserInfoStore());
    GetIt.I.registerSingleton<LocationStore>(LocationStore());
  }

  static Future<void> saveToken(token) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: TOKEN_KEY, value: token);
  }

  static Future<String> getToken() async {
    final storage = new FlutterSecureStorage();
    return await storage.read(key: TOKEN_KEY);
  }

  static Future<void> deleteToken() async {
    final storage = new FlutterSecureStorage();
    storage.delete(key: TOKEN_KEY);
  }
}
