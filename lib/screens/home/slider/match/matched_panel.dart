import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';

class MatchedPanel extends StatelessWidget {
  final SlidingUpWidgetController slidingUpWidgetController;
  final double opacity = 1.0;

  MatchedPanel({this.slidingUpWidgetController});

  @override
  build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 32.0, left: 16, right: 16),
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
                        'Nick Miller',
                        style: TextStyle(
                          color: AppTheme.darkerText,
                          fontWeight: FontWeight.w700,
                          fontSize: AppTheme.elementSize(
                              screenHeight, 16, 16, 17, 17, 18, 24, 26, 28),

                        ),
                      ),
                      SizedBox(
                        height: 5
                      ),
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
                          Text(
                            '4.7 stars',
                            style: TextStyle(
                              color: AppTheme.lightGrey,
                              fontWeight: FontWeight.w500,
                              fontSize: AppTheme.elementSize(
                                  screenHeight, 14, 14, 15, 15, 16, 18, 21, 24),
                            )
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
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
                )
              ),
            ],
          ),
        )
      ],
    );
  }
}
