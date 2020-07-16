import 'package:flutter/material.dart';

class ForgotPasswordReq {
  final String email;

  ForgotPasswordReq({@required this.email});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "email": email,
    };
  }
}
