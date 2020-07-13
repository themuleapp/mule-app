import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/widgets/custom_text_form_field.dart';

class ChangeEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.white,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: AppTheme.elementSize(
                screenHeight, 25, 28, 30, 33, 25, 26, 27, 29),
          ),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          color: AppTheme.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    "Change Email",
                    style: TextStyle(
                        fontSize: AppTheme.elementSize(
                            screenHeight, 28, 29, 30, 31, 32, 35, 40, 48),
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGrey),
                  ),
                ),
                SizedBox(
                  height: AppTheme.elementSize(
                      screenHeight, 30, 31, 32, 33, 35, 36, 37, 38),
                ),
                _changeEmailForm(context, screenHeight),
                SizedBox(
                  height: AppTheme.elementSize(
                      screenHeight, 30, 31, 32, 33, 35, 36, 37, 38),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _changeEmailForm(BuildContext context, double screenHeight) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "You can update your email address",
            style: TextStyle(
                fontSize: AppTheme.elementSize(
                    screenHeight, 17, 18, 19, 20, 22, 24, 26, 28),
                fontWeight: FontWeight.w500,
                color: AppTheme.darkGrey),
          ),
          SizedBox(
            height: AppTheme.elementSize(
                screenHeight, 20, 21, 22, 23, 25, 26, 27, 50),
          ),
          CustomTextFormField(
            hintText: "Email",
          ),
          SizedBox(
            height: AppTheme.elementSize(
                screenHeight, 30, 31, 32, 33, 35, 36, 37, 39),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: AppTheme.elementSize(
                screenHeight, 45, 46, 47, 50, 55, 62, 70, 76),
            child: FlatButton(
              color: AppTheme.lightBlue,
              child: Text(
                "SUBMIT",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppTheme.elementSize(
                      screenHeight, 16, 18, 20, 22, 24, 26, 28, 30),
                ),
              ),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
