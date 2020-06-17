import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final PanelController _panelController = PanelController();
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _fromFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  bool panelIsOpen = false;
  bool programmaticallyOpeningOrClosing = false;

  AnimationController animationController;
  bool multiple = true;

  Completer<GoogleMapController> _controller = Completer();
  Position _position;
  Widget _child;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void getCurrentLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _position = position;
      _child = mapWidget();
    });
    print(position);
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _searchFocusNode.addListener(_handleSearchFocus);
    getCurrentLocation();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  _handleSearchFocus() {
    if (_searchFocusNode.hasFocus) {
      setState(() {
        programmaticallyOpeningOrClosing = true;
      });
      this._openPanel();
      _searchFocusNode.unfocus();
      _fromFocusNode.requestFocus();
    }
  }

  _openPanel() {
    _panelController.open().then((value) => setState(() {
      programmaticallyOpeningOrClosing = false;
    }));
    setState(() {
      panelIsOpen = true;
    });
  }

  _closePanel() {
    _panelController.close().then((value) => setState(() {
      programmaticallyOpeningOrClosing = false;
    }));
    setState(() {
      panelIsOpen = false;
    });
  }

  _handlePanelSlide(double percentage) {
    if (programmaticallyOpeningOrClosing) {
      return;
    }
    if (!panelIsOpen && percentage >= 0.7) {
      this._openPanel();
    } else if (panelIsOpen && percentage <= 0.5) {
      this._closePanel();
    }
  }

  Widget mapWidget() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(_position.latitude, _position.longitude),
        zoom: 14.0,
      ),
    );
  }


  Widget _getFormDependingPanelOpen() {
    if (panelIsOpen) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _slideIcon(),
          SizedBox(
            height: 20,
          ),
          _destinationTitle(),
          _destinationBar(),
          SizedBox(
            height: 20,
          ),
          _searchBarTitle(),
          _searchBar(),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _slideIcon(),
          _greetingTitle(),
          _destinationTitle(),
          SizedBox(
            height: 10,
          ),
          _destinationBar(),
        ],
      );
    }
  }

  Widget _slideIcon() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Container(
          width: 40.0,
          height: 3.0,
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.lightText.withOpacity(0.3),
              shape: BoxShape.rectangle,
              borderRadius:
              BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _greetingTitle() {
    return Container(
      padding: EdgeInsets.only(
        top: 30,
      ),
      child: Observer(
        builder: (_) => Text(
          "Hey there, " + GetIt.I.get<UserInfoStore>().firstName + "!",
          style: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w400,
            color: AppTheme.darkGrey,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _destinationTitle() {
    return Container(
      padding: EdgeInsets.only(
        top: 5,
        bottom: 10
      ),
      child: Text(
        "Where are you headed?",
        style: TextStyle(
          fontFamily: AppTheme.fontName,
          fontWeight: FontWeight.w700,
          color: AppTheme.darkGrey,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _destinationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightGrey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            splashColor: AppTheme.lightBlue,
            icon: Icon(
              Icons.add_location,
              color: AppTheme.secondaryBlue,
            ),
            onPressed: () {},
          ),
          Expanded(
            child: TextFormField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              cursorColor: AppTheme.lightBlue,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 15
                  ),
                  hintText: "Destination..."
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBarTitle() {
    return Container(
      padding: EdgeInsets.only(
        top: 5,
        bottom: 10,
      ),
      child: Text(
        "What would you like?",
        style: TextStyle(
          fontFamily: AppTheme.fontName,
          fontWeight: FontWeight.w700,
          color: AppTheme.darkGrey,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightGrey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            splashColor: AppTheme.lightBlue,
            icon: Icon(
              Icons.search,
              color: AppTheme.secondaryBlue,
            ),
            onPressed: () {},
          ),
          Expanded(
            child: TextFormField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              cursorColor: AppTheme.lightBlue,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 15
                  ),
                  hintText: "Search..."
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(20.0),
      topRight: Radius.circular(20.0),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SlidingUpPanel(
          borderRadius: radius,
          onPanelSlide: this._handlePanelSlide,
          minHeight: MediaQuery.of(context).size.height / 4,
          maxHeight: MediaQuery.of(context).size.height - 120,
          controller: _panelController,
          panel: Form(
            child: Container(
              padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
              child: _getFormDependingPanelOpen(),
            ),
          ),
          body: Center(
            child: _child,
          ),
        ),
      ),
    );
  }
}