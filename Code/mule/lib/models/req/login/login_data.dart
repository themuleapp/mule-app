import 'package:flutter/material.dart';

class LoginData {
  final String email;
  final String password;

  LoginData({@required this.email, @required this.password});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "email": email,
      "password": password,
    };
  }
}
