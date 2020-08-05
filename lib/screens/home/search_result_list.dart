import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/models/data/suggestions.dart';
import 'package:mule/stores/location/location_store.dart';

class SearchResultList extends StatefulWidget {
  final TextEditingController controller;
  final double spacing;
  final FocusNode focusNode;

  const SearchResultList(
      {Key key,
      @required this.controller,
      @required this.focusNode,
      this.spacing})
      : super(key: key);

  @override
  _SearchResultListState createState() => _SearchResultListState(
      spacing: this.spacing,
      controller: this.controller,
      focusNode: this.focusNode);
}

class _SearchResultListState extends State<SearchResultList> {
  List<Widget> children = [];

  final TextEditingController controller;
  final FocusNode focusNode;
  final double spacing;
  final Suggestion suggestion;

  static const lat = 40.793429;
  static const lng = -77.860314;

  _SearchResultListState(
      {@required this.controller, @required this.focusNode, this.spacing,
        this.suggestion});

  Future<List<Suggestion>> getNearbyPlaces(String searchTerm) async {
    if (searchTerm.isEmpty) {
      return null;
    }
    String API_KEY = "AIzaSyCZQ2LiMZViXvH7xoSA5M2sK635Bgui2zs";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    String request = '$baseURL?location=$lat,$lng&radius=1500&keyword=$searchTerm&key=$API_KEY';

    Response res = await Dio().get(request);
    if (res == null)
      return null;
    return res.data['results']
        .map<Suggestion>((singleData) {
          return Suggestion(singleData['name'], singleData['vicinity']);
        })
        .toList();
  }

  @override
  void initState() {
    controller.addListener(() async {
      if (controller.text.isEmpty) {
       _clear();
      }
      List<Suggestion>suggestions = await getNearbyPlaces(controller.text);
      _createSearchResultList(suggestions, spacing);
    });
    focusNode.addListener(() {
      _focusHandler();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children,
    );
  }

  _focusHandler() {
    if (focusNode.hasFocus == false) {
      _clear();
    }
  }

  _createSearchResultList(List<Suggestion> suggestions, double spacing) {
    List results = <Widget>[];

    if (suggestions == null) {
      return results;
    }
    for (Suggestion suggestion in suggestions) {
      results.add(Card(
        margin: EdgeInsets.only(top: 10),
        elevation: 7,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)
          ),
        ),
        shadowColor: AppTheme.darkGrey.withOpacity(0.5),
        child: InkWell(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)
          ),
          onTap: () {
            GetIt.I.get<LocationStore>().updatePlace(suggestion);
            controller.text = suggestion.name;
            _update([]);
          },
          child: ListTile(
            title: Text(suggestion.name),
            subtitle: Text(suggestion.vicinity),
            trailing: Icon(
              Icons.info_outline,
              color: AppTheme.secondaryBlue,
            ),
          ),
        ),
      ));
    }
    results.add(SizedBox(height: spacing));
    _update(results);
  }

  _update(List<Widget> newChildren) {
    // Check if widget is loaded
    if (!this.mounted) {
      return;
    }
    setState(() {
      children = newChildren;
    });
  }

  _clear() {
    _update([]);
  }
}
