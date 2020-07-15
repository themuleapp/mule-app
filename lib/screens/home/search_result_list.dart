import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SearchResultList extends StatefulWidget {
  final TextEditingController controller;

  const SearchResultList({Key key, @required this.controller})
      : super(key: key);

  @override
  _SearchResultListState createState() =>
      _SearchResultListState(controller: this.controller);
}

class _SearchResultListState extends State<SearchResultList> {
  List<Widget> children = [];
  final TextEditingController controller;

  _SearchResultListState({@required this.controller});

  @override
  void initState() {
    controller.addListener(() {
      createSearchResultList(controller.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children,
    );
  }

  createSearchResultList(String text) {
    List results = <Widget>[];

    for (int i = 0; i < text.length; i++) {
      results.add(Card(
        child: ListTile(title: Text(text)),
      ));
    }

    setState(() {
      children = results;
    });
  }
}
