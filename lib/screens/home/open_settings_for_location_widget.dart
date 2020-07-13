import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mule/screens/home/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class OpenSettingsForLocation extends StatefulWidget {
  @override
  _OpenSettingsForLocationState createState() =>
      _OpenSettingsForLocationState();
}

class _OpenSettingsForLocationState extends State<OpenSettingsForLocation> {
  Timer timer;

  void _keepCheckingLocationGranted(BuildContext context) async {
    if (await Permission.location.isGranted) {
      print('Here accepted');
      timer.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    timer = Timer.periodic(
        Duration(seconds: 10), (_) => _keepCheckingLocationGranted(context));
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text('Open settings'),
            onPressed: () async => await openAppSettings(),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text('Please grant location to be able to continue'),
          ),
        ],
      ),
    );
  }
}
