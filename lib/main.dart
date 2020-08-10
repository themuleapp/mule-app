import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/config.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/models/res/profileRes/profile_res.dart';
import 'package:mule/navigation_home_screen.dart';
import 'package:mule/screens/request/make_request.dart';
import 'package:mule/screens/welcome_screen.dart';
import 'package:mule/splash_screen.dart';
import 'package:mule/stores/global/user_info_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Config.registerStoresWithGetIt();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<bool> _isAuthenticatedUser =
      Config.getToken().then((value) async {
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _isAuthenticatedUser,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data) {
            return MakeRequestScreen();
          } else if (!snapshot.hasData) {
            return SplashScreen();
          }
          return HomePage();
        },
      ),
    );
  }
}
