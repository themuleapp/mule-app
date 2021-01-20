import 'package:mule/models/data/order_data.dart';

class PlaceRequestData {
  final LocationDesciption place;
  final LocationDesciption destination;

  PlaceRequestData(
    this.place,
    this.destination,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "place": {
        "addressString": this.place.description,
        "lat": this.place.location.lat,
        "lng": this.place.location.lng,
      },
      "destination": {
        "addressString": this.destination.description,
        "lat": this.destination.location.lat,
        "lng": this.destination.location.lng,
      },
    };
  }
}
