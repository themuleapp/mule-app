// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LocationStore on _LocationStore, Store {
  Computed<bool> _$isLocationLoadedComputed;

  @override
  bool get isLocationLoaded => (_$isLocationLoadedComputed ??= Computed<bool>(
          () => super.isLocationLoaded,
          name: '_LocationStore.isLocationLoaded'))
      .value;

  final _$latAtom = Atom(name: '_LocationStore.lat');

  @override
  double get lat {
    _$latAtom.reportRead();
    return super.lat;
  }

  @override
  set lat(double value) {
    _$latAtom.reportWrite(value, super.lat, () {
      super.lat = value;
    });
  }

  final _$lngAtom = Atom(name: '_LocationStore.lng');

  @override
  double get lng {
    _$lngAtom.reportRead();
    return super.lng;
  }

  @override
  set lng(double value) {
    _$lngAtom.reportWrite(value, super.lng, () {
      super.lng = value;
    });
  }

  final _$destinationAtom = Atom(name: '_LocationStore.destination');

  @override
  Suggestion get destination {
    _$destinationAtom.reportRead();
    return super.destination;
  }

  @override
  set destination(Suggestion value) {
    _$destinationAtom.reportWrite(value, super.destination, () {
      super.destination = value;
    });
  }

  final _$placeAtom = Atom(name: '_LocationStore.place');

  @override
  Suggestion get place {
    _$placeAtom.reportRead();
    return super.place;
  }

  @override
  set place(Suggestion value) {
    _$placeAtom.reportWrite(value, super.place, () {
      super.place = value;
    });
  }

  final _$_LocationStoreActionController =
      ActionController(name: '_LocationStore');

  @override
  void updateLocation(Position newPos) {
    final _$actionInfo = _$_LocationStoreActionController.startAction(
        name: '_LocationStore.updateLocation');
    try {
      return super.updateLocation(newPos);
    } finally {
      _$_LocationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateDestination(Suggestion newDestination) {
    final _$actionInfo = _$_LocationStoreActionController.startAction(
        name: '_LocationStore.updateDestination');
    try {
      return super.updateDestination(newDestination);
    } finally {
      _$_LocationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updatePlace(Suggestion newPlace) {
    final _$actionInfo = _$_LocationStoreActionController.startAction(
        name: '_LocationStore.updatePlace');
    try {
      return super.updatePlace(newPlace);
    } finally {
      _$_LocationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
lat: ${lat},
lng: ${lng},
destination: ${destination},
place: ${place},
isLocationLoaded: ${isLocationLoaded}
    ''';
  }
}
