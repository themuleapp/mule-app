import 'dart:async';

import 'package:fluster/fluster.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/screens/home/map_helper.dart';
import 'package:mule/screens/home/map_marker.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:mule/stores/location/location_store.dart';
import 'package:mule/widgets/loading-animation.dart';

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  double _currentZoom = 15;
  bool _isMapLoading = true;
  bool _areMarkersLoading = true;

  Completer<GoogleMapController> _mapCompleter = Completer();
  Fluster<MapMarker> _clusterManager;

  final Set<Marker> _markers = Set();
  final int _minClusterZoom = 0;
  final int _maxClusterZoom = 19;

  final String _markerImageUrl =
      'https://img.icons8.com/office/80/000000/marker.png';

  final Color _clusterColor = AppTheme.lightBlue;
  final Color _clusterTextColor = AppTheme.white;

  final List<LatLng> _markerLocations = [
    LatLng(40.793429, -77.860314),
    LatLng(40.793451, -77.860332),
    LatLng(40.793488, -77.860263),
    LatLng(40.793489, -77.860422),
    LatLng(40.792987, -77.860889),
    LatLng(40.793286, -77.860145),
    LatLng(40.793814, -77.859794),
    LatLng(40.793280, -77.859799),
    LatLng(40.792739, -77.859506),
    LatLng(40.793416, -77.860535),
  ];

  @override
  void initState() {
    super.initState();
    if (!GetIt.I.get<LocationStore>().isLocationLoaded) {
      getCurrentLocation();
    }
  }

  void getCurrentLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      GetIt.I.get<LocationStore>().updateLocation(position);
    } catch (_) {
      print('print exception');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapCompleter.complete(controller);
    setState(() {
      _isMapLoading = false;
    });

    _initMarkers();
  }

  void _initMarkers() async {
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
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

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
                    GetIt.I.get<LocationStore>().lat,
                    GetIt.I.get<LocationStore>().lng,
                  ),
                  zoom: 15.0,
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