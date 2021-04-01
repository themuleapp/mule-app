import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/models/data/order_data.dart';

Future<bool> enterPinDialogue(
    BuildContext context, String text, OrderData order) async {
  bool success = false;
  final screenHeight = MediaQuery.of(context).size.height;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Enter the PIN",
                style: TextStyle(
                    fontSize: AppTheme.elementSize(
                        screenHeight, 24, 26, 28, 30, 32, 40, 45, 50),
                    fontWeight: FontWeight.w700,
                    color: AppTheme.darkerText),
              ),
              SizedBox(
                height: AppTheme.elementSize(
                    screenHeight, 6, 8, 9, 10, 12, 12, 14, 16),
              ),
              Text(
                "Please enter the PIN given to the customer to confirm the delivery",
                style: TextStyle(
                    fontSize: AppTheme.elementSize(
                        screenHeight, 14, 15, 16, 17, 18, 20, 24, 28),
                    fontWeight: FontWeight.w500,
                    color: AppTheme.darkGrey),
              ),
              SizedBox(
                height: AppTheme.elementSize(
                    screenHeight, 6, 8, 9, 10, 12, 12, 14, 16),
              ),
              //TODO: Add PIN fields
              Center(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: 1.0,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16, bottom: 8, right: 16),
                    child: ProgressButton(
                      defaultWidget: Text(
                        'Submit',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppTheme.elementSize(
                              screenHeight, 14, 15, 16, 17, 18, 18, 18, 18),
                          letterSpacing: 0.0,
                          color: AppTheme.white,
                        ),
                      ),
                      progressWidget: CircularProgressIndicator(
                          backgroundColor: AppTheme.white,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.secondaryBlue)),
                      width: MediaQuery.of(context).size.width,
                      height: AppTheme.elementSize(
                          screenHeight, 36, 38, 42, 48, 48, 48, 48, 48),
                      color: AppTheme.secondaryBlue,
                      borderRadius: AppTheme.elementSize(
                          screenHeight, 8, 10, 12, 16, 16, 16, 16, 16),
                      animate: true,
                      type: ProgressButtonType.Raised,
                      onPressed: () async {
                        await Future.delayed(
                            const Duration(milliseconds: 1000), () => 42);
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
  return success;
}
