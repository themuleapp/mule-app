import 'package:get_it/get_it.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/panel.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/services/mule_api_service.dart';
import 'package:mule/stores/global/user_info_store.dart';

import 'matched_panel.dart';

class MuleMatchedPanel extends MatchedPanel {
  MuleMatchedPanel({
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

  @override
  Future<bool> cancelRequest() async {
    return await muleApiService.muleDeleteActiveRequest(order);
  }

  @override
  Future<bool> completeRequest() async {
    print("Completed request");
  }
}
