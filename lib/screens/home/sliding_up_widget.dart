import 'package:flutter/material.dart';
import 'package:mule/screens/home/make_request_panel.dart';
import 'package:mule/screens/home/map_widget.dart';
import 'package:mule/screens/home/slider_form_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingUpWidget extends StatefulWidget {
  @override
  _SlidingUpWidgetState createState() => _SlidingUpWidgetState();
}

class _SlidingUpWidgetState extends State<SlidingUpWidget> {
  final FocusNode _destinationFocusNode = FocusNode();
  final PanelController _panelController = PanelController();
  final double radius = 20.0;

  bool panelIsOpen = false;
  bool programmaticallyOpeningOrClosing = false;

  PanelIndex panelIndex;
  Widget _currentPanel;

  _openPanel() {
    _panelController.open().then((value) => setState(() {
          programmaticallyOpeningOrClosing = false;
          panelIsOpen = true;
        }));
  }

  _closePanel() {
    _panelController.close().then((value) => setState(() {
          programmaticallyOpeningOrClosing = false;
          panelIsOpen = false;
        }));
    _destinationFocusNode.unfocus();
  }

  _handleSearchFocus() {
    if (_destinationFocusNode.hasFocus) {
      setState(() {
        programmaticallyOpeningOrClosing = true;
      });
      this._openPanel();
    }
  }

  _handlePanelSlide(double percentage) {
    if (programmaticallyOpeningOrClosing) {
      return;
    }
    if (!panelIsOpen && percentage >= 0.7) {
      this._openPanel();
    } else if (panelIsOpen && percentage <= 0.5) {
      this._closePanel();
    }
  }

  @override
  void initState() {
    _destinationFocusNode.addListener(_handleSearchFocus);
    setState(() => panelIndex = PanelIndex.DestinationAndSearch);

    _updatePanel();
    super.initState();
  }

  void _updatePanel() {
    switch (panelIndex) {
      case PanelIndex.DestinationAndSearch:
        _setCurrentPanel(SliderFormWidget(
          panelIsOpen: panelIsOpen,
          destinationFocusNode: _destinationFocusNode,
        ));
        break;
      case PanelIndex.MakeRequest:
        _setCurrentPanel(MakeRequestPanel());
        break;
      default:
        throw UnimplementedError("Called panel not implemented");
    }
  }

  void _setCurrentPanel(panel) {
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
    final screenHeight = MediaQuery.of(context).size.height;
    return SlidingUpPanel(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      ),
      onPanelSlide: this._handlePanelSlide,
      isDraggable: false,
      minHeight: screenHeight / 4,
      snapPoint: 1 / 4,
      maxHeight: screenHeight - 120,
      controller: _panelController,
      backdropEnabled: true,
      panelBuilder: (sc) => _panel(sc),
      body: Center(
        child: MapWidget(),
      ),
    );
  }
}

enum PanelIndex {
  DestinationAndSearch,
  MakeRequest,
}
