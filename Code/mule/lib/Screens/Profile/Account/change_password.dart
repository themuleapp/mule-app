import 'package:flutter/material.dart';
import 'package:mule/Widgets/custom_text_form_field.dart';
import 'package:mule/config/app_theme.dart';

class ChangePassword extends StatelessWidget {
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
                    //padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Change Password",
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkGrey
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  CustomTextFormField(
                    hintText: "Current Password",
                    obscureText: true,
                    //controller: passwordController,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  CustomTextFormField(
                    hintText: "New Password",
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
                    hintText: "Confirm New Password",
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
