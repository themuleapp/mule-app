import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/stores/global/user_info_store.dart';

class SliderFormWidget extends StatefulWidget {
  final bool panelIsOpen;
  final FocusNode destinationFocusNode;
  final FocusNode fakeFocusNode;

  const SliderFormWidget(
      {Key key,
      this.panelIsOpen,
      this.destinationFocusNode,
      this.fakeFocusNode})
      : super(key: key);

  @override
  _SliderFormWidgetState createState() => _SliderFormWidgetState();
}

class Suggestion {
  String description;
  String placeId;

  Suggestion.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        placeId = json['place_id'];
}

class _SliderFormWidgetState extends State<SliderFormWidget> {
  TextEditingController _destinationController = TextEditingController();

  Future<List<Suggestion>> _handleSearchDestination(String searchTerm) async {
    String API_KEY = "AIzaSyCZQ2LiMZViXvH7xoSA5M2sK635Bgui2zs";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$searchTerm&key=$API_KEY&type=address';

    Response res = await Dio().get(request);
    return res.data['predictions']
        .map<Suggestion>((singleData) => Suggestion.fromJson(singleData))
        .toList();
  }

  Widget _getFormDependingPanelOpen() {
    if (widget.panelIsOpen) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _slideIcon(),
          SizedBox(
            height: 20,
          ),
          _destinationTitle(),
          _destinationBar(
            focusNode: widget.destinationFocusNode,
            controller: _destinationController,
          ),
          SizedBox(
            height: 200,
          ),
          _searchBarTitle(),
          _searchBar(),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _slideIcon(),
          _greetingTitle(),
          _destinationTitle(),
          SizedBox(
            height: 10,
          ),
          _destinationBar(
            focusNode: widget.fakeFocusNode,
            controller: TextEditingController(),
          ),
        ],
      );
    }
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
        top: 30,
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

  Widget _destinationBar({
    @required FocusNode focusNode,
    @required TextEditingController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightGrey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          cursorColor: AppTheme.lightBlue,
          controller: controller,
          textInputAction: TextInputAction.go,
          focusNode: focusNode,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 15),
            hintText: "Destination...",
            prefixIcon: IconButton(
              splashColor: AppTheme.lightBlue,
              icon: Icon(
                Icons.add_location,
                color: AppTheme.secondaryBlue,
              ),
              onPressed: () {
                print(focusNode == primaryFocus);
              },
            ),
          ),
        ),
        suggestionsCallback: (pattern) async {
          return await _handleSearchDestination(pattern);
        },
        itemBuilder: (context, Suggestion suggestion) {
          return ListTile(
            title: Text(suggestion.description),
          );
        },
        onSuggestionSelected: (Suggestion suggestion) {
          controller.text = suggestion.description;
        },
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
            elevation: 0.7,
            constraints: BoxConstraints(minHeight: 40.0, maxHeight: 200.0)),
      ),
      // child: TextFormField(
      //   focusNode: focusNode,
      //   controller: _destinationController,
      //   cursorColor: AppTheme.lightBlue,
      //   keyboardType: TextInputType.text,
      //   textInputAction: TextInputAction.go,
      //   decoration: InputDecoration(
      //     border: InputBorder.none,
      //     contentPadding: EdgeInsets.only(top: 15),
      //     hintText: "Destination...",
      //     prefixIcon: IconButton(
      //       splashColor: AppTheme.lightBlue,
      //       icon: Icon(
      //         Icons.add_location,
      //         color: AppTheme.secondaryBlue,
      //       ),
      //       onPressed: () {},
      //     ),
      //   ),
      // ),
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

  Widget _searchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightGrey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: TextFormField(
        // focusNode: _searchfocusNode,
        cursorColor: AppTheme.lightBlue,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.go,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 15),
          hintText: "Search...",
          prefixIcon: IconButton(
            splashColor: AppTheme.lightBlue,
            icon: Icon(
              Icons.search,
              color: AppTheme.secondaryBlue,
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
      child: _getFormDependingPanelOpen(),
    );
  }
}
