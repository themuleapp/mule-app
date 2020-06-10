import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/mixins/input_validation.dart';
import 'package:mule/models/req/login/login_data.dart';
import 'package:mule/models/res/profileRes/profile_res.dart';
import 'package:mule/navigation_home_screen.dart';
import 'package:mule/screens/login/ForgotPassword/forgot_password_email.dart';
import 'package:mule/screens/signup/signup_screen.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:mule/widgets/alert_widget.dart';
import 'package:mule/widgets/custom_text_form_field.dart';

import '../../stores/global/user_info_store.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with InputValidation {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void handleSubmt() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    final loginData = LoginData(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    final res = await httpClient.handleLogin(loginData);
    final success = res.statusCode;
    if (success == 200) {
      // Update data in the store!
      final ProfileRes resData = ProfileRes.fromJson(res.data);
      GetIt.I.get<UserInfoStore>().updateEverythingFromrRes(resData);
      // user is logged in successfully
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
    } else {
      final errorMessages = res.data['errors'].join('\n');
      createDialogWidget(context, 'Cannot log in!', errorMessages);
      emailController.clear();
      passwordController.clear();
    }
  }

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
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SignupScreen()));
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Sign Up",
                style: TextStyle(
                  color: AppTheme.lightBlue,
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
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  "Log In",
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.darkGrey),
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
                        color: AppTheme.facebookBlue,
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
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
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
                        color: AppTheme.white,
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomTextFormField(
            hintText: "Email",
            controller: emailController,
            validator: validateEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(
            height: 20.0,
          ),
          CustomTextFormField(
            hintText: "Password",
            obscureText: true,
            validator: validateNotEmptyInput,
            controller: passwordController,
          ),
          SizedBox(
            height: 15.0,
          ),
          GestureDetector(
            child: Text(
              "Forgot password?",
              style: TextStyle(
                  color: AppTheme.darkGrey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ForgotPassword()));
            },
          ),
          SizedBox(
            height: 30.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 45.0,
            child: FlatButton(
              color: AppTheme.lightBlue,
              onPressed: this.handleSubmt,
              child: Text(
                "LOG IN",
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
