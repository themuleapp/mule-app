import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/screens/home/slider/loading/loading_panel.dart';
import 'package:mule/screens/home/slider/match/mule_matched_panel.dart';
import 'package:mule/screens/home/slider/match/user_matched_panel.dart';
import 'package:mule/screens/home/slider/match/waiting_to_match_panel.dart';
import 'package:mule/screens/home/slider/panel.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/search/search_panel.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart' as ext;

class SlidingUpWidget extends StatefulWidget {
  final OrderData order = GetIt.I.get<UserInfoStore>().activeOrder;
  final SlidingUpWidgetController controller;
  final MapController mapController;
  final double screenHeight;
  final Panel beginPanel;

  SlidingUpWidget({
    this.controller,
    this.mapController,
    this.screenHeight,
    this.beginPanel = null,
  });

  @override
  _SlidingUpWidgetState createState() => _SlidingUpWidgetState(
        order: order,
        panel: (beginPanel == null) ? getPanelFromOrder(order) : beginPanel,
      );

  Panel getPanelFromOrder(OrderData order) {
    Panel loadingPanel = LoadingPanel(
      mapController: mapController,
      slidingUpWidgetController: controller,
      screenHeight: screenHeight,
      controller: PanelController(),
    );

    if (order == null) return SearchPanel.from(loadingPanel);

    switch (order.status) {
      case (Status.ACCEPTED):
        return (GetIt.I.get<UserInfoStore>().fullName == order.acceptedBy.name)
            ? MuleMatchedPanel.from(loadingPanel)
            : UserMatchedPanel.from(loadingPanel);
      case (Status.OPEN):
        return WaitingToMatchPanel.from(loadingPanel);
      default:
        return SearchPanel.from(loadingPanel);
    }
  }
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

  set newPanel(Panel panel) {
    setState(() {
      this.panel.controller.cleanup();
      this.panel = panel;
    });
    this.panel.mapStateCallback();
  }

  Widget _panel(ScrollController sc) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      controller: sc,
      child: panel,
    );
  }

  double get currentHeight {
    if (panel.controller.isAttached) {
      return panel.controller.currentHeight;
    } else {
      return panel.minHeight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          ext.SlidingUpPanel(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(panel.radius),
              topRight: Radius.circular(panel.radius),
            ),
            onPanelClosed: () => panel.controller.close(),
            onPanelOpened: () => panel.controller.open(),
            // TODO: Check at search and destination panel
            isDraggable: panel.controller.isDraggable,
            minHeight: panel.minHeight,
            maxHeight: panel.maxHeight,
            controller: _sliderPanelController,
            backdropEnabled: true,
            backdropOpacity: panel.backdropOpacity,
            panelBuilder: (sc) => _panel(sc),
            body: MapWidget(
              controller: widget.mapController,
              slidingUpWidgetController: widget.controller,
              initCallback: panel.mapStateCallback,
              isDraggable: panel.isMapDraggable,
            ),
          ),
          Positioned(
            right: 0.0,
            bottom: widget.controller.currentHeight,
            child: Container(
              height: (panel.buttons.length) *
                  (panel.buttonSize + panel.buttonSpacing),
              width: panel.buttonSize + panel.buttonSpacing,
              child: Column(
                children: panel.buttons,
              ),
            ),
          ),
        ],
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

  Panel get panel {
    return _slidingUpWidgetState.panel;
  }

  set panel(Panel panel) {
    _slidingUpWidgetState.newPanel = panel;
  }
}
