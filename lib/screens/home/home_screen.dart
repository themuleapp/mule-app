import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mule/models/data/user_data.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/panel.dart';
import 'package:mule/screens/home/slider/search/search_panel.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final SlidingUpWidgetController controller = SlidingUpWidgetController();
  MuleData mule;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final double screenHeight = MediaQuery.of(context).size.height;
    final MapController mapController = MapController();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: SlidingUpWidget(
            controller: controller,
            screenHeight: screenHeight,
            mapController: mapController,
          ),
        ),
      ),
    );
  }
}
