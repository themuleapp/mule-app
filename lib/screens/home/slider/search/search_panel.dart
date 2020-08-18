import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/ext_api_calls.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:mule/widgets/suggestion_search_bar.dart';

class SearchPanel extends StatefulWidget {
  final FocusNode destinationFocusNode;
  final PanelIndex panelIndex;
  final SlidingUpWidgetController slidingUpWidgetController;

  const SearchPanel({
    Key key,
    this.destinationFocusNode,
    this.panelIndex,
    this.slidingUpWidgetController,
  }) : super(key: key);

  @override
  _SearchPanelState createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel> {
  FocusNode _searchFocusNode = FocusNode();

  TextEditingController _destinationController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  bool _destinationSelected = false;

  Widget _getForm(bool open) {
    if (!open) {
      widget.destinationFocusNode.unfocus();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _slideIcon(),
        AnimatedOpacity(
            opacity: open ? 0.0 : 1.0,
            duration: Duration(milliseconds: 100),
            child: _greetingTitle()),
        _destinationTitle(),
        SuggestionSearchBar(
          focusNode: widget.destinationFocusNode,
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
            setState(() {
              _destinationSelected = true;
            });
          },
        ),
        AnimatedContainer(
          height: open ? 20 : 100,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        ),
        AnimatedOpacity(
          opacity: _destinationSelected ? 1.0 : 0.0,
          duration: Duration(milliseconds: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _searchBarTitle(),
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
                cardCallback: () {
                  widget.slidingUpWidgetController.panelIndex =
                      PanelIndex.MakeRequest;
                },
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

  Widget _greetingTitle() {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
      ),
      child: Observer(
        builder: (_) => Text(
          "Hey there, " + GetIt.I.get<UserInfoStore>().firstName + "!",
          style: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w400,
            color: AppTheme.darkGrey,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _destinationTitle() {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 10),
      child: Text(
        "Where are you headed?",
        style: TextStyle(
          fontFamily: AppTheme.fontName,
          fontWeight: FontWeight.w700,
          color: AppTheme.darkGrey,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _searchBarTitle() {
    return Container(
      padding: EdgeInsets.only(
        top: 5,
        bottom: 10,
      ),
      child: Text(
        "What would you like?",
        style: TextStyle(
          fontFamily: AppTheme.fontName,
          fontWeight: FontWeight.w700,
          color: AppTheme.darkGrey,
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
      child: _getForm(
          widget.slidingUpWidgetController.panelController.isPanelOpen),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
