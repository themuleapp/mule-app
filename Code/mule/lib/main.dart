import 'package:flutter/material.dart';
import 'package:mule/Screens/homepage.dart';
import 'package:mule/config/http_client.dart' show httpClient;

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
