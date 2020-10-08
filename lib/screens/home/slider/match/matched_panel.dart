import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/models/data/mule_data.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/widgets/alert_widget.dart';
import 'package:mule/widgets/confirm_dialogue.dart';

class MatchedPanel extends StatefulWidget {
  final SlidingUpWidgetController slidingUpWidgetController;
  final MapController mapController;
  final double opacity = 1.0;

  MatchedPanel({this.slidingUpWidgetController, this.mapController});

  @override
  _MatchedPanelState createState() => _MatchedPanelState();
}

class _MatchedPanelState extends State<MatchedPanel> {
  OrderData order;
  MuleData mule;

  @override
  void initState() {
    updateOrder();
    super.initState();
  }

  updateOrder() async {
    setState(() async {
      order = await httpClient.getActiveRequest();
      if (order.status == Status.ACCEPTED) {
        mule = order.acceptedBy;
        widget.mapController.updateDelivery(
          order.acceptedBy.location.toLatLng(),
          order.place.location.toLatLng(),
          order.destination.location.toLatLng(),
          .1,
        );
      }
    });
  }

  @override
  build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    WidgetsBinding.instance.addPostFrameCallback((_) => widget
            .slidingUpWidgetController.panelController
            .animatePanelToSnapPoint(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: widget.opacity,
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0, left: 16, right: 16),
                child: Text(
                  'En Route',
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
                            (mule != null) ? mule.name : "Loading...",
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
                                size: AppTheme.elementSize(screenHeight, 25, 25,
                                    26, 26, 18, 20, 21, 22),
                              ),
                              Text('4.7 stars', //replace with rating
                                  style: TextStyle(
                                    color: AppTheme.lightGrey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: AppTheme.elementSize(screenHeight,
                                        14, 14, 15, 15, 16, 18, 21, 24),
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
                    onTap: () {},
                  ),
                  SizedBox(width: 15),
                  GestureDetector(
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          color: AppTheme.lightGrey.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.report_problem,
                          color: AppTheme.secondaryBlue,
                          size: AppTheme.elementSize(
                              screenHeight, 25, 25, 26, 26, 28, 36, 38, 40),
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
          child: ProgressButton(
            defaultWidget: Text(
              'Cancel',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                letterSpacing: 0.0,
                color: AppTheme.white,
              ),
            ),
            progressWidget: CircularProgressIndicator(
                backgroundColor: AppTheme.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent)),
            width: MediaQuery.of(context).size.width,
            height: 48,
            color: Colors.redAccent,
            borderRadius: 16,
            animate: true,
            type: ProgressButtonType.Raised,
            onPressed: () async {
              int score = await Future.delayed(
                  const Duration(milliseconds: 2500), () => 42);
              return () async {
                if (await httpClient.deleteActiveRequest(order)) {
                  widget.slidingUpWidgetController.panelIndex =
                      PanelIndex.DestinationAndSearch;
                  widget.mapController.focusCurrentLocation();
                } else {
                  createDialogWidget(context, "Something went wrong...",
                      "Something went wrong when cancelling your request, please try again later.");
                }
              };
            },
          ),
        ),
      ],
    );
  }
}
