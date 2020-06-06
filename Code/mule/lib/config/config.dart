import 'package:mule/stores/global/user_info_store.dart';
import 'package:get_it/get_it.dart';

class Config {
  //static final BASE_URL = 'http://localhost:3000/api';
  //static final BASE_URL = 'http://10.0.2.2:3000/api';
  static final BASE_URL = 'https://whisperingmule.herokuapp.com/api/';

  static void registerStoresWithGetIt() {
    GetIt.I.registerSingleton<UserInfoStore>(UserInfoStore());
  }
}
