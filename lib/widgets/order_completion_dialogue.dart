import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/services/mule_api_service.dart';
import 'package:mule/stores/global/user_info_store.dart';

Future<bool> createOrderCompletionDialogue(
    BuildContext context, String text, OrderData order) async {
  // flutter defined function
  bool success = false;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        content: Text(text),
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
            onPressed: () async {
              if (GetIt.I.get<UserInfoStore>().fullName ==
                  order.acceptedBy.name) {
                // success = await muleApiService.muleCompleteRequest(order.id);
              } else {
                // success = await muleApiService.userCompleteRequest(order.id);
              }
              Navigator.pop(context, false);
            },
          ),
          TextButton(
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
  return success;
}
