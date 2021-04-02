import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';

createOrderCompletionDialogue(context) async {
  // flutter defined function
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        content: Text("Have you completed this delivery?"),
        actions: <Widget>[
          TextButton(
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
              Navigator.pop(context, true);
            },
          ),
          TextButton(
            child: Text(
              "Not yet",
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
