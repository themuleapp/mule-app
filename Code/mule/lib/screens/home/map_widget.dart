import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mule/screens/home/open_settings_for_location_widget.dart';

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Position _position;
  bool locationIsLoaded = false;
  Completer<GoogleMapController> _mapCompleter = Completer();

  void getCurrentLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        locationIsLoaded = true;
        _position = position;
      });
    } catch (_) {
      print('print exception');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapCompleter.complete(controller);
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  GoogleMap getMap() {
    return GoogleMap(
      mapType: MapType.normal,
      onMapCreated: _onMapCreated,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
      myLocationEnabled: true,
      gestureRecognizers: Set()
        ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
        ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
        ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
        ..add(Factory<HorizontalDragGestureRecognizer>(
            () => HorizontalDragGestureRecognizer()))
        ..add(Factory<VerticalDragGestureRecognizer>(
            () => VerticalDragGestureRecognizer())),
      initialCameraPosition: CameraPosition(
        target: LatLng(_position.latitude, _position.longitude),
        zoom: 15.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (locationIsLoaded) {
      return getMap();
    }
    return OpenSettingsForLocation();
  }
}
