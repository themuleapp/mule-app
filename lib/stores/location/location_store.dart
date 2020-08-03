import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';
import 'package:mule/models/data/suggestions.dart';

part 'location_store.g.dart';

class LocationStore = _LocationStore with _$LocationStore;

abstract class _LocationStore with Store {
  @observable
  double lat = null;
  @observable
  double lng = null;
  @observable
  Suggestion destination = null;
  @observable
  Suggestion place = null;

  @action
  void updateLocation(Position newPos) {
    lat = newPos.latitude;
    lng = newPos.longitude;
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
  bool get isLocationLoaded => lat != null && lng != null;
}
