import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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

class Suggestion {
  String description;
  String vicinity;

  Suggestion(String description, String vicinity)
      : description = description, vicinity = vicinity;

//  Suggestion.fromJson(Map<String, dynamic> json)
//      : description = json['description'];
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
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {},
          child: ListTile(
            title: Text(suggestion.description),
            leading: Icon(Icons.satellite),
            subtitle: Text(suggestion.vicinity),
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
