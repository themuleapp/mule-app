import 'package:get_it/get_it.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/services/ext_api_calls.dart';
import 'package:mule/stores/location/location_store.dart';

import 'location_data.dart';

abstract class Suggestion {
  String name;
  String vicinity;
  LocationData location;

  Suggestion(this.name, this.vicinity, this.location);
  Suggestion.fromJson();
  String get description => "$name, $vicinity";

  void chooseLocation();
}

class DestinationSuggestion extends Suggestion {
  DestinationSuggestion(String name, String vicinity, LocationData location)
      : super(name, vicinity, location);

  DestinationSuggestion.fromLocationDescription(LocationDesciption location)
      : super("", location.description, location.location);

  DestinationSuggestion.fromJson(Map<String, dynamic> json)
      : super(json["structured_formatting"]["main_text"],
            json["structured_formatting"]["secondary_text"], null);

  void set newLocation(LocationData locationData) {
    this.location = locationData;
  }

  @override
  void chooseLocation() async {
    await ExternalApi.getCoordinatesForDestination(this);
    GetIt.I.get<LocationStore>().updateDestination(this);
  }
}

class PlacesSuggestion extends Suggestion {
  PlacesSuggestion(String name, String vicinity, LocationData location)
      : super(name, vicinity, location);

  PlacesSuggestion.fromLocationDescription(LocationDesciption location)
      : super("", location.description, location.location);

  PlacesSuggestion.fromJson(Map<String, dynamic> json)
      : super(json['name'], json['vicinity'],
            LocationData.fromJson(json['geometry']['location']));

  @override
  void chooseLocation() {
    GetIt.I.get<LocationStore>().updatePlace(this);
  }
}
