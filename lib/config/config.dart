import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/stores/location/location_store.dart';

class Config {
  static final BASE_URL = 'https://whisperingmule.herokuapp.com/api/';
  static final TOKEN_KEY = 'token';

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