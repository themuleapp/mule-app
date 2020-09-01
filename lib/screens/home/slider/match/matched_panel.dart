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
      ],
    );
  }
}
