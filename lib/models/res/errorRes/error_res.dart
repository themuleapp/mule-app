import 'package:flutter/material.dart';

class ErrorRes {
  final int status;
  final List<String> errors;

  ErrorRes({
    @required this.status,
    @required this.errors,
  });

  ErrorRes.fromJson(Map<String, dynamic> jsonData)
      : this.status = jsonData['status'],
        errors = List()..addAll(jsonData['errors'].cast<String>());
}
