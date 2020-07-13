import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBlue,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Material(
                elevation: 8,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: Image.asset('assets/images/logo.png'),
                  radius: 100.0,
                )
            ),
          ],
        ),
      ),
    );
  }
}