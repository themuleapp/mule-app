import 'package:flutter/material.dart';
import 'package:mule/Screens/menu.dart';
import 'package:mule/Widgets/custom_text_form_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mule/config/app_colors.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/models/login/login_data.dart';

import 'signup.dart';

class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                  .push(MaterialPageRoute(builder: (context) => SignUp()));
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Sign Up",
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
                  "Log In",
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey),
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
                        color: AppColors.blue,
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
                            color: Colors.redAccent,
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
                              FontAwesomeIcons.google,
                              color: Colors.redAccent,
                            ),
                            Expanded(
                              child: Text(
                                "Sign in with Google",
                                textAlign: TextAlign.center,
                                style: _theme.textTheme.body1.merge(
                                  TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
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
          controller: emailController,
        ),
        SizedBox(
          height: 20.0,
        ),
        CustomTextFormField(
          hintText: "Password",
          obscureText: true,
          controller: passwordController,
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          "Forgot password?",
          style: TextStyle(
              color: AppColors.darkGrey,
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
            color: AppColors.lightBlue,
            onPressed: () async {
              final loginData = LoginData(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
              final res = await httpClient.handleLogin(loginData);
              final success = res.statusCode;
              if (success == 200) {
                // user is logged in successfully
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MainWidget()));
              } else {
                print('Nope you not authenticated yet!');
                print(res.data);
              }
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
