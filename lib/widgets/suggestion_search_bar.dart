import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/models/data/suggestion.dart';

class SuggestionSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function suggestionCallback;

  final Function cardCallback;
  final String hintText;
  final double spacing;
  final double elevation;
  final Icon icon;

  final timeout;

  const SuggestionSearchBar({
    Key key,
    @required this.controller,
    @required this.focusNode,
    @required this.suggestionCallback,
    this.cardCallback,
    this.hintText,
    this.spacing,
    this.elevation,
    this.icon,
    this.timeout = 1,
  }) : super(key: key);

  @override
  _SuggestionSearchBarState createState() => _SuggestionSearchBarState(
        controller: this.controller,
        suggestionCallback: this.suggestionCallback,
        focusNode: this.focusNode,
      );
}

class _SuggestionSearchBarState extends State<SuggestionSearchBar> {
  List<Widget> children = [];

  final TextEditingController controller;
  final Function suggestionCallback;
  final FocusNode focusNode;

  RestartableTimer controllerTimer; 
  String query;

  _SuggestionSearchBarState({
    @required this.controller,
    @required this.suggestionCallback,
    @required this.focusNode,
  });

  @override
  void initState() {
    focusNode.addListener(() => _focusHandler());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [];

    content.add(_searchBar(focusNode, controller));
    content.addAll(this.children);

    return Column(
      children: content,
    );
  }

  Future<List<Suggestion>> _getSuggestions(String query) async {
    List<Suggestion> suggestions = await suggestionCallback(query);
    return (suggestions == null) ? [] : suggestions;
  }

  _timedoutSuggestionsBuilder() {
    if(controllerTimer == null) {
      controllerTimer = RestartableTimer(Duration(seconds: widget.timeout), () => _buildSuggestionsList());
    } else {
      controllerTimer.reset();
    }
    setState (() {
      children = [SizedBox(height: 50), CircularProgressIndicator()];
    });
  }

  _buildSuggestionsList() async {
    if (controller.text.isEmpty || !focusNode.hasFocus) {
      _clear();
      return;
    }
    List<Suggestion> suggestions = await _getSuggestions(controller.text);
    _createSearchResultList(suggestions);
  }

  _focusHandler() {
    if (focusNode.hasFocus == false) {
      _clear();
    } else if (children.isEmpty) {
      _timedoutSuggestionsBuilder();
    }
  }

  _update(List<Widget> newChildren) {
    if (!this.mounted) {
      return;
    }
    setState(() => children = newChildren);
  }

  _clear() {
    setState(() => children = []);
  }

  _autocompleteOnTap(String selectedValue, Suggestion suggestion) async {
    await suggestion.chooseLocation();
    controller.text = selectedValue;
    focusNode.unfocus();
  }

  Widget _searchBar(FocusNode focusNode, TextEditingController controller) {
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
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        cursorColor: AppTheme.lightBlue,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.go,
        onChanged: (_) => (widget.timeout == null || widget.timeout < 0) 
            ? _buildSuggestionsList() 
            : _timedoutSuggestionsBuilder(),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 15),
          hintText: widget.hintText,
          prefixIcon: widget.icon,
          suffixIcon: IconButton(
            icon: Icon(Icons.clear, color: Colors.black38),
            splashRadius: 20,
            onPressed: () => controller.text = "",
          ),
        ),
      ),
    );
  }

  _createSearchResultList(List<Suggestion> suggestions) {
    List results = <Widget>[];

    if (suggestions == null) {
      return results;
    }
    for (Suggestion suggestion in suggestions) {
      results.add(_cardFromSuggestion(suggestion));
    }
    results.add(SizedBox(height: widget.spacing));
    _update(results);
  }

  Widget _cardFromSuggestion(Suggestion suggestion) {
    ListTile tile;

    if (suggestion is PlacesSuggestion) {
      tile = _placesTile(suggestion);
    } else if (suggestion is DestinationSuggestion) {
      tile = _locationTile(suggestion);
    } else {
      throw UnimplementedError("Type of suggestion not implemented");
    }
    return _buildCard(tile, suggestion);
  }

  Widget _buildCard(ListTile tile, Suggestion suggestion) {
    return Card(
      margin: EdgeInsets.only(top: 10),
      elevation: widget.elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      shadowColor: AppTheme.darkGrey.withOpacity(0.5),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        onTap: () {
          _autocompleteOnTap(suggestion.description, suggestion);
          if (widget.cardCallback != null) widget.cardCallback();
        },
        child: tile,
      ),
    );
  }

  // Should be in a different file? Builder?

  Widget _placesTile(PlacesSuggestion suggestion) {
    return ListTile(
      title: Text(suggestion.name),
      subtitle: Text(suggestion.vicinity),
      trailing: Icon(
        Icons.info_outline,
        color: AppTheme.secondaryBlue,
      ),
    );
  }

  Widget _locationTile(DestinationSuggestion suggestion) {
    return ListTile(
      title: Text(suggestion.name),
      subtitle: Text(suggestion.vicinity),
    );
  }
}
