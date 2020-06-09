import 'package:flutter/material.dart';

class VerifyPasswordReq {
  final String email;
  final String resetToken;
  final String password;

  VerifyPasswordReq({
    @required this.email,
    @required this.resetToken,
    @required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "email": email,
      "resetToken": resetToken,
      "password": password,
    };
  }
}
