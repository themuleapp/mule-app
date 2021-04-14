import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/widgets/unordered_list.dart';

void createReminderWidget(context, String title, List<String> content) {
  final screenHeight = MediaQuery.of(context).size.height;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: AppTheme.elementSize(
                  screenHeight, 15, 15, 16, 17, 18, 19, 22, 26),
              color: AppTheme.darkGrey),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              //height: screenHeight / 4,
              child: UnorderedList(content),
            ),
          ],
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new TextButton(
            child: Text(
              "Close",
              style: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w500,
                color: AppTheme.lightBlue,
                fontSize: 14,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
