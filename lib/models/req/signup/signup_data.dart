import 'package:flutter/material.dart';

class SignupData {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String password;

  SignupData(
      {@required this.firstName,
      @required this.lastName,
      @required this.email,
      @required this.phoneNumber,
      @required this.password});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phoneNumber": phoneNumber,
      "password": password,
    };
  }
}
