import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedOpacity(
              duration: const Duration(seconds: 2),
              opacity: 0.8,
              curve: Curves.fastOutSlowIn,
              child: Container(
                padding: EdgeInsets.all(50),
                child: Image.asset('assets/images/mule_logo.png'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
