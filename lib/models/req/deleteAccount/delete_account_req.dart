import 'package:flutter/material.dart';

class DeleteAccountReq {
  String reason;

  DeleteAccountReq({@required this.reason});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "reason": reason,
    };
  }
}