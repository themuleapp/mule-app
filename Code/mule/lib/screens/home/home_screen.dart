import 'dart:async';

import 'package:flutter/material.dart';
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
  AnimationController animationController;
  bool multiple = true;

  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 14.0,
              ),
            ),
            SlidingUpPanel(
              minHeight: 250,
              maxHeight: 350,
              borderRadius: BorderRadius.circular(25),
              panel: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
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
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: 20,
                        left: 20,
                        right: 20
                    ),
                    child: Text(
                      "Hey there, " + GetIt.I.get<UserInfoStore>().firstName + "!",
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.darkGrey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: 5,
                        bottom: 20,
                        left: 20,
                        right: 20
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
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 20,
                        right: 20
                    ),
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
                          child: TextField(
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
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
