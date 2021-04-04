import 'package:get_it/get_it.dart';
import 'package:mule/config/config.dart';
import 'package:mule/models/data/location_data.dart';
import 'package:mule/models/data/suggestion.dart';
import 'package:dio/dio.dart';
import 'package:mule/stores/location/location_store.dart';

class ExternalApi {
  static final String googleApiKey = "AIzaSyCZQ2LiMZViXvH7xoSA5M2sK635Bgui2zs";

  static Future<List<DestinationSuggestion>> getNearbyLocations(
      String searchTerm) async {
    if (searchTerm.isEmpty) {
      return null;
    }
    //LocationData locationData = Config.pennStateLocation;
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    // testlocation:
    // location=40.793429,-77.860314
    String request = '$baseURL?input=$searchTerm&key=$googleApiKey' +
        '&location=${GetIt.I.get<LocationStore>().currentLocation.lat},${GetIt.I.get<LocationStore>().currentLocation.lng}' +
        '&radius=${Config.DESTINATION_SEARCH_RADIUS}&strictbounds';

    Response res = await Dio().get(request);
    return res.data['predictions']
        .map<DestinationSuggestion>(
            (singleData) => DestinationSuggestion.fromJson(singleData))
        .toList();
  }

  static Future<List<Suggestion>> getNearbyPlaces(String searchTerm) async {
    if (searchTerm.isEmpty ||
        GetIt.I.get<LocationStore>().destination == null) {
      return null;
    }
    LocationData locationData =
        GetIt.I.get<LocationStore>().destination.location;

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    String request = '$baseURL?keyword=$searchTerm&key=$googleApiKey' +
        '&location=${locationData.lat},${locationData.lng}' +
        '&radius=${Config.PLACES_SEARCH_RADIUS}&';

    Response res = await Dio().get(request);
    if (res == null) return null;
    return res.data['results']
        .map<PlacesSuggestion>(
            (singleData) => PlacesSuggestion.fromJson(singleData))
        .toList();
  }

  static getCoordinatesForDestination(
      DestinationSuggestion destinationSuggestion) async {
    String baseURL =
        "https://maps.googleapis.com/maps/api/place/findplacefromtext/json" +
            "?input=${destinationSuggestion.description}&inputtype=textquery&fields=geometry&key=$googleApiKey";
    Response locationRes = await Dio().get(baseURL);
    if (locationRes.data['candidates'].length < 1) {
      print('Oh no there are no candidates for the destination coordinates');
    }
    destinationSuggestion.newLocation = LocationData.fromJson(
        locationRes.data['candidates'][0]['geometry']['location']);
  }
}
