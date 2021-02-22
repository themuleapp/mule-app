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

  // Has to be called in the init of the state of the implementing class for the controller to work
  void init(State<Panel> panelState) {
    initController(panelState);
  }

  void initController(State<Panel> panelState) {
    controller._panelState = panelState;
  }

  // Should be called whenever the panel is swapped for another and the controller is passed (Using <PanelImplementation>.from())
  void clearController() {
    controller._panelState = null;
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

  bool get isDraggable {
    return _panelState is DraggablePanel;
  }

  void cleanup() {
    // if (_panelState != null && _panelState.mounted) _panelState.dispose();
    _panelState = null;
  }

  void open() {
    if (isDraggable) (_panelState as DraggablePanel).open();
  }

  void close() {
    if (isDraggable) (_panelState as DraggablePanel).close();
  }

  bool get isOpen {
    return isDraggable && (_panelState as DraggablePanel).isOpen;
  }

  double get currentHeight {
    if (!isDraggable) return _panelState.widget.minHeight;
    if (isOpen) return _panelState.widget.maxHeight;
    return _panelState.widget.minHeight;
  }
}
