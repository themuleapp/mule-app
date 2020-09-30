import 'package:mule/models/data/location_data.dart';
import 'package:mule/models/data/mule_data.dart';

class Order {
  final LocationData place;
  final LocationData destination;
  final Status status;
  final MuleData mule;

  Order.fromJson(Map<String, dynamic> jsonData)
      : this.place = LocationData.fromJson(jsonData['place']),
        this.destination = LocationData.fromJson(jsonData['destination']),
        this.status = _statusFromString(jsonData['status']),
        this.mule = (_statusFromString(jsonData['status']) == Status.ACCEPTED)
            ? MuleData.fromJson(jsonData['mule'])
            : null;
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
