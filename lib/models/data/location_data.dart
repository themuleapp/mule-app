import 'package:flutter/material.dart';

class LocationData {
  final double lng;
  final double lat;

  LocationData({
    @required this.lng,
    @required this.lat,
  });

  LocationData.fromJson(Map<String, dynamic> jsonData)
      : this.lng = jsonData['lng'],
        this.lat = jsonData['lat'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "lng": lng,
      "lat": lat,
    };
  }
}
