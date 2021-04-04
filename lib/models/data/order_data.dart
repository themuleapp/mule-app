import 'package:flutter/material.dart';
import 'package:mule/models/data/location_data.dart';
import 'package:mule/models/data/user_data.dart';

// TODO Should this be in a response?
class OrderData with ChangeNotifier {
  final String id;
  final LocationDesciption place;
  final LocationDesciption destination;
  final DateTime createdAt;
  final UserData createdBy;

  MuleData acceptedBy;
  Status status;

  OrderData.fromJson(Map<String, dynamic> jsonData)
      : this.id = jsonData['id'],
        this.place = LocationDesciption.fromJson(jsonData['place']),
        this.destination = LocationDesciption.fromJson(jsonData['destination']),
        this.status = _statusFromString(jsonData['status']),
        this.createdAt = DateTime.parse(jsonData['createdAt']),
        this.createdBy = UserData.fromJson(jsonData['createdBy']),
        // Mule is only available when active request is accepted
        this.acceptedBy = (jsonData['acceptedBy'] != null)
            ? MuleData.fromJson(jsonData['acceptedBy'])
            : null;

  void update(OrderData other) {
    if (other == null) {
      this.id == null;
    } else {
      this.acceptedBy = other.acceptedBy;
      this.status = other.status;
    }
    notifyListeners();
  }
}

class LocationDesciption {
  final LocationData location;
  final String description;

  LocationDesciption(this.location, this.description);

  LocationDesciption.fromJson(Map<String, dynamic> jsonData)
      : this.description = jsonData['addressString'],
        this.location =
            LocationData(lat: jsonData['lat'], lng: jsonData['lng']);
}

Status _statusFromString(String status) {
  switch (status) {
    case "open":
      return Status.OPEN;
      break;
    case "accepted":
      return Status.ACCEPTED;
      break;
    case "dismissed":
      return Status.DISMISSED;
      break;
    case "completed":
      return Status.COMPLETED;
      break;
    default:
      throw UnimplementedError("Order status not recognized");
  }
}

enum Status {
  OPEN,
  ACCEPTED,
  DISMISSED,
  COMPLETED,
}
