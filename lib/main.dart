import 'package:flutter/material.dart';
import 'package:mule/config/config.dart';
import 'package:mule/navigation_home_screen.dart';
import 'package:mule/screens/welcome_screen.dart';
import 'package:mule/splash_screen.dart';
import 'package:mule/config/utils.dart';

import 'config/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Config.registerStoresWithGetIt();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<bool> _isAuthenticatedUser = authenticateUser();
  final Future<bool> _isCurrentLocationLoaded = loadCurrentPosition();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: Future.wait([_isAuthenticatedUser, _isCurrentLocationLoaded]),
          builder: (BuildContext context, AsyncSnapshot<List<bool>> snapshot) {
            if (snapshot.hasData && !snapshot.data.contains(false)) {
              return NotificationHandler(
                body: NavigationHomeScreen(),
              );
            } else if (!snapshot.hasData) {
              return SplashScreen();
            }
            return HomePage();
          },
        
      ),
    );
  }
}
