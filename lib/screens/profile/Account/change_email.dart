import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/widgets/custom_text_form_field.dart';

class ChangeEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: AppTheme.elementSize(
                screenHeight, 25, 25, 25, 25, 27, 33, 38, 45),
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
                            screenHeight, 24, 26, 28, 30, 32, 40, 45, 50),
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGrey),
                  ),
                ),
                SizedBox(
                  height: AppTheme.elementSize(
                      screenHeight, 30, 30, 32, 32, 34, 43, 46, 50),
                ),
                Text(
                  "You can update your email address",
                  style: TextStyle(
                      fontSize: AppTheme.elementSize(
                          screenHeight, 14, 15, 16, 17, 18, 20, 24, 28),
                      fontWeight: FontWeight.w500,
                      color: AppTheme.darkGrey),
                ),
                _changeEmailForm(context, screenHeight),
                SizedBox(
                  height: AppTheme.elementSize(
                      screenHeight, 30, 30, 30, 32, 32, 36, 37, 38),
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
          SizedBox(
            height: AppTheme.elementSize(
                screenHeight, 20, 20, 22, 22, 23, 26, 27, 50),
          ),
          CustomTextFormField(
            hintText: "Email",
          ),
          SizedBox(
            height: AppTheme.elementSize(
                screenHeight, 20, 20, 22, 22, 24, 30, 36, 40),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: AppTheme.elementSize(
                screenHeight, 36, 38, 40, 42, 45, 56, 62, 70),
            child: FlatButton(
              color: AppTheme.lightBlue,
              child: Text(
                "SUBMIT",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppTheme.elementSize(
                      screenHeight, 14, 15, 16, 17, 18, 26, 28, 30),
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
