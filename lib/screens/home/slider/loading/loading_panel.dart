import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/widgets/loading-animation.dart';

class LoadingPanel extends StatefulWidget {
  final SlidingUpWidgetController slidingUpWidgetController;
  final MapController mapController;

  const LoadingPanel({
    Key key,
    this.slidingUpWidgetController,
    this.mapController,
  }) : super(key: key);

  @override
  _LoadingPanelState createState() => _LoadingPanelState();
}

class _LoadingPanelState extends State<LoadingPanel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
      child: SpinKitDoubleBounce(
        color: AppTheme.darkGrey,
      ),
    );
  }
}
