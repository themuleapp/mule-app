import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/screens/instructions/instructions.dart';
import 'package:mule/services/mule_api_service.dart';
import 'package:mule/mixins/input_validation.dart';
import 'package:mule/models/req/signup/signup_data.dart';
import 'package:mule/models/res/profileRes/profile_res.dart';
import 'package:mule/screens/login/login_screen.dart';
import 'package:mule/widgets/alert_widget.dart';
import 'package:mule/widgets/button.dart';
import 'package:mule/widgets/custom_text_form_field.dart';
import 'package:url_launcher/url_launcher.dart';
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

    final Response res = await muleApiService.handleSignup(signupData);
    final success = res.statusCode;
    if (success == 201) {
      final ProfileRes authRes = ProfileRes.fromJson(res.data);
      GetIt.I.get<UserInfoStore>().updateEverythingFromrRes(authRes);
      // user is signed up successfully
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => PhoneOTP()));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Instructions()));
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceWebView: true,
        enableJavaScript: true,
        enableDomStorage: true,
        forceSafariVC: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
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
          color: AppTheme.black,
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
                  color: AppTheme.secondaryBlue,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: AppTheme.elementSize(
                              screenHeight, 24, 26, 28, 30, 32, 40, 45, 50),
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkGrey),
                    ),
                  ],
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
              button('Sign Up', _handleSubmit, screenHeight, context)
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
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "By clicking \"Sign Up\" below you agree to our ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGrey,
                    fontSize: AppTheme.elementSize(
                        screenHeight, 14, 14, 14, 15, 16, 20, 24, 28),
                  ),
                ),
                TextSpan(
                  text: "terms of use",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightBlue,
                    fontSize: AppTheme.elementSize(
                        screenHeight, 14, 14, 14, 15, 16, 20, 24, 28),
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      _launchURL('https://www.themuleapp.com/terms-of-use');
                    },
                ),
                TextSpan(
                  text: " as well as our ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGrey,
                    fontSize: AppTheme.elementSize(
                        screenHeight, 14, 14, 14, 15, 16, 20, 24, 28),
                  ),
                ),
                TextSpan(
                  text: "privacy policy",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightBlue,
                    fontSize: AppTheme.elementSize(
                        screenHeight, 14, 14, 14, 15, 16, 20, 24, 28),
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      _launchURL('https://www.themuleapp.com/privacy');
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
