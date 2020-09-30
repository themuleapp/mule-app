import 'package:mule/models/data/location_data.dart';

class PlaceRequestData {
  final double lat;
  final double lng;
  final LocationData place;
  final LocationData destination;
  final String requestedItem;

  PlaceRequestData(
    this.lat,
    this.lng,
    this.place,
    this.destination,
    this.requestedItem,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "lat": this.lat,
      "lng": this.lng,
      "place": {
        "lat": this.place.lat,
        "lng": this.place.lng,
      },
      "destination": {
        "lat": this.destination.lat,
        "lng": this.destination.lng,
      },
      "requestedItem": this.requestedItem,
    };
  }
}
