import 'package:mule/models/data/location_data.dart';

class MuleData {
  final String name;
  final LocationData location;
  final String phoneNumber;

  MuleData({this.name, this.location, this.phoneNumber});

  MuleData.fromJson(Map<String, dynamic> jsonData)
      : this.name = jsonData['name'],
        this.phoneNumber = jsonData['phoneNumber'],
        this.location = LocationData.fromJson(jsonData['location']);
}
