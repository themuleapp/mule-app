import 'package:flutter/material.dart';

class ChangePasswordReq {
  final String email;
  final String oldPassword;
  final String newPassword;

  ChangePasswordReq(
      {@required this.email,
      @required this.oldPassword,
      @required this.newPassword});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "email": email,
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    };
  }
}
