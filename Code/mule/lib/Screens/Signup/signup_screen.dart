import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mule/Screens/Login/login_screen.dart';
import 'package:mule/Widgets/alert_widget.dart';
import 'package:mule/Widgets/custom_text_form_field.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/config/input_validation.dart';
import 'package:mule/models/signup/signup_data.dart';
import 'package:mule/navigation_home_screen.dart';

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

  // void _clearForm() {
  //   firstNameController.clear();
  //   lastNameController.clear();
  //   emailController.clear();
  //   phoneNumberPrefixController.clear();
  //   phoneNumberController.clear();
  //   password1Controller.clear();
  //   password2Controller.clear();
  // }

  void _clearPasswords() {
    password1Controller.clear();
    password2Controller.clear();
  }

  void _clearEmail() {
    emailController.clear();
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
      // user is signed up successfully
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
    } else {
      final errorMessages = res.data['errors'].join('\n');
      createDialogWidget(context, 'Cannot sign up', errorMessages);
      _clearEmail();
    }
  }

  @override
  Widget build(BuildContext context) {
    //final ThemeData _theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppTheme.white,
      resizeToAvoidBottomPadding: false,
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
                  "Sign Up",
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.darkGrey
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              _signupForm(),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Center(
                  child: Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.lightBlue,
                      borderRadius:
                      const BorderRadius.all(Radius.circular(8)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            offset: const Offset(4, 4),
                            blurRadius: 8.0),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
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

  Widget _signupForm() {
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
                  validator: validateNotEmptyInput,
                ),
              ),
              SizedBox(width: 15.0),
              Expanded(
                child: CustomTextFormField(
                  hintText: "Last name",
                  controller: lastNameController,
                  validator: validateNotEmptyInput,
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          CustomTextFormField(
            hintText: "Email",
            controller: emailController,
            validator: validateNotEmptyInput,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: <Widget>[
              Container(
                width: 80.0,
                child: CustomTextFormField(
                  hintText: "+1",
                  controller: phoneNumberPrefixController,
                  validator: validateNotEmptyInput,
                ),
              ),
              SizedBox(width: 15.0),
              Expanded(
                child: CustomTextFormField(
                  hintText: "Phone number",
                  controller: phoneNumberController,
                  validator: validateNotEmptyInput,
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          CustomTextFormField(
            hintText: "Password",
            obscureText: true,
            controller: password1Controller,
            validator: validateNewPassword,
          ),
          SizedBox(
            height: 20.0,
          ),
          CustomTextFormField(
            hintText: "Confirm Password",
            obscureText: true,
            controller: password2Controller,
            validator: validateNewPassword,
          ),
          SizedBox(
            height: 25.0,
          ),
          Text(
            "By clicking \"Sign Up\" you agree to our terms and conditions as well as our privacy policy",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: AppTheme.darkGrey),
          )
        ],
      ),
    );
  }
}
