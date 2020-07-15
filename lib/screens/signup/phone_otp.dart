import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/navigation_home_screen.dart';
import 'package:mule/widgets/custom_text_form_field.dart';

class PhoneOTP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          color: AppTheme.lightBlue,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Verify Phone Number",
                      style: TextStyle(
                          fontSize: AppTheme.elementSize(
                              screenHeight, 24, 26, 28, 30, 32, 40, 45, 50),
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkGrey),
                    ),
                  ),
                  SizedBox(
                    height: AppTheme.elementSize(
                        screenHeight, 30, 30, 32, 32, 34, 43, 46, 50),
                  ),
                  Text(
                    "Please enter the code we've messaged you",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: AppTheme.elementSize(
                            screenHeight, 14, 15, 16, 17, 18, 20, 24, 28),
                        color: AppTheme.darkGrey),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: CustomTextFormField(
                            hintText: "", verticalPadding: 25.0),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: CustomTextFormField(
                            hintText: "", verticalPadding: 25.0),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: CustomTextFormField(
                            hintText: "", verticalPadding: 25.0),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: CustomTextFormField(
                            hintText: "", verticalPadding: 25.0),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Didn't receive a code?",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppTheme.elementSize(
                              screenHeight, 14, 15, 16, 17, 18, 20, 24, 28),
                        ),
                      ),
                      SizedBox(
                        width: AppTheme.elementSize(
                            screenHeight, 10, 10, 12, 12, 13, 15, 16, 17),
                      ),
                      GestureDetector(
                        child: Text(
                          "Resend Code",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: AppTheme.elementSize(
                                screenHeight, 14, 15, 16, 17, 18, 20, 24, 28),
                            color: AppTheme.lightBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppTheme.elementSize(
                        screenHeight, 30, 30, 32, 32, 34, 43, 46, 50),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: AppTheme.elementSize(
                        screenHeight, 36, 38, 40, 42, 45, 56, 62, 70),
                    child: FlatButton(
                      color: AppTheme.lightBlue,
                      child: Text(
                        "VERIFY",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppTheme.elementSize(
                              screenHeight, 14, 15, 16, 17, 18, 26, 28, 30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NavigationHomeScreen()));
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
