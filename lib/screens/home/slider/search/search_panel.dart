import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/screens/home/slider/panel.dart';
import 'package:mule/screens/home/slider/request/make_request_panel.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/services/ext_api_calls.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:mule/widgets/stylized_button.dart';
import 'package:mule/widgets/suggestion_search_bar.dart';

class SearchPanel extends Panel {
  SearchPanel({
    double screenHeight,
    MapController mapController,
    PanelController controller,
    SlidingUpWidgetController slidingUpWidgetController,
    Key key,
  }) : super(
          slidingUpWidgetController: slidingUpWidgetController,
          screenHeight: screenHeight,
          mapController: mapController,
          controller: controller,
          backdropOpacity: 0.5,
          key: key,
        );

  SearchPanel.from(
    Panel panel,
  ) : super(
          slidingUpWidgetController: panel.slidingUpWidgetController,
          screenHeight: panel.screenHeight,
          mapController: panel.mapController,
          controller: panel.controller,
          backdropOpacity: 0.5,
        );

  @override
  void mapStateCallback() {
    if (!mapController.isMapLoading)
      mapController
        ..unsetRouteView()
        ..focusCurrentLocation();
  }

  @override
  List<StylizedButton> get buttons {
    StylizedButton currentLocationButton = CurrentLocationButton(
      size: buttonSize,
      callback: () {
        if (!mapController.isMapLoading) mapController.focusCurrentLocation();
      },
      margin: EdgeInsets.only(bottom: buttonSpacing),
    );
    return [currentLocationButton];
  }

  @override
  _SearchPanelState createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel> with DraggablePanel {
  TextEditingController _destinationController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
  FocusNode _destinationFocusNode = FocusNode();

  bool destinationSelected = false;

  Widget _getForm(bool open, screenHeight) {
    if (!open) {
      _destinationFocusNode.unfocus();
      _searchFocusNode.unfocus();
    } else if (destinationSelected) {
      _searchFocusNode.requestFocus();
    } else {
      _destinationFocusNode.requestFocus();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _slideIcon(),
        AnimatedOpacity(
            opacity: open ? 0.0 : 1.0,
            duration: Duration(milliseconds: 100),
            child: _greetingTitle(screenHeight)),
        _destinationTitle(screenHeight),
        SuggestionSearchBar(
            focusNode: _destinationFocusNode,
            controller: _destinationController,
            hintText: "Destination...",
            icon: Icon(
              Icons.place,
              color: AppTheme.secondaryBlue,
            ),
            spacing: 10,
            elevation: 2,
            suggestionCallback: ExternalApi.getNearbyLocations,
            cardCallback: () {
              setState(() => destinationSelected = true);
            }),
        Container(
          height: 20,
        ),
        AnimatedOpacity(
          opacity: (!destinationSelected || !open) ? 0.0 : 1.0,
          duration: Duration(milliseconds: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _searchBarTitle(screenHeight),
              SuggestionSearchBar(
                controller: _searchController,
                focusNode: _searchFocusNode,
                hintText: "Coffee, Target, Stationery...",
                icon: Icon(
                  Icons.search,
                  color: AppTheme.secondaryBlue,
                ),
                spacing: 10,
                elevation: 2,
                suggestionCallback: ExternalApi.getNearbyPlaces,
                cardCallback: () => _onSubmitChoice(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _slideIcon() {
    return Form(
      child: Container(
        padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Container(
              width: 40.0,
              height: 3.0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightText.withOpacity(0.3),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _greetingTitle(screenHeight) {
    return Container(
      padding: EdgeInsets.only(
        top: AppTheme.elementSize(screenHeight, 10, 12, 14, 17, 20, 22, 26, 30),
      ),
      child: Observer(
        builder: (_) => Text(
          "Hey there, " + GetIt.I.get<UserInfoStore>().firstName + "!",
          style: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w400,
            color: AppTheme.darkGrey,
            fontSize: AppTheme.elementSize(
                screenHeight, 14, 15, 15, 16, 17, 20, 24, 26),
          ),
        ),
      ),
    );
  }

  Widget _destinationTitle(screenHeight) {
    return Container(
      padding: EdgeInsets.only(
          top: AppTheme.elementSize(screenHeight, 1, 2, 3, 4, 5, 6, 8, 10),
          bottom:
              AppTheme.elementSize(screenHeight, 6, 7, 8, 10, 12, 14, 15, 16)),
      child: Text(
        "Where are you headed?",
        style: TextStyle(
          fontFamily: AppTheme.fontName,
          fontWeight: FontWeight.w700,
          color: AppTheme.darkGrey,
          fontSize: AppTheme.elementSize(
              screenHeight, 16, 18, 19, 19, 20, 22, 26, 30),
        ),
      ),
    );
  }

  Widget _searchBarTitle(screenHeight) {
    return Container(
      padding: EdgeInsets.only(
          top: AppTheme.elementSize(screenHeight, 1, 2, 3, 4, 5, 6, 8, 10),
          bottom:
              AppTheme.elementSize(screenHeight, 6, 7, 8, 10, 12, 14, 15, 16)),
      child: Text(
        "What would you like?",
        style: TextStyle(
          fontFamily: AppTheme.fontName,
          fontWeight: FontWeight.w700,
          color: AppTheme.darkGrey,
          fontSize: AppTheme.elementSize(
              screenHeight, 16, 18, 19, 19, 20, 22, 26, 30),
        ),
      ),
    );
  }

  _handleFocus() {
    if (_destinationFocusNode.hasFocus) {
      return widget.slidingUpWidgetController.open();
    }
  }

  _onSubmitChoice() {
    widget.slidingUpWidgetController.panel = MakeRequestPanel.from(widget);
    dispose();
  }

  @override
  void close() {
    if (!isOpen) return;

    setState(() {
      isOpen = false;
    });
  }

  @override
  void open() {
    if (isOpen) return;

    setState(() {
      isOpen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
      child: _getForm(isOpen, screenHeight),
    );
  }

  @override
  void initState() {
    _destinationFocusNode.addListener(() => _handleFocus());
    widget.init(this);
    super.initState();
  }
}
