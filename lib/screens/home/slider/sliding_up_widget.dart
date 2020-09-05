import 'package:flutter/material.dart';
import 'package:mule/screens/home/slider/match/waiting_to_match_panel.dart';
import 'package:mule/screens/home/slider/request/make_request_panel.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/search/search_panel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'match/matched_panel.dart';

class SlidingUpWidget extends StatefulWidget {
  final SlidingUpWidgetController controller;
  final double radius;
  final double minHeight;
  final double maxHeight;

  SlidingUpWidget({
    this.controller,
    this.radius = 20.0,
    this.minHeight,
    this.maxHeight,
  });

  @override
  _SlidingUpWidgetState createState() => _SlidingUpWidgetState();
}

class _SlidingUpWidgetState extends State<SlidingUpWidget> {
  final PanelController _panelController = PanelController();
  final MapController _mapController = MapController();

  // Animation
  double _snapValue;
  double _backdropOpacity;
  bool _isDraggable;
  bool _backdropTapClosesPanel;
  SlidingUpPanel _slidingUpPanel;

  // Panel state
  PanelIndex panelIndex;
  Widget _currentPanel;

  @override
  void initState() {
    super.initState();
    panelIndex = PanelIndex.DestinationAndSearch;
    _updatePanel();

    widget.controller?._addState(this);
  }

  _setPanelandUpdate(PanelIndex newPanelIndex) {
    if (newPanelIndex != panelIndex && _panelController.isAttached) {
      _panelController.close();
      setState(() {
        this.panelIndex = newPanelIndex;
      });
    }
    _updatePanel();
  }

  _updatePanel() {
    switch (panelIndex) {
      case PanelIndex.DestinationAndSearch:
        setState(() {
          _snapValue = null;
          _isDraggable = true;
          _backdropTapClosesPanel = true;
          _backdropOpacity = 0.5;
        });
        _setCurrentPanel(SearchPanel(
          slidingUpWidgetController: widget.controller,
          mapController: _mapController,
        ));
        break;
      case PanelIndex.MakeRequest:
        setState(() {
          _snapValue = .2;
          _isDraggable = false;
          _backdropTapClosesPanel = false;
          _backdropOpacity = 0.0;
        });
        _setCurrentPanel(MakeRequestPanel(
          slidingUpWidgetController: widget.controller,
          mapController: _mapController,
        ));
        break;
      case PanelIndex.WaitingToMatch:
        setState(() {
          _snapValue = null;
          _isDraggable = false;
          _backdropTapClosesPanel = false;
          _backdropOpacity = 0;
        });
        _setCurrentPanel(WaitingToMatchPanel(
          slidingUpWidgetController: widget.controller,
        ));
        break;
      case PanelIndex.Matched:
        setState(() {
          _snapValue = null;
          _isDraggable = false;
          _backdropTapClosesPanel = false;
          _backdropOpacity = 0;
        });
        _setCurrentPanel(MatchedPanel(
          slidingUpWidgetController: widget.controller,
        ));
        break;
      default:
        throw UnimplementedError("Called panel not implemented");
    }
  }

  _setCurrentPanel(panel) {
    setState(() => _currentPanel = panel);
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
    
    _slidingUpPanel = SlidingUpPanel(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(widget.radius),
        topRight: Radius.circular(widget.radius),
      ),
      onPanelClosed: () => _updatePanel(),
      onPanelOpened: () => _updatePanel(),
      isDraggable: _isDraggable,
      backdropTapClosesPanel: _backdropTapClosesPanel,
      minHeight: widget.minHeight,
      snapPoint: _snapValue,
      maxHeight: widget.maxHeight,
      controller: _panelController,
      backdropEnabled: true,
      backdropOpacity: _backdropOpacity,
      panelBuilder: (sc) => _panel(sc),
      body: Center(
        child: MapWidget(
          controller: _mapController,
          slidingUpWidgetController: widget.controller,
        ),
      ),
    );
    return _slidingUpPanel;
  }
}

class SlidingUpWidgetController {
  _SlidingUpWidgetState _slidingUpWidgetState;

  _addState(_SlidingUpWidgetState slidingUpWidgetState) {
    this._slidingUpWidgetState = slidingUpWidgetState;
  }

  void set panelIndex(PanelIndex newPanelIndex) {
    _slidingUpWidgetState._setPanelandUpdate(newPanelIndex);
  }

  PanelIndex get panelIndex {
    return _slidingUpWidgetState.panelIndex;
  }

  PanelController get panelController {
    return _slidingUpWidgetState._panelController;
  }

  double get snapPoint {
    return _slidingUpWidgetState._snapValue;
  }

  double get maxHeight {
    return _slidingUpWidgetState.widget.maxHeight;
  }

  double get minHeight {
    return _slidingUpWidgetState.widget.minHeight;
  }

  double get snapHeight {
    return snapPoint * (minHeight + maxHeight);
  }
}

enum PanelIndex {
  DestinationAndSearch,
  MakeRequest,
  WaitingToMatch,
  Matched
}
