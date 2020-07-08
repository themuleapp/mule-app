import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/screens/home/map_widget.dart';
import 'package:mule/screens/home/slider_form_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingUpWidget extends StatefulWidget {
  @override
  _SlidingUpWidgetState createState() => _SlidingUpWidgetState();
}

class _SlidingUpWidgetState extends State<SlidingUpWidget> {
  final FocusNode _fakeFocusNode = FocusNode();
  final FocusNode _destinationFocusNode = FocusNode();
  final PanelController _panelController = PanelController();
  final BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(20.0),
    topRight: Radius.circular(20.0),
  );
  bool panelIsOpen = false;
  bool programmaticallyOpeningOrClosing = false;

  _openPanel() {
    _panelController.open().then((value) => setState(() {
          programmaticallyOpeningOrClosing = false;
        }));
    setState(() {
      panelIsOpen = true;
    });
  }

  _closePanel() {
    _panelController.close().then((value) => setState(() {
          programmaticallyOpeningOrClosing = false;
        }));
    setState(() {
      panelIsOpen = false;
    });
  }

  _handleSearchFocus() {
    if (_fakeFocusNode.hasFocus) {
      setState(() {
        programmaticallyOpeningOrClosing = true;
      });
      this._openPanel();
      _fakeFocusNode.unfocus();
      _destinationFocusNode.requestFocus();
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
    _fakeFocusNode.addListener(_handleSearchFocus);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SlidingUpPanel(
      borderRadius: radius,
      onPanelSlide: this._handlePanelSlide,
//      minHeight: AppTheme.elementSize(screenHeight, 200, 210, 230, 350, 360, 380, 400, 420),
      minHeight: screenHeight / 3,
      maxHeight: screenHeight - 120,
      controller: _panelController,
      backdropEnabled: true,
      panel: SliderFormWidget(
        panelIsOpen: panelIsOpen,
        destinationFocusNode: _destinationFocusNode,
        fakeFocusNode: _fakeFocusNode,
      ),
      body: Center(
        child: MapWidget(),
      ),
    );
  }
}
