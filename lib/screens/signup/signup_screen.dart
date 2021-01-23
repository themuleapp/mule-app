import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/mixins/input_validation.dart';
import 'package:mule/models/req/signup/signup_data.dart';
import 'package:mule/models/res/profileRes/profile_res.dart';
import 'package:mule/screens/login/login_screen.dart';
import 'package:mule/screens/signup/phone_otp.dart';
import 'package:mule/widgets/alert_widget.dart';
import 'package:mule/widgets/custom_text_form_field.dart';

import '../../navigation_home_screen.dart';
import '../../stores/global/user_info_store.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with InputValidation {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController phoneNumberPrefixController =
      new TextEditingController();
  final TextEditingController phoneNumberController =
      new TextEditingController();
  final TextEditingController password1Controller = new TextEditingController();
  final TextEditingController password2Controller = new TextEditingController();

  void _clearPasswords() {
    password1Controller.clear();
    password2Controller.clear();
  }

  void _clearEmail() {
    emailController.clear();
  }

  void _clearPhone() {
    phoneNumberController.clear();
  }

  void _handleSubmit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final password1 = password1Controller.text.trim();
    final password2 = password2Controller.text.trim();

    if (password1 != password2) {
      createDialogWidget(context, 'Cannot sign up!', 'Passwords do not match!');
      _clearPasswords();
      return;
    }

    final phoneNumber =
        '${phoneNumberPrefixController.text.trim()}${phoneNumberController.text.trim()}';
    SignupData signupData = SignupData(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      phoneNumber: phoneNumber,
      password: password1,
    );

    final Response res = await httpClient.handleSignup(signupData);
    final success = res.statusCode;
    if (success == 201) {
      final ProfileRes authRes = ProfileRes.fromJson(res.data);
      GetIt.I.get<UserInfoStore>().updateEverythingFromrRes(authRes);
      // user is signed up successfully
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => PhoneOTP()));
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
    } else {
      final errorMessages = res.data['errors'].join('\n');
      createDialogWidget(context, 'Cannot sign up', errorMessages);
      if (errorMessages.contains('phone')) {
        _clearPhone();
      } else if (errorMessages.contains('email')) {
        _clearEmail();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //final ThemeData _theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: AppTheme.elementSize(
                screenHeight, 25, 25, 25, 25, 27, 33, 38, 45),
          ),
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
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Log In",
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
                  "Sign Up",
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
              _signupForm(screenHeight),
              SizedBox(
                height: AppTheme.elementSize(
                    screenHeight, 22, 24, 26, 28, 30, 40, 45, 50),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 30.0),
                height: AppTheme.elementSize(
                    screenHeight, 36, 38, 40, 42, 45, 56, 62, 70),
                child: FlatButton(
                  color: AppTheme.lightBlue,
                  onPressed: this._handleSubmit,
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w500,
                      fontSize: AppTheme.elementSize(
                          screenHeight, 14, 15, 16, 17, 18, 26, 28, 30),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _signupForm(double screenHeight) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: CustomTextFormField(
                  hintText: "First name",
                  controller: firstNameController,
                  textCapitalization: TextCapitalization.sentences,
                  validator: validateNotEmptyInput,
                  keyboardType: TextInputType.name,
                ),
              ),
              SizedBox(width: 15.0),
              Expanded(
                child: CustomTextFormField(
                  hintText: "Last name",
                  controller: lastNameController,
                  textCapitalization: TextCapitalization.sentences,
                  validator: validateNotEmptyInput,
                  keyboardType: TextInputType.name,
                ),
              )
            ],
          ),
          SizedBox(
            height: AppTheme.elementSize(
                screenHeight, 20, 20, 20, 22, 22, 30, 32, 34),
          ),
          CustomTextFormField(
            hintText: "Email",
            controller: emailController,
            validator: validateNotEmptyInput,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(
            height: AppTheme.elementSize(
                screenHeight, 20, 20, 20, 22, 22, 30, 32, 34),
          ),
          Row(
            children: <Widget>[
              Container(
                width: 80.0,
                child: CustomTextFormField(
                  hintText: "+1",
                  controller: phoneNumberPrefixController,
                  validator: validateNotEmptyInput,
                  keyboardType: TextInputType.phone,
                ),
              ),
              SizedBox(width: 15.0),
              Expanded(
                child: CustomTextFormField(
                  hintText: "Phone number",
                  controller: phoneNumberController,
                  validator: validateNotEmptyInput,
                  keyboardType: TextInputType.phone,
                ),
              )
            ],
          ),
          SizedBox(
            height: AppTheme.elementSize(
                screenHeight, 20, 20, 20, 22, 22, 30, 32, 34),
          ),
          CustomTextFormField(
            hintText: "Password",
            obscureText: true,
            controller: password1Controller,
            validator: validateNewPassword,
          ),
          SizedBox(
            height: AppTheme.elementSize(
                screenHeight, 20, 20, 20, 22, 22, 30, 32, 34),
          ),
          CustomTextFormField(
            hintText: "Confirm Password",
            obscureText: true,
            controller: password2Controller,
            validator: validateNewPassword,
          ),
          SizedBox(
            height: AppTheme.elementSize(
                screenHeight, 25, 25, 25, 26, 26, 35, 40, 43),
          ),
          Text(
            "By clicking \"Sign Up\" you agree to our terms and conditions as well as our privacy policy",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGrey,
              fontSize: AppTheme.elementSize(
                  screenHeight, 14, 14, 14, 15, 16, 20, 24, 28),
            ),
          )
        ],
      ),
    );
  }
}
