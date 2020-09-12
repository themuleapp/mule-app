import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';

createConfirmDialogue(context, actionType) async {
  // flutter defined function
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        content: Text("Are you sure you want to $actionType this request?"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Yes",
              style: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w500,
                color: AppTheme.lightBlue,
                fontSize: 14,
              ),
            ),
            onPressed: () {
              // Dismiss the dialog and
              // also dismiss the swiped item
              Navigator.pop(context, true);
            },
          ),
          FlatButton(
            child: Text(
              "Cancel",
              style: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w500,
                color: AppTheme.lightBlue,
                fontSize: 14,
              ),
            ),
            onPressed: () {
              // Dismiss the dialog but don't
              // dismiss the swiped item
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    },
  );
}
