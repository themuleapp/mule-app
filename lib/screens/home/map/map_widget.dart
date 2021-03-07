import 'dart:async';

import 'package:latlong/latlong.dart' as latlong;
import 'package:fluster/fluster.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/services/ext_api_calls.dart';
import 'package:mule/services/mule_api_service.dart';
import 'package:mule/models/data/location_data.dart';
import 'package:mule/models/res/mulesAroundRes/mules_around_res.dart';
import 'package:mule/screens/home/map/map_helper.dart';
import 'package:mule/screens/home/map/map_marker.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/stores/location/location_store.dart';
import 'package:mule/widgets/loading-animation.dart';

class MapWidget extends StatefulWidget {
  final MapController controller;
  final SlidingUpWidgetController slidingUpWidgetController;
  final Function initCallback;
  final isDraggable;

  MapWidget({
    this.controller,
    this.slidingUpWidgetController,
    this.initCallback,
    this.isDraggable,
  });

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  double _currentZoom = null;
  bool _isFocusedOnRoute = false;
  bool _isMapLoading = true;
  bool _areMarkersLoading = true;

  Completer<GoogleMapController> _mapCompleter = Completer();
  GoogleMapController googleMapController;
  Fluster<MapMarker> _clusterManager;

  final double _defaultZoom = 15;
  final Set<Marker> _markers = Set();
  final Set<Polyline> _polylines = Set();
  final List<LatLng> _polylineCoords = [];
  final int _minClusterZoom = 0;
  final int _maxClusterZoom = 19;
  final double _routeViewPadding = 50.0;

  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  final Color _clusterColor = AppTheme.lightBlue;
  final Color _clusterTextColor = AppTheme.white;

  List<LatLng> _markerLocations;
  PolylinePoints polylinePoints = PolylinePoints();
  Position currentPosition;

  @override
  void initState() {
    if (!GetIt.I.get<LocationStore>().isLocationLoaded) {
      getCurrentLocation();
    }
    widget.controller?._setState(this);
    widget.initCallback();
    super.initState();
  }

  // void set draggable(bool isDraggable) {
  //   setState(() => this.isDraggable = isDraggable);
  // }

  Future<Position> getCurrentLocation() async {
    Position position = null;

    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      await updateLocationOnServerAndGetMulesAround(position);
    } catch (e) {
      print(e);
    }
    return position;
  }

  Future updateLocationOnServerAndGetMulesAround(Position position) async {
    LocationData locationData =
        LocationData(lng: position.longitude, lat: position.latitude);

    bool updatedSuccessfully =
        await muleApiService.handleUpdateLocation(locationData);
    if (!updatedSuccessfully) {
      print('Location not updated successfully');
    }
  }

  void _setMuleMarkers(Position position) async {
    LocationData locationData =
        LocationData(lng: position.longitude, lat: position.latitude);

    MulesAroundRes mulesAround =
        await muleApiService.getMulesAroundMeLocation(locationData);
    GetIt.I.get<LocationStore>().updateCurrentLocation(position);

    setState(() {
      _markerLocations =
          mulesAround.mules.map((e) => LatLng(e.lat, e.lng)).toList();
    });
    _initMarkers();
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapCompleter.complete(controller);
    googleMapController = controller;
    _currentZoom = _defaultZoom;

    if (!GetIt.I.get<LocationStore>().isLocationLoaded) {
      await getCurrentLocation();
    }
    setState(() {
      _isMapLoading = false;
    });
    widget.initCallback();
  }

  void _initMarkers() async {
    setState(() {
      _isFocusedOnRoute = false;
    });
    final List<MapMarker> markers = [];

    for (LatLng markerLocation in _markerLocations) {
      final muleIcon = await MapHelper.getBitmapDescriptorFromAssetBytes(
          'assets/images/mule_marker.png', 60);

      markers.add(
        MapMarker(
          id: _markerLocations.indexOf(markerLocation).toString(),
          position: markerLocation,
          icon: muleIcon,
        ),
      );
    }

    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers();
  }

  _singleMuleMarker(LatLng muleLocation) async {
    final muleIcon = await MapHelper.getBitmapDescriptorFromAssetBytes(
        'assets/images/mule_marker.png', 60);

    Marker muleMarker = Marker(
      markerId: MarkerId("MULEMARKER"),
      position: muleLocation,
      icon: muleIcon,
    );
    setState(() {
      _markers..add(muleMarker);
    });
  }

  Future<void> _updateMarkers([double updatedZoom]) async {
    if (_isFocusedOnRoute ||
        _clusterManager == null ||
        updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    setState(() {
      _areMarkersLoading = true;
    });

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {
      _areMarkersLoading = false;
    });
  }

  _setRouteMarkers() async {
    _markers.clear();

    final sourceIcon = await MapHelper.getBitmapDescriptorFromAssetBytes(
        'assets/images/source_marker.png', 60);
    final destinationIcon = await MapHelper.getBitmapDescriptorFromAssetBytes(
        'assets/images/destination_marker.png', 60);

    setState(() {
      _isFocusedOnRoute = true;
      _areMarkersLoading = true;
    });

    // source pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: LatLng(GetIt.I.get<LocationStore>().place.location.lat,
            GetIt.I.get<LocationStore>().place.location.lng),
        icon: sourceIcon));
    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: LatLng(GetIt.I.get<LocationStore>().destination.location.lat,
            GetIt.I.get<LocationStore>().destination.location.lng),
        icon: destinationIcon));

    setState(() {
      _areMarkersLoading = false;
    });
  }

  _showPolyLines({PointLatLng origin, PointLatLng destination}) async {
    // Polylines should be cleared when not used or updating
    if (_polylineCoords != null && !_polylineCoords.isEmpty) {
      return;
    }
    List<LatLng> polylineCoordinates = [];

    if (origin == null || destination == null) {
      origin = PointLatLng(
        GetIt.I.get<LocationStore>().place.location.lat,
        GetIt.I.get<LocationStore>().place.location.lng,
      );
      destination = PointLatLng(
        GetIt.I.get<LocationStore>().destination.location.lat,
        GetIt.I.get<LocationStore>().destination.location.lng,
      );
    }

    PolylineResult result = await polylinePoints?.getRouteBetweenCoordinates(
        ExternalApi.googleApiKey, origin, destination,
        travelMode: TravelMode.walking);
    if (result.points.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.points.removeLast();
      result.points.removeLast();
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: AppTheme.lightBlue,
          points: _polylineCoords,
          width: 4);
      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
    _polylineCoords.addAll(polylineCoordinates);
  }

  _removePolyLines() {
    setState(() {
      _polylines.clear();
      _polylineCoords.clear();
    });
  }

  _setRouteView({List<LatLng> focusLocation = const []}) async {
    GoogleMapController controller = await _mapCompleter.future;

    LatLngBounds bounds = boundsFromLocationDataList([
      GetIt.I.get<LocationStore>().destination.location.toLatLng(),
      GetIt.I.get<LocationStore>().place.location.toLatLng(),
    ]
      ..addAll(_polylineCoords)
      ..addAll(focusLocation));

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        bounds,
        _routeViewPadding,
      ),
    );
  }

  _setDefaultView() async {
    GoogleMapController controller = await _mapCompleter.future;

    controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        GetIt.I.get<LocationStore>().currentLocation.toLatLng(),
        _defaultZoom,
      ),
    );
  }

  LatLngBounds boundsFromLocationDataList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0, x1, y0, y1;

    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    LatLng northeast = LatLng(x1, y1);
    LatLng southwest = LatLng(x0, y0);

    return LatLngBounds(northeast: northeast, southwest: southwest);
  }

  double calculateDistance(LatLng x, LatLng y) {
    latlong.Distance distance = latlong.Distance();
    return distance.as(
      latlong.LengthUnit.Kilometer,
      latlong.LatLng(x.latitude, x.longitude),
      latlong.LatLng(y.latitude, y.longitude),
    );
  }

  getMap() {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Google Map widget
          Opacity(
            opacity: _isMapLoading ? 0 : 1,
            child: Observer(
              builder: (_) => GoogleMap(
                mapType: MapType.normal,
                scrollGesturesEnabled: widget.isDraggable,
                zoomGesturesEnabled: widget.isDraggable,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                markers: _markers,
                polylines: _polylines,
                onMapCreated: (controller) => _onMapCreated(controller),
                onCameraMove: (position) => _updateMarkers(position.zoom),
                gestureRecognizers: Set()
                  ..add(Factory<PanGestureRecognizer>(
                      () => PanGestureRecognizer()))
                  ..add(Factory<ScaleGestureRecognizer>(
                      () => ScaleGestureRecognizer()))
                  ..add(Factory<TapGestureRecognizer>(
                      () => TapGestureRecognizer()))
                  ..add(Factory<HorizontalDragGestureRecognizer>(
                      () => HorizontalDragGestureRecognizer()))
                  ..add(Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer())),
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    GetIt.I.get<LocationStore>().currentLocation.lat,
                    GetIt.I.get<LocationStore>().currentLocation.lng,
                  ),
                  zoom: _defaultZoom,
                ),
                padding: EdgeInsets.only(
                  top: 30,
                  bottom: (widget.slidingUpWidgetController == null)
                      ? 0
                      : widget.slidingUpWidgetController.panel.minHeight,
                ),
              ),
            ),
          ),
          Opacity(
            opacity: _isMapLoading ? 1 : 0,
            child:
                Center(child: SpinKitDoubleBounce(color: AppTheme.lightBlue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (!GetIt.I.get<LocationStore>().isLocationLoaded) {
          return SpinKitDoubleBounce(color: AppTheme.lightBlue);
        }
        return getMap();
      },
    );
  }
}

class MapController {
  _MapWidgetState _mapWidgetState;

  void _setState(_MapWidgetState _mapWidgetState) {
    this._mapWidgetState = _mapWidgetState;
  }

  void setMuleMarkers() async {
    Position currentPosition = await _mapWidgetState.getCurrentLocation();
    await _mapWidgetState._setMuleMarkers(currentPosition);
  }

  void focusOnRoute() async {
    await _mapWidgetState._setRouteView();
  }

  // void set draggable(bool isDraggable) {
  //   _mapWidgetState.draggable = isDraggable;
  // }

  // These functions do not do well asyncronously, so keep the await keyword
  void setRouteView() async {
    await _mapWidgetState._showPolyLines();
    await _mapWidgetState._setRouteMarkers();
    await _mapWidgetState._setRouteView();
  }

  void unsetRouteView() async {
    await setMuleMarkers();
    await _mapWidgetState._initMarkers();
    await _mapWidgetState._removePolyLines();
    await _mapWidgetState._setDefaultView();
  }

  void focusCurrentLocation() {
    _mapWidgetState._setDefaultView();
  }

  void updateDelivery(LatLng muleLocation, LatLng place, LatLng destination,
      double triggerDistance) async {
    await _mapWidgetState._removePolyLines();

    PointLatLng target;
    PointLatLng origin =
        PointLatLng(muleLocation.latitude, muleLocation.longitude);
    if (_mapWidgetState.calculateDistance(muleLocation, place) <
        triggerDistance) {
      target = PointLatLng(place.latitude, place.longitude);
    } else {
      target = PointLatLng(destination.latitude, destination.longitude);
    }
    await _mapWidgetState._showPolyLines(
      origin: origin,
      destination: target,
    );
    await _mapWidgetState._setRouteMarkers();
    await _mapWidgetState._setRouteView(focusLocation: [muleLocation]);
    await _mapWidgetState._singleMuleMarker(muleLocation);
  }

  bool get isMapLoading {
    return _mapWidgetState == null || _mapWidgetState._isMapLoading;
  }
}
