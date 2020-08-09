import 'package:mule/models/data/location_data.dart';
import 'package:mule/models/data/suggestion.dart';
import 'package:dio/dio.dart';

class ExternalApi {
  static final String googleApiKey = "AIzaSyCZQ2LiMZViXvH7xoSA5M2sK635Bgui2zs";

  static Future<List<LocationSuggestion>> getNearbyLocations(
      String searchTerm, LocationData locationData, int searchRadius) async {
    if (searchTerm.isEmpty) {
      return null;
    }
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    // testlocation:
    // location=40.793429,-77.860314
    String request = '$baseURL?input=$searchTerm&key=$googleApiKey' +
        '&location=${locationData.lat},${locationData.lng}' +
        '&radius=$searchRadius&strictbounds';

    Response res = await Dio().get(request);
    return res.data['predictions']
        .map<LocationSuggestion>(
            (singleData) => LocationSuggestion.fromJson(singleData))
        .toList();
  }

  static Future<List<Suggestion>> getNearbyPlaces(
      String searchTerm, LocationData locationData, int searchRadius) async {
    if (searchTerm.isEmpty) {
      return null;
    }
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    String request = '$baseURL?keyword=$searchTerm&key=$googleApiKey' +
        '&location=${locationData.lat},${locationData.lng}' +
        '&radius=$searchRadius&';

    Response res = await Dio().get(request);
    if (res == null) return null;
    return res.data['results']
        .map<PlacesSuggestion>(
            (singleData) => PlacesSuggestion.fromJson(singleData))
        .toList();
  }
}
