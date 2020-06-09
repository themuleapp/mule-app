import 'package:flutter/material.dart';

class AuthRes {
  final String token;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;

  AuthRes(
      {@required this.token,
      @required this.firstName,
      @required this.lastName,
      @required this.email,
      @required this.phoneNumber});

  AuthRes.fromJson(Map<String, dynamic> json)
      : this.token = json['token'],
        this.firstName = json['firstName'],
        this.lastName = json['lastName'],
        this.email = json['email'],
        this.phoneNumber = json['phoneNumber'];
}