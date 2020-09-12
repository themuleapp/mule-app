import 'package:flutter/material.dart';
import 'package:mule/models/data/location_data.dart';

class RequestedFromMeRes {
  String id;
  String place;
  String destination;
  String requestedItem;
  DateTime createdAt;

  List<LocationData> mules;

  RequestedFromMeRes({
    @required this.id,
    @required this.place,
    @required this.destination,
    @required this.requestedItem,
    @required this.createdAt,
  });

  RequestedFromMeRes.fromJson(Map<String, dynamic> jsonData)
      : this.id = jsonData['_id'],
        this.place = jsonData['place'],
        this.destination = jsonData['destination'],
        this.requestedItem = jsonData['requestedItem'],
        this.createdAt = DateTime.parse(jsonData['createdAt']);
}
