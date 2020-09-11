import 'package:flutter/material.dart';

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
            child: Text("Ok"),
            onPressed: () {
              // Dismiss the dialog and
              // also dismiss the swiped item
              print('dismissed');
              Navigator.pop(context, true);
            },
          ),
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              // Dismiss the dialog but don't
              // dismiss the swiped item
              print('Decline');
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    },
  );
}
