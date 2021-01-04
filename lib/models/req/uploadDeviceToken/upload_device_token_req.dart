import 'package:flutter/material.dart';

class UploadDeviceTokenReq {
  final String deviceToken;

  UploadDeviceTokenReq({
    @required this.deviceToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "deviceToken": deviceToken,
    };
  }
}
