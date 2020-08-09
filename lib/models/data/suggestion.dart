import 'package:flutter/cupertino.dart';
import 'package:google_maps_webservice/places.dart';

class Suggestion {
  String description;
}

class LocationSuggestion extends Suggestion {
  String placeId;
  String description;

  LocationSuggestion({this.placeId, this.description});

  LocationSuggestion.fromJson(Map<String, dynamic> json)
      : this.description = json['description'],
        this.placeId = json['place_id'];
}

class PlacesSuggestion extends Suggestion {
  String name;
  String description;

  PlacesSuggestion({this.name, this.description});

  PlacesSuggestion.fromJson(Map<String, dynamic> json)
      : this.name = json['name'],
        this.description = json['vicinity'];
}
