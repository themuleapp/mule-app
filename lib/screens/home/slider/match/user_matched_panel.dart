import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/match/matched_panel.dart';
import 'package:mule/screens/home/slider/panel.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:mule/widgets/stylized_button.dart';

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
          headerString: "You are en route to",
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

  List<StylizedButton> get buttons {
    StylizedButton cancel = CancelButton(
      callback: cancelRequest,
      size: buttonSize,
      margin: EdgeInsets.only(bottom: buttonSpacing),
    );
    StylizedButton currentLocationButton = CurrentLocationButton(
      size: buttonSize,
      callback: () {
        if (!mapController.isMapLoading) mapController.focusCurrentLocation();
      },
      margin: EdgeInsets.only(bottom: buttonSpacing),
    );
    return [cancel, currentLocationButton];
  }
}
