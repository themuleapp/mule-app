import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/services/mule_api_service.dart';
  
FocusNode textfield; 

Future<bool> enterPinDialogue(
    BuildContext context, String text, OrderData order) async {
  bool success = false;
  final screenHeight = MediaQuery.of(context).size.height;
  List<TextEditingController> textEditors = [];

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              Row(
                children: _buildPinField(textEditors: textEditors),
                ),
              SizedBox(
                height: AppTheme.elementSize(
                    screenHeight, 14, 16, 18, 19, 20, 21, 22, 24),
              ),
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
                        String pin = "";
                        textEditors.forEach((e) => pin += e.text);
                        print(pin);
                        success = await muleApiService.completeRequest(order.id, pin); 
                        Navigator.of(context).pop();
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

List<Widget> _buildPinField({int numberOfFields=4, List<TextEditingController> textEditors}) {
  if(numberOfFields < 0) {
    throw Exception("Invalid argument, number of fields must be at least 0");
  }
  List<Widget> list = [];
  List<FocusNode> focusList = [];

  // Populate focusList
  focusList.add(null);
  for(var i=0; i<numberOfFields; i++) {
    focusList.add(FocusNode());
  }
  focusList.add(null);
 
  // Assign each textfield a focusNode, as well as a reference to the textfield before/after it
  var i;
  for(i=1; i<numberOfFields; i++) {
    list.add(_textField(textEditors, focusList[i], focusList[i-1], focusList[i+1]));
    list.add(_spacing());
  }
  list.add(_textField(textEditors, focusList[i], focusList[i-1], focusList[i+1]));
 
  // Request focus for first textfield
  focusList[1].requestFocus();
  return list;
}

Widget _textField(List<TextEditingController> controllers, FocusNode myFocus, FocusNode previousFocus, FocusNode nextFocus) {
  TextEditingController controller = TextEditingController();
  controllers?.add(controller);

  return Expanded(
    child: TextField(
      focusNode: myFocus,
      controller: controller,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(1),
      ],
      onChanged: (field) {
        if(field.isEmpty) {
          previousFocus?.requestFocus();
        } else {
          nextFocus?.requestFocus();
        }
      }
    ),
  );
}

Widget _spacing() {
  return SizedBox(
    width: 20.0,
  );
}

