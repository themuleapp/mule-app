import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';
import 'package:mule/models/data/location_data.dart';
import 'package:mule/models/data/suggestion.dart';

part 'location_store.g.dart';

class LocationStore = _LocationStore with _$LocationStore;

abstract class _LocationStore with Store {
  @observable
  LocationData currentLocation = null;
  @observable
  Suggestion destination = null;
  @observable
  Suggestion place = null;

  @action
  void updateCurrentLocation(Position newPos) {
    currentLocation = LocationData(lat: newPos.latitude, lng: newPos.longitude);
  }

  @action
  void updateDestination(Suggestion newDestination) {
    destination = newDestination;
  }

  @action
  void updatePlace(Suggestion newPlace) {
    place = newPlace;
  }

  @computed
  bool get isLocationLoaded => currentLocation != null;
}
