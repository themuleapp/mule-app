import 'package:flutter/material.dart';

class VerifyPasswordReq {
  final String email;
  final String token;
  final String password;

  VerifyPasswordReq({
    @required this.email,
    @required this.token,
    @required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "email": email,
      "token": token,
      "password": password,
    };
  }
}
