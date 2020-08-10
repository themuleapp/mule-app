import 'package:mule/models/data/location_data.dart';

class Suggestion {
  final String name;
  final String vicinity;
  final LocationData location;

  Suggestion(String name, String vicinity, LocationData location)
      : name = name,
        vicinity = vicinity,
        location = location;
}
