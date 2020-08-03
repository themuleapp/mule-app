import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';

part 'location_store.g.dart';

class LocationStore = _LocationStore with _$LocationStore;

abstract class _LocationStore with Store {
  @observable
  double lat = null;
  @observable
  double lng = null;

  @action
  void updateLocation(Position newPos) {
    lat = newPos.latitude;
    lng = newPos.longitude;
  }

  @computed
  bool get isLocationLoaded => lat != null && lng != null;
}
