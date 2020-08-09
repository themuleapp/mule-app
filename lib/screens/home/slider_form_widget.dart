import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/ext_api_calls.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:mule/widgets/suggestion_search_bar.dart';

class SliderFormWidget extends StatefulWidget {
  final bool panelIsOpen;
  final FocusNode destinationFocusNode;

  const SliderFormWidget({
    Key key,
    this.panelIsOpen,
    this.destinationFocusNode,
  }) : super(key: key);

  @override
  _SliderFormWidgetState createState() => _SliderFormWidgetState();
}

class _SliderFormWidgetState extends State<SliderFormWidget> {
  FocusNode _searchFocusNode = FocusNode();

  TextEditingController _destinationController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  Widget _getForm(bool open) {
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
          spacing: 10,
          elevation: 2,
          suggestionCallback: ExternalApi.getNearbyLocations,
        ),
        AnimatedContainer(
          height: open ? 20 : 100,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        ),
        _searchBarTitle(),
        SuggestionSearchBar(
          controller: _searchController,
          focusNode: _searchFocusNode,
          hintText: "Coffee, Bagel...",
          spacing: 10,
          elevation: 2,
          suggestionCallback: ExternalApi.getNearbyPlaces,
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

  Widget _searchBarContainer(SuggestionSearchBar searchbar) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightGrey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: searchbar,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
      child: _getForm(widget.panelIsOpen),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
