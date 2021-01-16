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
    final status = res.statusCode;
    // range 0 - 399
    if (status < 400) {
      // Update data in the store!
      final ProfileRes resData = ProfileRes.fromJson(res.data);
      GetIt.I.get<UserInfoStore>().updateEverythingFromrRes(resData);
      // user is logged in successfully
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
      // range 400 - 499
    } else if (status < 500) {
      final errorMessages = res.data['errors'].join('\n');
      createDialogWidget(context, 'Cannot log in!', errorMessages);
      emailController.clear();
      passwordController.clear();
    } else {
      createDialogWidget(context, 'Cannot log in!',
          'This is a fault on our end... Please try again later');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.white,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: AppTheme.elementSize(
                screenHeight, 25, 25, 25, 25, 27, 33, 38, 45),
            color: AppTheme.lightBlue,
          ),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          color: AppTheme.black,
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
                  fontSize: AppTheme.elementSize(
                      screenHeight, 16, 17, 18, 20, 22, 24, 30, 38),
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
                      fontSize: AppTheme.elementSize(
                          screenHeight, 24, 26, 28, 30, 32, 40, 45, 50),
                      fontWeight: FontWeight.w700,
                      color: AppTheme.darkGrey),
                ),
              ),
              SizedBox(
                height: AppTheme.elementSize(
                    screenHeight, 22, 24, 26, 28, 30, 40, 45, 50),
              ),
              _loginForm(context, screenHeight),
              SizedBox(
                height: AppTheme.elementSize(
                    screenHeight, 22, 24, 26, 28, 30, 36, 42, 44),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "Or connect using social account",
                      style: TextStyle(
                        fontSize: AppTheme.elementSize(
                            screenHeight, 14, 15, 16, 17, 18, 20, 24, 28),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: AppTheme.elementSize(
                          screenHeight, 10, 12, 14, 16, 18, 20, 22, 24),
                    ),
                    Container(
                      height: AppTheme.elementSize(
                          screenHeight, 36, 38, 40, 42, 45, 56, 62, 70),
                      child: FlatButton(
                        onPressed: () {
                          createDialogWidget(
                              context,
                              'We are still working on this :( ',
                              'We\'re sorry, this feature is not yet available but will be rolled out soon');
                        },
                        color: AppTheme.facebookBlue,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.facebookSquare,
                              size: AppTheme.elementSize(
                                  screenHeight, 25, 25, 26, 27, 28, 31, 35, 38),
                              color: Colors.white,
                            ),
                            Expanded(
                              child: Text(
                                "Connect with Facebook",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: AppTheme.elementSize(screenHeight,
                                      14, 15, 16, 16, 17, 23, 28, 30),
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
                      height: AppTheme.elementSize(
                          screenHeight, 36, 38, 40, 42, 45, 56, 62, 70),
                      child: FlatButton(
                        onPressed: () {
                          createDialogWidget(
                              context,
                              'We are still working on this :( ',
                              'We\'re sorry, this feature is not yet available but will be rolled out soon');
                        },
                        color: AppTheme.white,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.google,
                              size: AppTheme.elementSize(
                                  screenHeight, 25, 25, 26, 27, 28, 31, 35, 38),
                              color: Colors.redAccent,
                            ),
                            Expanded(
                              child: Text(
                                "Sign in with Google",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppTheme.elementSize(screenHeight,
                                      14, 15, 16, 16, 17, 23, 28, 30),
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

  Widget _loginForm(BuildContext context, double screenHeight) {
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
            height: AppTheme.elementSize(
                screenHeight, 20, 20, 20, 22, 22, 30, 32, 34),
          ),
          CustomTextFormField(
            hintText: "Password",
            obscureText: true,
            validator: validateNotEmptyInput,
            controller: passwordController,
          ),
          SizedBox(
            height: AppTheme.elementSize(
                screenHeight, 20, 20, 20, 22, 22, 30, 32, 34),
          ),
          GestureDetector(
            child: Text(
              "Forgot password?",
              style: TextStyle(
                  color: AppTheme.darkGrey,
                  fontSize: AppTheme.elementSize(
                      screenHeight, 14, 15, 16, 17, 18, 22, 26, 29),
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ForgotPassword()));
            },
          ),
          SizedBox(
            height: AppTheme.elementSize(
                screenHeight, 30, 30, 30, 30, 30, 40, 42, 44),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: AppTheme.elementSize(
                screenHeight, 36, 38, 40, 42, 45, 56, 62, 70),
            child: FlatButton(
              color: AppTheme.lightBlue,
              onPressed: this.handleSubmt,
              child: Text(
                "LOG IN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppTheme.elementSize(
                      screenHeight, 14, 15, 16, 17, 18, 26, 28, 30),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
