import 'package:flutter/material.dart';
import 'package:mule/Screens/homepage.dart';
import 'package:mule/config/config.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Config.registerStoresWithGetIt();

    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
