import 'package:flutter/material.dart';

class ChangePasswordReq {
  final String oldPassword;
  final String newPassword;

  ChangePasswordReq({@required this.oldPassword, @required this.newPassword});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    };
  }
}
