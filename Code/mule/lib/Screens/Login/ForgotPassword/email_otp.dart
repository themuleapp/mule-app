import 'package:flutter/material.dart';
import 'package:mule/Screens/Login/ForgotPassword/reset_password.dart';
import 'package:mule/Widgets/custom_text_form_field.dart';
import 'package:mule/config/app_theme.dart';

class EmailOTP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                      "Verify Email",
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGrey
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Please enter the code we've emailed you",
                    style:
                    TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17.0,
                        color: AppTheme.darkGrey
                    ),
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
                  Wrap(
                    children: <Widget>[
                      Text(
                        "Didn't receive a code?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      GestureDetector(
                        child: Text(
                          "Resend Code",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.lightBlue,
                          ),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 45.0,
                    child: FlatButton(
                      color: AppTheme.lightBlue,
                      child: Text(
                        "VERIFY",
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => ResetPassword()));
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
