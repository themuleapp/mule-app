import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/models/data/order_data.dart';
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
  Future<Status> orderStatus =
      httpClient.getActiveRequest().then((value) => value.status);

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
              future: orderStatus,
              builder: (context, snapshot) {
                SlidingUpWidget slidingUpWidget = SlidingUpWidget(
                  beginScreen: PanelIndex.Loading,
                  minHeight: screenHeight / 5,
                  maxHeight: screenHeight - 120,
                  controller: controller,
                );
                if (snapshot.hasData && snapshot.data != null) {
                  switch (snapshot.data) {
                    case (Status.ACCEPTED):
                      controller.panelIndex = PanelIndex.Matched;
                      break;
                    case (Status.OPEN):
                      controller.panelIndex = PanelIndex.WaitingToMatch;
                      break;
                    default:
                      controller.panelIndex = PanelIndex.DestinationAndSearch;
                  }
                }
                return slidingUpWidget;
              }),
        ),
      ),
    );
  }
}
