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

class _SearchResultListState extends State<SearchResultList> {
  List<Widget> children = [];

  final TextEditingController controller;
  final FocusNode focusNode;
  final double spacing;

  _SearchResultListState(
      {@required this.controller, @required this.focusNode, this.spacing});

  @override
  void initState() {
    controller.addListener(() {
      _createSearchResultList(controller.text, spacing);
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

  _createSearchResultList(String text, double spacing) {
    List results = <Widget>[];

    for (int i = 0; i < text.length; i++) {
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
            title: Text("A Title"),
            leading: Icon(Icons.satellite),
            subtitle: Text("More text"),
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
