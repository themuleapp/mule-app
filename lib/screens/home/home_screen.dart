import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/models/data/user_data.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/stores/global/user_info_store.dart';

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

    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: SlidingUpWidget(
          beginScreen: _checkCurrentActiveStatus(
              GetIt.I.get<UserInfoStore>().activeOrder),
          controller: controller,
          minHeight: screenHeight / 5,
          maxHeight: screenHeight - 120,
        )),
      ),
    );
  }

  PanelIndex _checkCurrentActiveStatus(OrderData order) {
    if (order == null) return PanelIndex.DestinationAndSearch;

    switch (order.status) {
      case (Status.ACCEPTED):
        return (GetIt.I.get<UserInfoStore>().isMule)
            ? PanelIndex.MuleMatched
            : PanelIndex.UserMatched;
      case (Status.OPEN):
        return PanelIndex.WaitingToMatch;
      default:
        return PanelIndex.DestinationAndSearch;
    }
  }
}
