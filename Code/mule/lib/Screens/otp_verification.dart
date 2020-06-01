import 'package:flutter/material.dart';
import 'package:mule/Widgets/custom_text_form_field.dart';
import 'package:mule/config/app_colors.dart';

class OtpVerification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          color: AppColors.lightBlue,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      "Verify Email",
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGrey
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Check your email, we've sent you an OTP",
                    style:
                    TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: AppColors.darkGrey
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
                            color: AppColors.lightBlue,
                          ),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  CustomTextFormField(
                    hintText: "Password",
                    obscureText: true,
                    //controller: passwordController,
                    validator: (val) => val.length < 4
                        ? "Password too short"
                        : null,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  CustomTextFormField(
                    hintText: "Confirm Password",
                    obscureText: true,
                    //controller: passwordController,
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
                        "VERIFY",
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                      onPressed: () {},
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
