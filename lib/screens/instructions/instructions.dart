import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/widgets/button.dart';
import '../../navigation_home_screen.dart';

class Instructions extends StatefulWidget {
  @override
  _InstructionsState createState() => _InstructionsState();
}

class _InstructionsState extends State<Instructions> {
  void _handleSubmit() async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "A Quick Read",
                      style: TextStyle(
                          fontSize: AppTheme.elementSize(
                              screenHeight, 24, 26, 28, 30, 32, 40, 45, 50),
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkGrey),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: AppTheme.elementSize(
                    screenHeight, 30, 30, 32, 32, 34, 43, 46, 50),
              ),
              Text(
                "Thank you for signing up!",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: AppTheme.elementSize(
                        screenHeight, 14, 15, 16, 17, 18, 20, 24, 28),
                    color: AppTheme.darkGrey),
              ),
              SizedBox(
                height: AppTheme.elementSize(
                    screenHeight, 30, 30, 32, 32, 34, 43, 46, 50),
              ),
              Text(
                "Add instructions...",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: AppTheme.elementSize(
                        screenHeight, 14, 15, 16, 17, 18, 20, 24, 28),
                    color: AppTheme.darkGrey),
              ),
              button('Let\'s go!', _handleSubmit, screenHeight, context)
            ],
          ),
        ),
      ),
    );
  }
}
