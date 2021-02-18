import 'package:get_it/get_it.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/match/matched_panel.dart';
import 'package:mule/screens/home/slider/panel.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/services/mule_api_service.dart';
import 'package:mule/stores/global/user_info_store.dart';

class UserMatchedPanel extends MatchedPanel {
  UserMatchedPanel({
    SlidingUpWidgetController slidingUpWidgetController,
    MapController mapController,
    PanelController controller,
    double screenHeight,
  }) : super(
          slidingUpWidgetController: slidingUpWidgetController,
          mapController: mapController,
          controller: controller,
          match: GetIt.I.get<UserInfoStore>().activeOrder.acceptedBy,
          headerString: "You are en route",
          screenHeight: screenHeight,
        );

  UserMatchedPanel.from(Panel panel)
      : super(
          slidingUpWidgetController: panel.slidingUpWidgetController,
          mapController: panel.mapController,
          controller: panel.controller,
          screenHeight: panel.screenHeight,
          headerString: "En route",
          match: GetIt.I.get<UserInfoStore>().activeOrder.acceptedBy,
        );

  @override
  Future<bool> cancelRequest() async {
    return muleApiService.userDeleteActiveRequest(order);
  }

  @override
  Future<bool> completeRequest() async {
    print("Completed request");
  }
}
