import 'package:mule/models/data/location_data.dart';

class UserData {
  String name;
  String phoneNumber;
  String profilePicture;

  UserData({this.name, this.phoneNumber, this.profilePicture});

  UserData.fromJson(Map<String, dynamic> jsonData)
      : this.name = jsonData['name'],
        this.phoneNumber = jsonData['phoneNumber'],
        this.profilePicture = jsonData['profilePicture'];
}

class MuleData extends UserData {
  String name;
  String phoneNumber;
  LocationData location;
  String profilePicture;

  MuleData(
      {String name, String phoneNumber, this.location, this.profilePicture})
      : super(name: name, phoneNumber: phoneNumber);

  MuleData.fromJson(Map<String, dynamic> jsonData)
      : name = jsonData['name'],
        phoneNumber = jsonData['phoneNumber'],
        this.location = LocationData.fromJson(jsonData['location']),
        this.profilePicture = jsonData['profilePicture'];
}
