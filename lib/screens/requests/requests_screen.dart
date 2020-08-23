import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';

class RequestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Requests",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkGrey,
                  fontSize: AppTheme.elementSize(
                      screenHeight, 24, 26, 28, 30, 32, 40, 45, 50),
                ),
              ),
              SizedBox(
                height: AppTheme.elementSize(
                    screenHeight, 10, 10, 12, 12, 14, 20, 20, 22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
