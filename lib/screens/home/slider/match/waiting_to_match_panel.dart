import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/screens/home/slider/match/mule_matched_panel.dart';
import 'package:mule/screens/home/slider/match/user_matched_panel.dart';
import 'package:mule/screens/home/slider/panel.dart';
import 'package:mule/screens/home/slider/search/search_panel.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:mule/widgets/alert_widget.dart';

import 'package:mule/widgets/clip_height.dart';
import 'package:mule/widgets/confirm_action_dialogue.dart';
import 'package:mule/widgets/reminder_widget.dart';
import 'package:mule/widgets/stylized_button.dart';

class WaitingToMatchPanel extends Panel {
  final double loadingBarHeight;

  WaitingToMatchPanel(
    SlidingUpWidgetController slidingUpWidgetController,
    MapController mapController,
    PanelController controller,
    double screenHeight, {
    this.loadingBarHeight = 5.0,
  }) : super(
          slidingUpWidgetController: slidingUpWidgetController,
          mapController: mapController,
          controller: controller,
          screenHeight: screenHeight,
        );

  WaitingToMatchPanel.from(Panel panel, {this.loadingBarHeight = 5.0})
      : super(
          slidingUpWidgetController: panel.slidingUpWidgetController,
          mapController: panel.mapController,
          controller: panel.controller,
          screenHeight: panel.screenHeight,
          isMapDraggable: false,
        );

  cancelRequest(BuildContext context) async {
    bool success = createConfirmActionDialogue(context);
    if (success == null) {
      return;
    }
    if (success) {
      slidingUpWidgetController.panel = SearchPanel.from(this);
    } else {
      createDialogWidget(
        context,
        "Oops... Something went wrong",
        "Something went wrong while trying to confirm your delivery. Please try again later.",
      );
    }
  }

  @override
  WaitingToMatchState createState() => WaitingToMatchState();

  @override
  List<StylizedButton> get buttons {
    buttonSize =
        AppTheme.elementSize(screenHeight, 42, 44, 46, 48, 50, 50, 50, 50);
    buttonSpacing =
        AppTheme.elementSize(screenHeight, 15, 15, 17, 18, 20, 20, 20, 20);
    StylizedButton cancel = CancelButton(
      callback: cancelRequest,
      size: buttonSize,
      margin: EdgeInsets.only(bottom: buttonSpacing),
    );
    return [cancel];
  }

  @override
  void mapStateCallback() {
    mapController..setRouteView();
  }

  @override
  double get maxHeight {
    return minHeight;
  }
}

class WaitingToMatchState extends State<WaitingToMatchPanel> {
  BuildContext context;

  @override
  void initState() {
    super.initState();
    widget.init(this);
    GetIt.I.get<UserInfoStore>().activeOrder.addListener(_orderListener);
  }

  void _orderListener() async {
    OrderData newOrder = GetIt.I.get<UserInfoStore>().activeOrder;

    if (newOrder == null) {
      widget.slidingUpWidgetController.panel = SearchPanel.from(widget);
    } else if (GetIt.I.get<UserInfoStore>().fullName ==
        newOrder.acceptedBy.name) {
      widget.slidingUpWidgetController.panel = MuleMatchedPanel.from(widget);
    } else {
      await Future.delayed(const Duration(milliseconds: 1000), () => 42);
      createReminderWidget(context, "Remember to", [
        "Coordinate with the Mule about your order specifics",
        "Provide the Mule with the PIN once you receive the delivery",
        "Pay the Mule via Cash or electronic payment apps, the amount on the receipt + a \$1.95 fee",
        "Wear a mask and help keep your community safe"
      ]);
      widget.slidingUpWidgetController.panel = UserMatchedPanel.from(widget);
    }
    dispose();
  }

  @override
  build(BuildContext context) {
    this.context = context;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Center(
              child: Container(
                height: widget.radius * 2,
                child: ClipRect(
                  clipper: ClipHeightQuarter(height: widget.loadingBarHeight),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.all(Radius.circular(widget.radius)),
                    child: LinearProgressIndicator(
                      minHeight: widget.loadingBarHeight,
                      backgroundColor: AppTheme.secondaryBlue,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppTheme.lightBlue),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: 1.0,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: AppTheme.elementSize(widget.screenHeight, 20,
                                  22, 24, 26, 0, 0, 0, 0),
                              left: 16,
                              right: 16),
                          child: Text(
                            'Request has been sent!',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: AppTheme.elementSize(
                                  widget.screenHeight,
                                  18,
                                  19,
                                  19,
                                  20,
                                  22,
                                  26,
                                  30,
                                  36),
                              color: AppTheme.darkerText,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16, left: 16, right: 16, bottom: 8),
                        child: Text(
                            "Hang tight! We will notify you as soon as "
                            "someone accepts your request",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: AppTheme.elementSize(
                                    widget.screenHeight,
                                    14,
                                    15,
                                    16,
                                    16,
                                    18,
                                    20,
                                    24,
                                    28),
                                fontWeight: FontWeight.w500,
                                color: AppTheme.darkGrey)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16, right: 16),
                  child: Image.asset('assets/images/waiting_match.png',
                      height: AppTheme.elementSize(widget.screenHeight, 100,
                          110, 120, 130, 150, 150, 160, 160)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
