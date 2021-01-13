import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/config.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/models/res/profileRes/profile_res.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:mule/stores/location/location_store.dart';

Future<bool> loadCurrentPosition() {
  Future<bool> isLocationLoaded =
      Geolocator.getCurrentPosition().then((position) async {
    GetIt.I.get<LocationStore>().updateCurrentLocation(position);
    return GetIt.I.get<LocationStore>().isLocationLoaded;
  });
  return isLocationLoaded;
}

Future<bool> authenticateUser() {
  Future<bool> authenticated = Config.getToken().then((value) async {
    if (value != null && value.isNotEmpty) {
      final Response res = await httpClient.handleGetProfileData();

      if (res.statusCode == 200) {
        ProfileRes profileRes = ProfileRes.fromJson(res.data);
        GetIt.I.get<UserInfoStore>().updateEverythingFromrRes(profileRes);
        GetIt.I.get<UserInfoStore>().updateProfilePicture();
        return true;
      }
    }
    return false;
  });
  return authenticated;
}
