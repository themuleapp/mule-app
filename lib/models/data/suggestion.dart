class Suggestion {}

class LocationSuggestion extends Suggestion {
  String description;
  String placeId;

  LocationSuggestion.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        placeId = json['place_id'];
}

class PlacesSuggestion extends Suggestion {
  String name;
  String description;
  String vicinity;

  PlacesSuggestion(String description, String vicinity)
      : description = description,
        vicinity = vicinity;

  PlacesSuggestion.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        vicinity = json['vicinity'];
}
