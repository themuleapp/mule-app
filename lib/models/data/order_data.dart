import 'package:mule/models/data/location_data.dart';
import 'package:mule/models/data/mule_data.dart';

// TODO Should this be in a response?
class Order {
  final String id;
  final LocationDesciption place;
  final LocationDesciption destination;
  final Status status;
  final DateTime createdAt;
  final String createdBy;
  final MuleData acceptedBy;

  Order.fromJson(Map<String, dynamic> jsonData)
      : this.id = jsonData['id'],
        this.place = LocationDesciption.fromJson(jsonData['place']),
        this.destination = LocationDesciption.fromJson(jsonData['destination']),
        this.status = _statusFromString(jsonData['status']),
        this.createdAt = DateTime.parse(jsonData['createdAt']),
        this.createdBy = jsonData['createdBy'],
        // Mule is only available when active request is accepted
        this.acceptedBy =
            (_statusFromString(jsonData['status']) == Status.ACCEPTED)
                ? MuleData.fromJson(jsonData['mule'])
                : null;
}

class LocationDesciption {
  final LocationData location;
  final String description;

  LocationDesciption({this.location, this.description});

  LocationDesciption.fromJson(Map<String, dynamic> jsonData)
      : this.description = jsonData['addressString'],
        this.location = LocationData.fromJson(jsonData['location']);
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
