import 'package:flutter/material.dart';
import 'package:mule/Screens/login_screen.dart';
import 'package:mule/Screens/otp_verification.dart';
import 'package:mule/Widgets/custom_text_form_field.dart';
import 'package:mule/config/app_colors.dart';

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          color: AppColors.lightBlue,
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Log In",
                style: TextStyle(
                  color: AppColors.lightBlue,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              _forgotPasswordForm(context),
              SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _forgotPasswordForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Don't worry, enter your email to receive an OTP!",
          style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey),
        ),
        SizedBox(
          height: 20.0,
        ),
        CustomTextFormField(
          hintText: "Email",
        ),
        SizedBox(
          height: 30.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 45.0,
          child: FlatButton(
            color: AppColors.lightBlue,
            child: Text(
              "SUBMIT",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => OtpVerification()));
            },
          ),
        )
      ],
    );
  }
}
