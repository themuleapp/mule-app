import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/screens/home/slider/panel.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/search/search_panel.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart' as ext;

class SlidingUpWidget extends StatefulWidget {
  final OrderData order = GetIt.I.get<UserInfoStore>().activeOrder;
  final SlidingUpWidgetController controller;
  final MapController mapController;
  final double radius;
  final double screenHeight;
  final Panel beginPanel;

  SlidingUpWidget({
    this.controller,
    this.mapController,
    this.radius = 20.0,
    this.screenHeight,
    this.beginPanel,
  });

  @override
  _SlidingUpWidgetState createState() => _SlidingUpWidgetState(
        order: order,
        panel: beginPanel,
      );
}

class _SlidingUpWidgetState extends State<SlidingUpWidget> {
  final ext.PanelController _sliderPanelController = ext.PanelController();

  Panel panel;
  OrderData order;

  _SlidingUpWidgetState({
    this.order,
    this.panel,
  });

  @override
  void initState() {
    super.initState();
    widget.controller?._addState(this);
  }

  // _updatePanel() {
  //   switch (panelIndex) {
  //     case PanelIndex.DestinationAndSearch:
  //       setState(() {
  //         _minHeight = widget.minHeight;
  //         _maxHeight = widget.maxHeight;
  //         _isDraggable = true;
  //         _backdropTapClosesPanel = true;
  //         _backdropOpacity = 0.5;
  //         _buttonList = [currentLocationButton];
  //         _mapStateCallback = () {
  //           _mapController.unfocusRoute();
  //           _mapController.focusCurrentLocation();
  //         };
  //       });
  //       _setCurrentPanel(SearchPanel(
  //         slidingUpWidgetController: widget.controller,
  //         mapController: _mapController,
  //       ));
  //       break;
  //     case PanelIndex.MakeRequest:
  //       setState(() {
  //         _minHeight =
  //             widget.minHeight + .25 * (widget.maxHeight - widget.minHeight);
  //         _maxHeight = widget.maxHeight;
  //         _isDraggable = false;
  //         _backdropTapClosesPanel = false;
  //         _backdropOpacity = 0.0;
  //         _buttonList = [cancelButton];
  //         _mapStateCallback = () {
  //           _mapController.focusOnRoute();
  //         };
  //       });
  //       _setCurrentPanel(MakeRequestPanel(
  //         slidingUpWidgetController: widget.controller,
  //         mapController: _mapController,
  //         buttonBridge: cancelButton,
  //       ));
  //       break;
  //     case PanelIndex.WaitingToMatch:
  //       setState(() {
  //         _minHeight = widget.minHeight;
  //         _maxHeight = widget.maxHeight;
  //         _isDraggable = false;
  //         _backdropTapClosesPanel = false;
  //         _backdropOpacity = 0;
  //         _buttonList = [cancelButton];
  //         _mapStateCallback = () {
  //           _mapController.focusOnRoute();
  //         };
  //       });
  //       _setCurrentPanel(WaitingToMatchPanel(
  //         slidingUpWidgetController: widget.controller,
  //         mapController: _mapController,
  //         buttonBridge: cancelButton,
  //       ));
  //       break;
  //     case PanelIndex.UserMatched:
  //       setState(() {
  //         _minHeight = widget.minHeight;
  //         _maxHeight = widget.maxHeight;
  //         _isDraggable = false;
  //         _backdropTapClosesPanel = false;
  //         _backdropOpacity = 0;
  //         _buttonList = [currentLocationButton, cancelButton];
  //         _mapStateCallback = () {
  //           _mapController.focusOnRoute();
  //         };
  //       });
  //       _setCurrentPanel(UserMatchedPanel(
  //         slidingUpWidgetController: widget.controller,
  //         mapController: _mapController,
  //         buttonBridge: cancelButton,
  //       ));
  //       break;
  //     case PanelIndex.MuleMatched:
  //       setState(() {
  //         _minHeight = widget.minHeight;
  //         _maxHeight = widget.maxHeight;
  //         _isDraggable = false;
  //         _backdropTapClosesPanel = false;
  //         _backdropOpacity = 0;
  //         _buttonList = [currentLocationButton, cancelButton, completedButton];
  //         _mapStateCallback = () {
  //           _mapController.focusOnRoute();
  //         };
  //       });
  //       _setCurrentPanel(MuleMatchedPanel(
  //         slidingUpWidgetController: widget.controller,
  //         mapController: _mapController,
  //         buttonBridge: cancelButton,
  //         buttonBridge2: completedButton,
  //       ));
  //       break;
  //     case PanelIndex.Loading:
  //       setState(() {
  //         _minHeight = widget.minHeight;
  //         _maxHeight = widget.maxHeight;
  //         _isDraggable = false;
  //         _backdropTapClosesPanel = false;
  //         _buttonList = [];
  //         _backdropOpacity = 0;
  //       });
  //       _setCurrentPanel(LoadingPanel(
  //         slidingUpWidgetController: widget.controller,
  //         mapController: _mapController,
  //       ));
  //       break;
  //     default:
  //       throw UnimplementedError("Called panel not implemented");
  //   }
  //   if (!_mapController.isMapLoading) {
  //     _mapStateCallback();
  //   }
  // }

  set newPanel(Panel panel) {
    setState(() {
      this.panel = panel;
    });
  }

  Panel getPanelFromOrder(OrderData order) {
    // if (order == null)
    return SearchPanel(
      mapController: widget.mapController,
      slidingUpWidgetController: widget.controller,
      controller: DraggableController(),
      screenHeight: widget.screenHeight,
    );

    // switch (order.status) {
    //   case (Status.ACCEPTED):
    //     return (GetIt.I.get<UserInfoStore>().isMule)
    //         ? PanelIndex.MuleMatched
    //         : PanelIndex.UserMatched;
    //   case (Status.OPEN):
    //     return PanelIndex.WaitingToMatch;
    //   default:
    //     return PanelIndex.DestinationAndSearch;
    // }
  }

  Widget _panel(ScrollController sc) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      controller: sc,
      child: panel,
    );
  }

  double get currentHeight {
    if (panel.controller is DraggableController &&
        panel.controller.isAttached) {
      return (panel.controller as DraggableController).currentHeight;
    } else {
      return panel.minHeight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ext.SlidingUpPanel(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(widget.radius),
        topRight: Radius.circular(widget.radius),
      ),
      onPanelClosed: () => (panel.controller as DraggableController).close(),
      onPanelOpened: () => (panel.controller as DraggableController).open(),
      isDraggable: (panel.controller is DraggableController),
      backdropTapClosesPanel: (panel.controller is DraggableController) &&
          panel.backdropTapClosesPanel,
      minHeight: panel.minHeight,
      maxHeight: panel.maxHeight,
      controller: _sliderPanelController,
      backdropEnabled: true,
      backdropOpacity: panel.backdropOpacity,
      panelBuilder: (sc) => _panel(sc),
      body: Center(
        child: Stack(
          children: <Widget>[
            MapWidget(
              controller: widget.mapController,
              slidingUpWidgetController: widget.controller,
              initCallback: panel.mapStateCallback,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: currentHeight),
                    child: Container(
                      height: panel.buttons.length *
                          (panel.buttonSize + panel.buttonSpacing),
                      width: panel.buttonSize + panel.buttonSpacing,
                      child: Column(
                        children: panel.buttons,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SlidingUpWidgetController {
  _SlidingUpWidgetState _slidingUpWidgetState;

  _addState(_SlidingUpWidgetState slidingUpWidgetState) {
    this._slidingUpWidgetState = slidingUpWidgetState;
  }

  void open() {
    this._slidingUpWidgetState._sliderPanelController.open();
  }

  void close() {
    this._slidingUpWidgetState._sliderPanelController.open();
  }

  bool get isActive {
    return _slidingUpWidgetState != null;
  }

  bool get isAttached {
    return _slidingUpWidgetState._sliderPanelController.isAttached;
  }

  double get currentHeight {
    return _slidingUpWidgetState.currentHeight;
  }

  PanelController get panelController {
    return _slidingUpWidgetState.panel.controller;
  }

  set panel(Panel panel) {
    _slidingUpWidgetState.newPanel = panel;
  }
}
