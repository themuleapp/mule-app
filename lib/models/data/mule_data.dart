import 'package:mule/models/data/location_data.dart';

class MuleData {
  final String name;
  final LocationData location;

  MuleData({this.name, this.location});

  MuleData.fromJson(Map<String, dynamic> jsonData)
      : this.name = jsonData['name'],
        this.location = LocationData.fromJson(jsonData['location']);
}
