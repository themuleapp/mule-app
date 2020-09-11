import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';

class WaitingToMatchPanel extends StatelessWidget {
  final SlidingUpWidgetController slidingUpWidgetController;
  final double opacity = 1.0;

  WaitingToMatchPanel({this.slidingUpWidgetController});

  @override
  build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Container(
            height: 5,
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: LinearProgressIndicator(
                backgroundColor: AppTheme.secondaryBlue,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.lightBlue),
              )),
          )
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
                            fontSize: AppTheme.elementSize(
                                screenHeight, 14, 15, 16, 17, 18, 20, 24, 28),
                            fontWeight: FontWeight.w500,
                            color: AppTheme.darkGrey)
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.only(top: 16, right: 16),
                child: Image.asset(
                    'assets/images/student_waiting.png',
                    height: 150
                )
            )
          ],
        ),
      ],
    );
  }
}