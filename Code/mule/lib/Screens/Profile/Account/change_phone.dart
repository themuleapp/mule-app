import 'package:flutter/material.dart';
import 'package:mule/Screens/Login/login_screen.dart';
import 'package:mule/Screens/Login/ForgotPassword/email_otp.dart';
import 'package:mule/Screens/Signup/phone_otp.dart';
import 'package:mule/Widgets/custom_text_form_field.dart';
import 'package:mule/config/app_theme.dart';

class ChangePhone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  "Change Phone Number",
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGrey),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              _changePhoneNumberForm(context),
              SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _changePhoneNumberForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "You can update your phone number and we'll send you a verification code",
          style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w500,
              color: AppTheme.darkGrey),
        ),
        SizedBox(
          height: 30.0,
        ),
        Row(
          children: <Widget>[
            Container(
              width: 60.0,
              child: CustomTextFormField(
                hintText: "+1",
              ),
            ),
            SizedBox(width: 15.0),
            Expanded(
              child: CustomTextFormField(
                hintText: "Phone number",
              ),
            )
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
              "SUBMIT",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PhoneOTP()));
            },
          ),
        )
      ],
    );
  }
}
