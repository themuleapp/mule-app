import 'package:flutter/material.dart';
import 'package:mule/screens/home/slider/loading/loading_panel.dart';
import 'package:mule/screens/home/slider/request/make_request_panel.dart';
import 'package:mule/screens/home/slider/match/waiting_to_match_panel.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/search/search_panel.dart';
import 'package:mule/widgets/stylized_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'match/mule_matched_panel.dart';
import 'match/user_matched_panel.dart';

class SlidingUpWidget extends StatefulWidget {
  final SlidingUpWidgetController controller;
  final double radius;
  final double minHeight;
  final double maxHeight;
  final double buttonSpacing;
  final double buttonSize;
  final PanelIndex beginScreen;

  SlidingUpWidget({
    this.controller,
    this.radius = 20.0,
    this.minHeight,
    this.maxHeight,
    this.buttonSize = 50.0,
    this.buttonSpacing = 20.0,
    this.beginScreen = PanelIndex.DestinationAndSearch,
  });

  @override
  _SlidingUpWidgetState createState() =>
      _SlidingUpWidgetState(this.minHeight, this.maxHeight);
}

class _SlidingUpWidgetState extends State<SlidingUpWidget> {
  _SlidingUpWidgetState(this._minHeight, this._maxHeight);

  final PanelController _panelController = PanelController();
  final MapController _mapController = MapController();

  // Slider size
  double _minHeight;
  double _maxHeight;

  // Animation
  EdgeInsets buttonMargin;
  double _backdropOpacity;
  bool _isDraggable;
  bool _backdropTapClosesPanel;
  Function _mapStateCallback;

  // Panel state
  PanelIndex panelIndex;
  Widget _currentPanel;
  List<StylizedButton> _buttonList = [];

  // Buttons
  StylizedButton currentLocationButton;
  StylizedButton cancelButton;
  StylizedButton completedButton;

  @override
  void initState() {
    super.initState();
    _initialzeButtons();
    panelIndex = widget.beginScreen;
    _updatePanel();
    widget.controller?._addState(this);
  }

  void _initialzeButtons() {
    currentLocationButton = CurrentLocationButton(
      size: widget.buttonSize,
      callback: () {
        if (!_mapController.isMapLoading) _mapController.focusCurrentLocation();
      },
      margin: EdgeInsets.only(bottom: widget.buttonSpacing),
    );

    // When using a button that is dependent on a function inside one of the slider panels,
    // the button should be passed as an argument using the name 'buttonBridge'
    cancelButton = CancelButton(
      size: widget.buttonSize,
      callback: () => null,
      margin: EdgeInsets.only(bottom: widget.buttonSpacing),
    );

    completedButton = CompletedButton(
      size: widget.buttonSize,
      callback: () => null,
      margin: EdgeInsets.only(bottom: widget.buttonSpacing),
    );
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
          _minHeight = widget.minHeight;
          _maxHeight = widget.maxHeight;
          _isDraggable = true;
          _backdropTapClosesPanel = true;
          _backdropOpacity = 0.5;
          _buttonList = [currentLocationButton];
          _mapStateCallback = () {
            _mapController.unfocusRoute();
            _mapController.focusCurrentLocation();
          };
        });
        _setCurrentPanel(SearchPanel(
          slidingUpWidgetController: widget.controller,
          mapController: _mapController,
        ));
        break;
      case PanelIndex.MakeRequest:
        setState(() {
          _minHeight =
              widget.minHeight + .25 * (widget.maxHeight - widget.minHeight);
          _maxHeight = widget.maxHeight;
          _isDraggable = false;
          _backdropTapClosesPanel = false;
          _backdropOpacity = 0.0;
          _buttonList = [cancelButton];
          _mapStateCallback = () {
            _mapController.focusOnRoute();
          };
        });
        _setCurrentPanel(MakeRequestPanel(
          slidingUpWidgetController: widget.controller,
          mapController: _mapController,
          buttonBridge: cancelButton,
        ));
        break;
      case PanelIndex.WaitingToMatch:
        setState(() {
          _minHeight = widget.minHeight;
          _maxHeight = widget.maxHeight;
          _isDraggable = false;
          _backdropTapClosesPanel = false;
          _backdropOpacity = 0;
          _buttonList = [cancelButton];
          _mapStateCallback = () {
            _mapController.focusOnRoute();
          };
        });
        _setCurrentPanel(WaitingToMatchPanel(
          slidingUpWidgetController: widget.controller,
          mapController: _mapController,
          buttonBridge: cancelButton,
        ));
        break;
      case PanelIndex.UserMatched:
        setState(() {
          _minHeight = widget.minHeight;
          _maxHeight = widget.maxHeight;
          _isDraggable = false;
          _backdropTapClosesPanel = false;
          _backdropOpacity = 0;
          _buttonList = [currentLocationButton, cancelButton];
          _mapStateCallback = () {
            _mapController.focusOnRoute();
          };
        });
        _setCurrentPanel(UserMatchedPanel(
          slidingUpWidgetController: widget.controller,
          mapController: _mapController,
          buttonBridge: cancelButton,
        ));
        break;
      case PanelIndex.MuleMatched:
        setState(() {
          _minHeight = widget.minHeight;
          _maxHeight = widget.maxHeight;
          _isDraggable = false;
          _backdropTapClosesPanel = false;
          _backdropOpacity = 0;
          _buttonList = [currentLocationButton, cancelButton, completedButton];
          _mapStateCallback = () {
            _mapController.focusOnRoute();
          };
        });
        _setCurrentPanel(MuleMatchedPanel(
          slidingUpWidgetController: widget.controller,
          mapController: _mapController,
          buttonBridge: cancelButton,
          buttonBridge2: completedButton,
        ));
        break;
      case PanelIndex.Loading:
        setState(() {
          _minHeight = widget.minHeight;
          _maxHeight = widget.maxHeight;
          _isDraggable = false;
          _backdropTapClosesPanel = false;
          _buttonList = [];
          _backdropOpacity = 0;
        });
        _setCurrentPanel(LoadingPanel(
          slidingUpWidgetController: widget.controller,
          mapController: _mapController,
        ));
        break;
      default:
        throw UnimplementedError("Called panel not implemented");
    }
    if (!_mapController.isMapLoading) {
      _mapStateCallback();
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
    return SlidingUpPanel(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(widget.radius),
        topRight: Radius.circular(widget.radius),
      ),
      onPanelClosed: () => _updatePanel(),
      onPanelOpened: () => _updatePanel(),
      isDraggable: _isDraggable,
      backdropTapClosesPanel: _backdropTapClosesPanel,
      minHeight: _minHeight,
      maxHeight: _maxHeight,
      controller: _panelController,
      backdropEnabled: true,
      backdropOpacity: _backdropOpacity,
      panelBuilder: (sc) => _panel(sc),
      body: Center(
        child: Stack(
          children: <Widget>[
            MapWidget(
              controller: _mapController,
              slidingUpWidgetController: widget.controller,
              initCallback: _mapStateCallback,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: _panelController.isAttached &&
                              !_panelController.isPanelOpen
                          ? _currentHeight
                          : widget.minHeight,
                    ),
                    child: Container(
                      height: _buttonList.length *
                          (widget.buttonSize + widget.buttonSpacing),
                      width: widget.buttonSize + widget.buttonSpacing,
                      child: Column(
                        children: _buttonList,
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

  double get _currentHeight {
    if (_panelController.isAttached && _panelController.isPanelOpen)
      return _maxHeight;
    return _minHeight;
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

  bool get isActive {
    return _slidingUpWidgetState != null;
  }

  PanelIndex get panelIndex {
    return _slidingUpWidgetState.panelIndex;
  }

  PanelController get panelController {
    return _slidingUpWidgetState._panelController;
  }

  double get maxHeight {
    return _slidingUpWidgetState.widget.maxHeight;
  }

  double get minHeight {
    return _slidingUpWidgetState.widget.minHeight;
  }

  double get currentHeight {
    return _slidingUpWidgetState._currentHeight;
  }

  double get radius {
    return _slidingUpWidgetState.widget.radius;
  }
}

enum PanelIndex {
  DestinationAndSearch,
  MakeRequest,
  WaitingToMatch,
  UserMatched,
  MuleMatched,
  Loading,
}
