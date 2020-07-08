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
                endRadius: AppTheme.elementSize(
                    screenHeight, 150, 165, 180, 210, 240, 290, 320, 380),
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
                      radius: AppTheme.elementSize(
                          screenHeight, 75, 85, 90, 100, 110, 155, 160, 185),
                    )
                ),
              ),
              DelayedAnimation(
                child: Text(
                  "Hey there!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppTheme.elementSize(
                          screenHeight, 30, 32, 33, 35, 40, 55, 65, 75),
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
                      fontSize: AppTheme.elementSize(
                          screenHeight, 30, 32, 33, 35, 40, 55, 65, 75),
                      color: color
                  ),
                ),
                delay: delayedAmount + 2000,
              ),
              SizedBox(
                height: AppTheme.elementSize(
                    screenHeight, 30, 45, 60, 70, 75, 80, 90, 95
                ),
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
                height: AppTheme.elementSize(
                    screenHeight, 28, 30, 32, 35, 37, 41, 45, 50),
              ),
              DelayedAnimation(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen())),
                  child: Text(
                    "I already have an account".toUpperCase(),
                    style: TextStyle(
                        fontSize: AppTheme.elementSize(
                            screenHeight, 16, 17, 18, 20, 22, 24, 28, 30),
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
        height: AppTheme.elementSize(
            screenHeight, 50, 52.5, 55, 57, 60, 65, 80, 85),
        width: AppTheme.elementSize(
            screenHeight, 200, 220, 240, 250, 270, 320, 370, 420),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: AppTheme.white,
        ),
        child: Center(
          child: Text(
            'Sign Up',
            style: TextStyle(
              fontSize: AppTheme.elementSize(
                  screenHeight, 20, 21, 22, 24, 25, 26, 28, 30),
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
