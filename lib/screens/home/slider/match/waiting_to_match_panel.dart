import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'dart:async';

import 'package:mule/widgets/alert_widget.dart';
import 'package:mule/widgets/stylized_button.dart';

class WaitingToMatchPanel extends StatefulWidget {
  final SlidingUpWidgetController slidingUpWidgetController;
  final MapController mapController;
  final double loadingBarHeight;
  final double opacity = 1.0;
  final StylizedButton buttonBridge;

  WaitingToMatchPanel({
    this.slidingUpWidgetController,
    this.mapController,
    this.loadingBarHeight = 5.0,
    this.buttonBridge,
  });

  @override
  WaitingToMatchState createState() => WaitingToMatchState();
}

class WaitingToMatchState extends State<WaitingToMatchPanel> {
  Timer timer;
  OrderData order;

  @override
  void initState() {
    super.initState();
    _checkOrder(true);
    widget.buttonBridge?.callback = cancelRequest;
  }

  _checkOrder(bool keepChecking) async {
    order = await httpClient.getActiveRequest();
    if (order != null && order.status == Status.ACCEPTED) {
      widget.slidingUpWidgetController.panelIndex = PanelIndex.UserMatched;
    } else if (keepChecking) {
      _startChecking();
    }
  }

  _startChecking() {
    timer = Timer.periodic(Duration(seconds: 10),
        (timer) async => {if (mounted) _checkOrder(false)});
  }

  cancelRequest() async {
    if (order != null && await httpClient.deleteActiveRequest(order)) {
      widget.slidingUpWidgetController.panelIndex =
          PanelIndex.DestinationAndSearch;
      timer.cancel();
      print("Successfully deleted request");
    } else {
      createDialogWidget(
          context, "There was a problem", "Please try again later!");
    }
  }

  @override
  build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double loadingBar = widget.slidingUpWidgetController.radius * 2;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Center(
              child: Container(
                height: loadingBar,
                child: ClipRect(
                  clipper: ClipHeightQuarter(height: widget.loadingBarHeight),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.all(Radius.circular(loadingBar / 2)),
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
                        opacity: widget.opacity,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: AppTheme.elementSize(
                                  screenHeight, 20, 22, 24, 26, 32, 34, 36, 38),
                              left: 16,
                              right: 16),
                          child: Text(
                            'Your request has been sent!',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: AppTheme.elementSize(
                                  screenHeight, 18, 19, 20, 21, 22, 26, 30, 36),
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
                                fontSize: AppTheme.elementSize(screenHeight, 14,
                                    15, 16, 17, 18, 20, 24, 28),
                                fontWeight: FontWeight.w500,
                                color: AppTheme.darkGrey)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16, right: 16),
                  child: Image.asset('assets/images/student_waiting.png',
                      height: AppTheme.elementSize(screenHeight, 100, 110, 125,
                          140, 150, 150, 160, 160)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class ClipHeightQuarter extends CustomClipper<Rect> {
  double height;

  ClipHeightQuarter({this.height});

  @override
  Rect getClip(Size size) {
    Rect rect = Rect.fromLTRB(0.0, -size.height, size.width, this.height);
    return rect;
  }

  @override
  bool shouldReclip(ClipHeightQuarter oldClipper) {
    return true;
  }
}
