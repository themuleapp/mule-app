import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';

class UnorderedList extends StatelessWidget {
  UnorderedList(this.texts);
  final List<String> texts;

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];
    for (var text in texts) {
      // Add list item
      widgetList.add(UnorderedListItem(text));
      // Add space between items
      widgetList.add(SizedBox(height: 10.0));
    }

    return Column(children: widgetList);
  }
}

class UnorderedListItem extends StatelessWidget {
  UnorderedListItem(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 7, right: 7),
          child: Icon(
            Icons.circle,
            size: 8,
            color: AppTheme.secondaryBlue,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: AppTheme.elementSize(
                  screenHeight, 15, 15, 16, 16, 17, 18, 22, 26),
              color: AppTheme.darkGrey,
            ),
          ),
        ),
      ],
    );
  }
}
