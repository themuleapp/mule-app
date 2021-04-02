import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/panel.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:mule/widgets/stylized_button.dart';

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
          match: GetIt.I.get<UserInfoStore>().activeOrder.createdBy,
          headerString: "You are en route",
          screenHeight: screenHeight,
        );

  MuleMatchedPanel.from(Panel panel)
      : super(
          slidingUpWidgetController: panel.slidingUpWidgetController,
          mapController: panel.mapController,
          controller: panel.controller,
          screenHeight: panel.screenHeight,
          headerString: "You are en route",
          match: GetIt.I.get<UserInfoStore>().activeOrder.createdBy,
        );
  List<StylizedButton> get buttons {
    StylizedButton cancel = CancelButton(
      callback: cancelRequest,
      size: buttonSize,
      margin: EdgeInsets.only(bottom: buttonSpacing),
    );
    StylizedButton accept = CompletedButton(
      callback: null,
      size: buttonSize,
      margin: EdgeInsets.only(bottom: buttonSpacing),
    );
    StylizedButton navigate = NavigateButton(
      callback: launchMaps,
      size: buttonSize,
      margin: EdgeInsets.only(bottom: buttonSpacing),
    );
    return [accept, cancel, navigate];
  }

  @override
  Future<bool> completeRequest() async {
    print("Completed request");
    return true;
  }
}
