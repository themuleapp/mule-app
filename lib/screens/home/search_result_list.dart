import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SearchResultList extends StatefulWidget {
  final TextEditingController controller;
  final double spacing;

  const SearchResultList({Key key, @required this.controller, this.spacing})
      : super(key: key);

  @override
  _SearchResultListState createState() => _SearchResultListState(
      spacing: this.spacing, controller: this.controller);
}

class _SearchResultListState extends State<SearchResultList> {
  List<Widget> children = [];

  final TextEditingController controller;
  final double spacing;

  _SearchResultListState({@required this.controller, this.spacing});

  @override
  void initState() {
    controller.addListener(() {
      createSearchResultList(controller.text, spacing);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children,
    );
  }

  createSearchResultList(String text, double spacing) {
    List results = <Widget>[];

    results.add(Divider(height: 20));

    for (int i = 0; i < text.length; i++) {
      results.add(Card(
        margin: EdgeInsets.only(bottom: 10),
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
    setState(() {
      children = results;
    });
  }
}
