import 'package:flutter/material.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/widgets/stylized_button.dart';

abstract class Panel extends StatefulWidget {
  final SlidingUpWidgetController slidingUpWidgetController;
  final MapController mapController;
  final PanelController controller;
  final double radius;
  final double buttonSpacing;
  final double buttonSize;
  final double screenHeight;
  final double backdropOpacity;
  final bool backdropTapClosesPanel;

  Panel({
    @required this.slidingUpWidgetController,
    @required this.mapController,
    @required this.controller,
    @required this.screenHeight,
    this.backdropTapClosesPanel = true,
    this.backdropOpacity = 0.0,
    this.radius = 20,
    this.buttonSize = 50.0,
    this.buttonSpacing = 20.0,
    Key key,
  }) : super(key: key);

  void init(State<Panel> panelState) {
    initController(panelState);
  }

  void initController(State<Panel> panelState) {
    controller._panelState = panelState;
  }

  double get maxHeight {
    return screenHeight - 120;
  }

  double get minHeight {
    return screenHeight / 5;
  }

  void mapStateCallback();

  List<StylizedButton> get buttons;
}

abstract class DraggablePanel {
  bool isOpen = false;

  void open();

  void close();
}

class PanelController {
  State<Panel> _panelState;

  bool get isAttached {
    return _panelState != null;
  }
}

class DraggableController extends PanelController {
  void open() {
    (_panelState as DraggablePanel).open();
  }

  void close() {
    (_panelState as DraggablePanel).close();
  }

  bool get isOpen {
    return (_panelState as DraggablePanel).isOpen;
  }

  double get currentHeight {
    if (isOpen) return _panelState.widget.maxHeight;
    return _panelState.widget.minHeight;
  }
}
