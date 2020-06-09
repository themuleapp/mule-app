import 'package:flutter/material.dart';

class VerifyTokenAndEmailReq {
  final String email;
  final String token;

  VerifyTokenAndEmailReq({
    @required this.email,
    @required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "email": email,
      "token": token,
    };
  }
}
