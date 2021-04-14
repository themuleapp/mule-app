import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/app_theme.dart';
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
    final double buttonSize =
        AppTheme.elementSize(screenHeight, 42, 44, 46, 48, 50, 50, 50, 50);
    final double buttonMargin =
        AppTheme.elementSize(screenHeight, 12, 14, 16, 18, 20, 20, 20, 20);
    StylizedButton cancel = CancelButton(
      callback: cancelRequest,
      size: buttonSize,
      margin: EdgeInsets.only(
        bottom: buttonMargin,
      ),
    );
    StylizedButton accept = CompletedButton(
      callback: completeRequest,
      size: buttonSize,
      margin: EdgeInsets.only(bottom: buttonMargin),
    );
    StylizedButton currentLocationButton = CurrentLocationButton(
      size: buttonSize,
      callback: () {
        if (!mapController.isMapLoading) mapController.focusCurrentLocation();
      },
      margin: EdgeInsets.only(bottom: buttonMargin),
    );
    return [accept, cancel, currentLocationButton];
  }

  void completeRequest(BuildContext context) async {
    OrderData order = GetIt.I.get<UserInfoStore>().activeOrder;
    bool success = await enterPinDialogue(
        context, "Are you sure that you have completed this delivery?", order);
    if (success == null) {
      return;
    }
    if (success) {
      createDialogWidget(
        context,
        "Thank you!",
        "You have successfully delivered the order!",
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
