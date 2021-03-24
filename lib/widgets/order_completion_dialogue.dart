import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/services/mule_api_service.dart';
import 'package:mule/stores/global/user_info_store.dart';

createOrderCompletionDialogue(context, text, order) async {
  // flutter defined function
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        content: text,
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
            onPressed: () async {
              if (GetIt.I.get<UserInfoStore>().fullName ==
                  order.acceptedBy.name) {
                if (await muleApiService.muleCompleteRequest(order.id)) {
                  await GetIt.I.get<UserInfoStore>().updateActiveOrder();
                }
              } else {
                if (await muleApiService.userCompleteRequest(order.id)) {
                  await GetIt.I.get<UserInfoStore>().updateActiveOrder();
                }
              }
            },
          ),
          FlatButton(
            child: Text(
              "Not yet",
              style: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w500,
                color: Colors.red,
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
