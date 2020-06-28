import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/screens/login/login_screen.dart';
import 'package:mule/screens/signup/signup_screen.dart';
import 'package:mule/widgets/delayed_animation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final color = Colors.white;
    _scale = 1 - _controller.value;
    return Scaffold(
      backgroundColor: AppTheme.lightBlue,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              AvatarGlow(
                endRadius: screenHeight <= 660
                    ? 150
                    : screenHeight < 812
                        ? 180
                        : screenHeight <= 853
                            ? 210
                            : screenHeight <= 960
                                ? 240
                                : screenHeight <= 1024 ? 290 : 380,
                duration: Duration(seconds: 2),
                glowColor: Colors.white24,
                repeat: true,
                repeatPauseDuration: Duration(seconds: 1),
                startDelay: Duration(seconds: 1),
                child: Material(
                    elevation: 8.0,
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      child: Image.asset('assets/images/logo.png'),
                      radius: screenHeight <= 660
                          ? 75
                          : screenHeight < 812
                              ? 90
                              : screenHeight <= 853
                                  ? 100
                                  : screenHeight <= 960
                                      ? 110
                                      : screenHeight <= 1024 ? 155 : 185,
                    )
                ),
              ),
              DelayedAnimation(
                child: Text(
                  "Hey there!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight <= 660
                          ? 30
                          : screenHeight < 812
                              ? 33
                              : screenHeight <= 853
                                  ? 35
                                  : screenHeight <= 960
                                      ? 40
                                      : screenHeight <= 1024 ? 55 : 70,
                      color: color
                  ),
                ),
                delay: delayedAmount + 1000,
              ),
              DelayedAnimation(
                child: Text(
                  "I'm Mule",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight <= 660
                          ? 30
                          : screenHeight < 812
                              ? 33
                              : screenHeight <= 853
                                  ? 35
                                  : screenHeight <= 960
                                      ? 40
                                      : screenHeight <= 1024 ? 55 : 70,
                      color: color
                  ),
                ),
                delay: delayedAmount + 2000,
              ),
              SizedBox(
                height: screenHeight < 667
                    ? 30.0
                    : screenHeight < 812
                        ? 60.0
                        : screenHeight <= 896
                            ? 70
                            : screenHeight <= 1024 ? 80 : 90,
              ),
              DelayedAnimation(
                child: GestureDetector(
                  /*onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },*/
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  child: Transform.scale(
                    scale: _scale,
                    child: _animatedButtonUI(screenHeight),
                  ),
                ),
                delay: delayedAmount + 4000,
              ),
              SizedBox(
                height: screenHeight <= 896 ? 35 : 50.0,
              ),
              DelayedAnimation(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen())),
                  child: Text(
                    "I already have an account".toUpperCase(),
                    style: TextStyle(
                        fontSize: screenHeight < 670
                            ? 16
                            : screenHeight <= 740
                                ? 18.0
                                : screenHeight < 960
                                    ? 20.0
                                    : screenHeight <= 1024 ? 24.0 : 28.0,
                        fontWeight: FontWeight.bold,
                        color: color),
                  ),
                ),
                delay: delayedAmount + 5000,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _animatedButtonUI(double screenHeight) => Container(
        height: screenHeight < 667
            ? 50
            : screenHeight < 960 ? 60 : screenHeight < 1280 ? 70 : 80,
        width: screenHeight <= 740
            ? 240
            : screenHeight < 960 ? 270 : screenHeight <= 1280 ? 400 : 440,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            'Sign Up',
            style: TextStyle(
              fontSize:
                  screenHeight < 960 ? 20.0 : screenHeight < 1280 ? 25 : 30,
              fontWeight: FontWeight.bold,
              color: AppTheme.lightBlue,
            ),
          ),
        ),
      );

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignupScreen()));
  }
}
