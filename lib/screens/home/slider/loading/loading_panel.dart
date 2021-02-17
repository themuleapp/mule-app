import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/panel.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/widgets/loading-animation.dart';
import 'package:mule/widgets/stylized_button.dart';

class LoadingPanel extends Panel {
  LoadingPanel({
    PanelController controller,
    SlidingUpWidgetController slidingUpWidgetController,
    MapController mapController,
    double screenHeight,
  }) : super(
          mapController: mapController,
          slidingUpWidgetController: slidingUpWidgetController,
          screenHeight: screenHeight,
          controller: controller,
        );

  _LoadingPanelState createState() => _LoadingPanelState();

  @override
  void mapStateCallback() {}

  @override
  List<StylizedButton> get buttons => [];
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
