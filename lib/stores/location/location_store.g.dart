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
  String toString() {
    return '''
lat: ${lat},
lng: ${lng},
isLocationLoaded: ${isLocationLoaded}
    ''';
  }
}
