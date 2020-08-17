import 'package:flutter/material.dart';
import 'package:mule/screens/home/slider/request/make_request_panel.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/search/search_panel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingUpWidget extends StatefulWidget {
  @override
  SlidingUpWidgetState createState() => SlidingUpWidgetState();
}

class SlidingUpWidgetState extends State<SlidingUpWidget> {
  final FocusNode _destinationFocusNode = FocusNode();
  final PanelController _panelController = PanelController();
  final double radius = 20.0;

  double _snapValue;
  bool _isDraggable;
  SlidingUpPanel _slidingUpPanel;
  PanelIndex panelIndex;
  Widget _currentPanel;

  _handleSearchFocus() {
    if (_destinationFocusNode.hasFocus) {
      _panelController.open();
    }
  }

  @override
  void initState() {
    _destinationFocusNode.addListener(_handleSearchFocus);
    panelIndex = PanelIndex.DestinationAndSearch;
    _updatePanel();
    super.initState();
  }

  _updatePanel() {
    switch (panelIndex) {
      case PanelIndex.DestinationAndSearch:
        setState(() {
          _snapValue = null;
          _isDraggable = true;
        });
        _setCurrentPanel(SearchPanel(
          destinationFocusNode: _destinationFocusNode,
          panelController: _panelController,
          slidingUpWidgetState: this,
        ));
        break;
      case PanelIndex.MakeRequest:
        setState(() {
          _snapValue = .3;
          _isDraggable = false;
        });
        _setCurrentPanel(MakeRequestPanel(
          panelController: _panelController,
          slidingUpWidgetState: this,
        ));
        break;
      default:
        throw UnimplementedError("Called panel not implemented");
    }
  }

  _setCurrentPanel(panel) {
    setState(() => _currentPanel = panel);
  }

  setPanelIndex(PanelIndex newPanelIndex) {
    setState(() {
      this.panelIndex = newPanelIndex;
    });
    _updatePanel();
  }

  Widget _panel(ScrollController sc) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      controller: sc,
      child: _currentPanel,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    _slidingUpPanel = SlidingUpPanel(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      ),
      onPanelClosed: () => _updatePanel(),
      onPanelOpened: () => _updatePanel(),
      isDraggable: _isDraggable,
      minHeight: screenHeight / 4,
      snapPoint: _snapValue,
      maxHeight: screenHeight - 120,
      controller: _panelController,
      backdropEnabled: true,
      panelBuilder: (sc) => _panel(sc),
      body: Center(
        child: MapWidget(),
      ),
    );
    return _slidingUpPanel;
  }
}

enum PanelIndex {
  DestinationAndSearch,
  MakeRequest,
}
