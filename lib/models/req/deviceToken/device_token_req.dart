import 'package:flutter/material.dart';

class DeviceTokenReq {
  final String deviceToken;

  DeviceTokenReq({
    @required this.deviceToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "deviceToken": deviceToken,
    };
  }
}
