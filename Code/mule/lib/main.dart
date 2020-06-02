import 'package:flutter/material.dart';
import 'package:mule/Screens/homepage.dart';

void main() => runApp(App());

// void temp() async {
//   final res = await httpClient.handleLogin(LoginData(
//     email: 'ji.darwish98@gmail.com',
//     password: '123456789',
//   ));
//   print(res);
// }

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
