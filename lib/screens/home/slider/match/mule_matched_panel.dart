import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/panel.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/screens/home/slider/search/search_panel.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:mule/widgets/alert_widget.dart';
import 'package:mule/widgets/enter_pin_dialogue.dart';
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
      callback: completeRequest,
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
  void completeRequest(BuildContext context) async {
    OrderData order = GetIt.I.get<UserInfoStore>().activeOrder;
    bool success = await enterPinDialogue(
        context, "Are you sure that you have completed this delivery?", order);
    if (success) {
      createDialogWidget(
        context,
        "Thank you for your order!",
        ":)",
      );
      slidingUpWidgetController.panel = SearchPanel.from(this);
    } else {
      createDialogWidget(
        context,
        "Oops... Something went wrong",
        "Something went wrong while trying to confirm your delivery. Please try again later.",
      );
    }
  }
}
