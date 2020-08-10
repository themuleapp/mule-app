import 'location_data.dart';

class Suggestion {
  String name;
  String vicinity;
  LocationData location;

  Suggestion(this.name, this.vicinity, this.location);
  Suggestion.fromJson();
}

class DestinationSuggestion extends Suggestion {
  DestinationSuggestion(String name, String vicinity, LocationData location)
      : super(name, vicinity, location);

  // todo
  DestinationSuggestion.fromJson(Map<String, dynamic> json)
      : super(json["structured_formatting"]["main_text"],
            json["structured_formatting"]["secondary_text"], null);

  String get description => "$name, $vicinity";

  void set location(LocationData locationData) {
    this.location = locationData;
  }
}

class PlacesSuggestion extends Suggestion {
  PlacesSuggestion(String name, String vicinity, LocationData location)
      : super(name, vicinity, location);

  // TODO
  PlacesSuggestion.fromJson(Map<String, dynamic> json)
      : super(json['name'], json['vicinity'],
            LocationData.fromJson(json['geometry']['location']));
}
