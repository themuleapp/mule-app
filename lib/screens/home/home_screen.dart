import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/models/data/suggestion.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:mule/stores/location/location_store.dart';

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
  Future<OrderData> order = httpClient.getActiveRequest();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: order,
              builder: (context, snapshot) {
                SlidingUpWidget slidingUpWidget = SlidingUpWidget(
                  beginScreen: PanelIndex.Loading,
                  minHeight: screenHeight / 5,
                  maxHeight: screenHeight - 120,
                  controller: controller,
                );
                _checkCurrentActiveStatus(snapshot);
                return slidingUpWidget;
              }),
        ),
      ),
    );
  }

  _checkCurrentActiveStatus(snapshot) {
    if (snapshot.hasData && snapshot.data != null) {
      // TODO Replace fullname check by user being a mule or not
      if (snapshot.data.createdBy != GetIt.I.get<UserInfoStore>().fullName) {
        controller.panelIndex = PanelIndex.DestinationAndSearch;
      } else {
        switch (snapshot.data.status) {
          case (Status.ACCEPTED):
            controller.panelIndex = PanelIndex.Matched;
            break;
          case (Status.OPEN):
            controller.panelIndex = PanelIndex.WaitingToMatch;
            break;
          default:
            controller.panelIndex = PanelIndex.DestinationAndSearch;
        }
        OrderData order = snapshot.data;
        GetIt.I.get<LocationStore>().updateDestination(DestinationSuggestion(
            "", order.destination.description, order.destination.location));
        GetIt.I.get<LocationStore>().updatePlace(PlacesSuggestion(
            "", order.place.description, order.place.location));
      }
    }
  }
}
