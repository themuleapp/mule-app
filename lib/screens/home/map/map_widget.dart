import 'dart:async';

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
import 'package:mule/config/ext_api_calls.dart';
import 'package:mule/config/http_client.dart';
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

  MapWidget({this.controller, this.slidingUpWidgetController});

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
  final int _minClusterZoom = 0;
  final int _maxClusterZoom = 19;
  final double _routeViewPadding = 50.0;

  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  final String _markerImageUrl =
      'https://img.icons8.com/office/80/000000/marker.png';

  final Color _clusterColor = AppTheme.lightBlue;
  final Color _clusterTextColor = AppTheme.white;

  List<LatLng> _markerLocations;
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    super.initState();
    if (!GetIt.I.get<LocationStore>().isLocationLoaded) {
      getCurrentLocation();
    }
    widget.controller?._setState(this);
  }

  void getCurrentLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      StreamSubscription<Position> positionStream = Geolocator()
          .getPositionStream(LocationOptions(
              accuracy: LocationAccuracy.high, distanceFilter: 30))
          .listen((Position position) async {
        if (position != null) {
          await updateLocationOnServerAndGetMulesAround(position);
        }
      });

      await updateLocationOnServerAndGetMulesAround(position);
    } catch (e) {
      print(e);
    }
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/source_pin.png');
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');
  }

  Future updateLocationOnServerAndGetMulesAround(Position position) async {
    LocationData locationData =
        LocationData(lng: position.longitude, lat: position.latitude);
    bool updatedSuccessfully =
        await httpClient.handleUpdateLocation(locationData);
    if (!updatedSuccessfully) {
      print('Location not updated successfully');
    }
    await getMulesAround(locationData, position);
  }

  Future getMulesAround(LocationData locationData, Position position) async {
    MulesAroundRes mulesAround =
        await httpClient.getMulesAroundMeLocation(locationData);
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
    LocationData currentLocation = GetIt.I.get<LocationStore>().currentLocation;
    await updateLocationOnServerAndGetMulesAround(Position(
        latitude: currentLocation.lat, longitude: currentLocation.lng));
    setState(() {
      _isMapLoading = false;
    });
  }

  void _initMarkers() async {
    setState(() {
      _isFocusedOnRoute = false;
    });
    final List<MapMarker> markers = [];

    for (LatLng markerLocation in _markerLocations) {
      final BitmapDescriptor markerImage =
          await MapHelper.getMarkerImageFromUrl(_markerImageUrl);

      markers.add(
        MapMarker(
          id: _markerLocations.indexOf(markerLocation).toString(),
          position: markerLocation,
          icon: markerImage,
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

    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/source_pin.png');
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/destination_map_marker.png');

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

  _showPolyLines() async {
    List<LatLng> polylineCoordinates = [];

    List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
        ExternalApi.googleApiKey,
        GetIt.I.get<LocationStore>().place.location.lat,
        GetIt.I.get<LocationStore>().place.location.lng,
        GetIt.I.get<LocationStore>().destination.location.lat,
        GetIt.I.get<LocationStore>().destination.location.lng);
    if (result.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: AppTheme.lightBlue,
          points: polylineCoordinates,
          width: 4);
      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
  }

  _removePolyLines() {
    setState(() {
      _polylines.clear();
    });
  }

  _setRouteView() async {
    GoogleMapController controller = await _mapCompleter.future;

    controller.moveCamera(
      CameraUpdate.newLatLngBounds(
        boundsFromLocationDataList([
          GetIt.I.get<LocationStore>().destination.location,
          GetIt.I.get<LocationStore>().place.location,
        ]),
        _routeViewPadding,
      ),
    );
  }

  _setDefaultView() async {
    GoogleMapController controller = await _mapCompleter.future;

    controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(
          GetIt.I.get<LocationStore>().currentLocation.lat,
          GetIt.I.get<LocationStore>().currentLocation.lng,
        ),
        _defaultZoom,
      ),
    );
  }

  _routeViewAdjust() async {
    GoogleMapController controller;

    double pixelOffset =
        widget.slidingUpWidgetController.snapHeight / 2 + _routeViewPadding;

    controller = await _mapCompleter.future;
    controller.moveCamera(CameraUpdate.zoomOut());

    controller = await _mapCompleter.future;
    controller.moveCamera(CameraUpdate.scrollBy(0, pixelOffset));
  }

  LatLngBounds boundsFromLocationDataList(List<LocationData> list) {
    assert(list.isNotEmpty);
    double x0, x1, y0, y1;

    for (LocationData latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.lat;
        y0 = y1 = latLng.lng;
      } else {
        if (latLng.lat > x1) x1 = latLng.lat;
        if (latLng.lat < x0) x0 = latLng.lat;
        if (latLng.lng > y1) y1 = latLng.lng;
        if (latLng.lng < y0) y0 = latLng.lng;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
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
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                myLocationEnabled: true,
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
              ),
            ),
          ),
          Opacity(
            opacity: _isMapLoading ? 1 : 0,
            child: Center(child: CircularProgressIndicator()),
          ),

          // Map markers loading indicator
          if (_areMarkersLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Card(
                  elevation: 2,
                  color: Colors.grey.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'Loading',
                      style: TextStyle(color: AppTheme.black),
                    ),
                  ),
                ),
              ),
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

  _setState(_MapWidgetState _mapWidgetState) {
    this._mapWidgetState = _mapWidgetState;
  }

  focusOnRoute() async {
    _mapWidgetState._setRouteMarkers();
    _mapWidgetState._showPolyLines();
    _mapWidgetState._setRouteView();
    _mapWidgetState._routeViewAdjust();
  }

  unfocusRoute() {
    _mapWidgetState._initMarkers();
    _mapWidgetState._removePolyLines();
    _mapWidgetState._setDefaultView();
  }
}
