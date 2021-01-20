class PlaceRequestData {
  final double lat;
  final double lng;
  final String place;
  final String destination;
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
      "place": this.place,
      "destination": this.destination,
      "requestedItem": this.requestedItem,
    };
  }
}
