import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/config/messages_service.dart';
import 'package:mule/models/data/mule_data.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/widgets/alert_widget.dart';
import 'package:mule/widgets/confirm_dialogue.dart';
import 'package:mule/widgets/order_completion_dialogue.dart';
import 'package:mule/widgets/stylized_button.dart';

import '../../../../navigation_home_screen.dart';

class MuleMatchedPanel extends StatefulWidget {
  final SlidingUpWidgetController slidingUpWidgetController;
  final MapController mapController;
  final double opacity = 1.0;
  final StylizedButton buttonBridge;
  final StylizedButton buttonBridge2;

  MuleMatchedPanel({
    this.slidingUpWidgetController,
    this.mapController,
    this.buttonBridge,
    this.buttonBridge2,
  });

  @override
  _MuleMatchedPanelState createState() => _MuleMatchedPanelState();
}

class _MuleMatchedPanelState extends State<MuleMatchedPanel> {
  OrderData order;

  final MessagesService _service = GetIt.I.get<MessagesService>();
  final String number = "8148807674";

  @override
  void initState() {
    super.initState();
    widget.buttonBridge?.callback = cancelRequest;
    widget.buttonBridge2?.callback = completedRequest;
  }

  Future<OrderData> updateOrder() async {
    setState(() async {
      order = await httpClient.getActiveRequest();
      if (order.status == Status.ACCEPTED) {
        widget.mapController.updateDelivery(
          order.acceptedBy.location.toLatLng(),
          order.place.location.toLatLng(),
          order.destination.location.toLatLng(),
          .1,
        );
      }
    });
  }

  cancelRequest() async {
    if (await httpClient.deleteActiveRequest(order)) {
      widget.slidingUpWidgetController.panelIndex =
          PanelIndex.DestinationAndSearch;
      widget.mapController.focusCurrentLocation();
    } else {
      createDialogWidget(context, "Something went wrong...",
          "Something went wrong when cancelling your request, please try again later.");
    }
  }

  completedRequest() async {
    _confirmComplete(context);
    _handleComplete(order.id);
    // Navigator.of(context).push(
    //       MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
  }

  _confirmComplete(context) async {
    return await createOrderCompletionDialogue(context);
  }

  _handleComplete(String requestId) async {
    bool success;
    success = await httpClient.muleCompleteRequest(requestId);
    if (!success) {
      createDialogWidget(context, 'There was a problem!',
          'We couldn\'t complete your request, please try again!');
    }
    createDialogWidget(context, "Confirmation sent!",
        "Please wait while we confirm that the order has been received.");
  }

  @override
  build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    updateOrder();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: widget.opacity,
          child: Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 16, right: 16),
            child: Text(
              'You are en route',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: AppTheme.darkerText,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  //color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                      'assets/images/profile_picture_placeholder.png'),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        (order != null) ? order.createdBy : "LOADING",
                        style: TextStyle(
                          color: AppTheme.darkerText,
                          fontWeight: FontWeight.w700,
                          fontSize: AppTheme.elementSize(
                              screenHeight, 16, 16, 17, 17, 18, 24, 26, 28),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: AppTheme.goldenYellow,
                            size: AppTheme.elementSize(
                                screenHeight, 25, 25, 26, 26, 18, 20, 21, 22),
                          ),
                          Text('4.7 stars', //replace with phone number
                              style: TextStyle(
                                color: AppTheme.lightGrey,
                                fontWeight: FontWeight.w500,
                                fontSize: AppTheme.elementSize(screenHeight, 14,
                                    14, 15, 15, 16, 18, 21, 24),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: AppTheme.lightGrey.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.chat,
                      color: AppTheme.secondaryBlue,
                      size: AppTheme.elementSize(
                          screenHeight, 25, 25, 26, 26, 28, 36, 38, 40),
                    )),
                onTap: () => _service.sendSms(number),
              ),
              //SizedBox(width: 15),
            ],
          ),
        )
      ],
    );
  }
}
