import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mule/Screens/homepage.dart';
import 'package:mule/Screens/login.dart';
import 'package:mule/Screens/signup.dart';

// Routes
const String SignUpRoute = "signup";
const String LoginRoute = "login";

// Router
Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SignUpRoute:
      return MaterialPageRoute(builder: (BuildContext context) => SignUp());
    case LoginRoute:
      return MaterialPageRoute(builder: (BuildContext context) => Login());
    default:
      return MaterialPageRoute(builder: (BuildContext context) => HomePage());
  }
}
