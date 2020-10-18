import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'dart:async';

import 'package:mule/widgets/alert_widget.dart';

class WaitingToMatchPanel extends StatefulWidget {
  final SlidingUpWidgetController slidingUpWidgetController;
  final MapController mapController;
  final double loadingBarHeight;
  final double opacity = 1.0;

  WaitingToMatchPanel({
    this.slidingUpWidgetController,
    this.mapController,
    this.loadingBarHeight = 5.0,
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
  }

  _checkOrder(bool keepChecking) async {
    order = await httpClient.getActiveRequest();
    if (order != null && order.status == Status.ACCEPTED) {
      widget.slidingUpWidgetController.panelIndex = PanelIndex.Matched;
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

    WidgetsBinding.instance.addPostFrameCallback((_) => widget
            .slidingUpWidgetController.panelController
            .animatePanelToSnapPoint(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ));

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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: widget.opacity,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 32, left: 16, right: 16),
                          child: Text(
                            'Your request has been sent!',
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
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //       left: 16, right: 16, bottom: 8),
                      //   child: ProgressButton(
                      //     defaultWidget: Text(
                      //       'Cancel',
                      //       textAlign: TextAlign.left,
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.w600,
                      //         fontSize: 18,
                      //         letterSpacing: 0.0,
                      //         color: AppTheme.white,
                      //       ),
                      //     ),
                      //     progressWidget: CircularProgressIndicator(
                      //         backgroundColor: AppTheme.white,
                      //         valueColor: AlwaysStoppedAnimation<Color>(
                      //             Colors.redAccent)),
                      //     width: MediaQuery.of(context).size.width - 100,
                      //     height: 48,
                      //     color: Colors.redAccent,
                      //     borderRadius: 16,
                      //     animate: true,
                      //     type: ProgressButtonType.Raised,
                      //     onPressed: () async {
                      //       int score = await Future.delayed(
                      //           const Duration(milliseconds: 2500), () => 42);
                      //       return () async {
                      //         if (order != null &&
                      //             await httpClient.deleteActiveRequest(order)) {
                      //           widget.slidingUpWidgetController.panelIndex =
                      //               PanelIndex.DestinationAndSearch;
                      //           timer.cancel();
                      //           print("Successfully deleted request");
                      //         } else {
                      //           createDialogWidget(
                      //               context,
                      //               "There was a problem",
                      //               "Please try again later!");
                      //         }
                      //       };
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16, right: 16),
                  child: Image.asset('assets/images/student_waiting.png',
                      height: 150),
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
