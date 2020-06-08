import 'package:flutter/material.dart';
import 'package:mule/Screens/Login/login_screen.dart';
import 'package:mule/Widgets/custom_text_form_field.dart';
import 'package:mule/config/app_theme.dart';

class ResetPassword extends StatelessWidget {
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
                      "Reset Password",
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
                    "Enter a new password",
                    style:
                    TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17.0,
                        color: AppTheme.darkGrey
                    ),
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
                      color: AppTheme.lightBlue,
                      child: Text(
                        "SUBMIT",
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => LoginScreen()));
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
