import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mule/Screens/Login/login_screen.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:mule/Screens/Signup/signup_screen.dart';
import 'package:mule/Widgets/delayed_animation.dart';
import 'package:mule/config/app_theme.dart';

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
    final color = Colors.white;
    _scale = 1 - _controller.value;
    return Scaffold(
      backgroundColor: AppTheme.lightBlue,
      body: Center(
        child: Column(
          children: <Widget>[
            AvatarGlow(
              endRadius: 250,
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
                    radius: 100.0,
                  )),
            ),
            DelayedAnimation(
              child: Text(
                "Hey there!",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 35.0, color: color),
              ),
              delay: delayedAmount + 1000,
            ),
            DelayedAnimation(
              child: Text(
                "I'm Mule",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 35.0, color: color),
              ),
              delay: delayedAmount + 2000,
            ),
            SizedBox(
              height: 30.0,
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
                  child: _animatedButtonUI,
                ),
              ),
              delay: delayedAmount + 4000,
            ),
            SizedBox(
              height: 50.0,
            ),
            DelayedAnimation(
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen())),
                child: Text(
                  "I already have an account".toUpperCase(),
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color),
                ),
              ),
              delay: delayedAmount + 5000,
            ),
          ],
        ),
      ),
    );
  }

  Widget get _animatedButtonUI => Container(
        height: 60,
        width: 270,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 20.0,
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
