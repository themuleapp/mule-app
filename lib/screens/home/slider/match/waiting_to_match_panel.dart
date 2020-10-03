import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'dart:async';

class WaitingToMatchPanel extends StatelessWidget {
  final SlidingUpWidgetController slidingUpWidgetController;
  final double loadingBarHeight;
  final double opacity = 1.0;

  WaitingToMatchPanel(
      {this.slidingUpWidgetController, this.loadingBarHeight = 5.0});

  startChecking() {
    Timer.periodic(Duration(seconds: 10), (timer) async {
      OrderData order = await httpClient.getActiveRequest();
      if (order != null && order.status == Status.ACCEPTED) {
        slidingUpWidgetController.panelIndex = PanelIndex.Matched;
      }
    });
  }

  @override
  build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double loadingBar = slidingUpWidgetController.radius * 2;
    startChecking();

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
                  clipper: ClipHeightQuarter(height: loadingBarHeight),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.all(Radius.circular(loadingBar / 2)),
                    child: LinearProgressIndicator(
                      minHeight: loadingBarHeight,
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
                        opacity: opacity,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
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
                    ],
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(top: 16, right: 16),
                    child: Image.asset('assets/images/student_waiting.png',
                        height: 150))
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
