import 'package:flutter/material.dart';
import 'package:mule/Widgets/custom_text_from_field.dart';
import 'package:mule/router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'signup.dart';


class Login extends StatelessWidget {
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
          color: Color(0xFF6CD1E7),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SignUp()));
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Sign Up",
                style: TextStyle(
                  color: Color(0xFF6CD1E7),
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
                  "Log In",
                  style:
                    TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D3D3D)
                    ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              _loginForm(context),
              SizedBox(
                height: 30.0,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "Or connect using social account",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 45.0,
                      child: FlatButton(
                        onPressed: () {},
                        color: Color(0xff3B5998),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.facebookSquare,
                              color: Colors.white,
                            ),
                            Expanded(
                              child: Text(
                                "Connect with Facebook",
                                textAlign: TextAlign.center,
                                style: _theme.textTheme.body1.merge(
                                  TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: _theme.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(3.0)),
                      margin: EdgeInsets.only(
                        top: 10.0,
                      ),
                      height: 45.0,
                      child: FlatButton(
                        onPressed: () {},
                        color: _theme.scaffoldBackgroundColor,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.phone,
                              color: _theme.primaryColor,
                            ),
                            Expanded(
                              child: Text(
                                "Connect with Phone number",
                                textAlign: TextAlign.center,
                                style: _theme.textTheme.body1.merge(
                                  TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _theme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomTextFormField(
          hintText: "Email",
        ),
        SizedBox(
          height: 20.0,
        ),
        CustomTextFormField(
          hintText: "Password",
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          "Forgot password?",
          style: TextStyle(
              color: Color(0xFF6CD1E7),
              fontSize: 16.0,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 25.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 45.0,
          child: FlatButton(
            color: Color(0xFF6CD1E7),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(LoginRoute);
            },
            child: Text(
              "LOG IN",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        )
      ],
    );
  }
}
