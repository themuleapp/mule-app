import 'package:flutter/material.dart';

class VerifyTokenAndEmailReq {
  final String email;
  final String resetToken;

  VerifyTokenAndEmailReq({
    @required this.email,
    @required this.resetToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "email": email,
      "resetToken": resetToken,
    };
  }
}
