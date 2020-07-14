import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/mixins/input_validation.dart';
import 'package:mule/models/req/forgotPassword/forgot_password_req.dart';
import 'package:mule/models/res/errorRes/error_res.dart';
import 'package:mule/screens/login/ForgotPassword/email_otp.dart';
import 'package:mule/screens/login/login_screen.dart';
import 'package:mule/widgets/alert_widget.dart';
import 'package:mule/widgets/custom_text_form_field.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> with InputValidation {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  _handleForgotPassword() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    final String email = _emailController.text.trim();
    final ForgotPasswordReq forgotPassword = ForgotPasswordReq(email: email);
    Response res = await httpClient.handleRequestOtp(forgotPassword);
    if (res.statusCode == 200) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OtpVerification(email: email)));
    } else {
      ErrorRes errRes = ErrorRes.fromJson(res.data);
      createDialogWidget(context, 'Failed!', errRes.errors.join('\n'));
      _emailController.clear();
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
                screenHeight, 25, 25, 26, 26, 30, 35, 40, 45),
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
                      screenHeight, 18, 20, 20, 21, 25, 30, 34, 40),
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
                  "Forgot Password",
                  style: TextStyle(
                      fontSize: AppTheme.elementSize(
                          screenHeight, 30, 30, 30, 31, 34, 42, 45, 50),
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGrey),
                ),
              ),
              SizedBox(
                height: AppTheme.elementSize(
                    screenHeight, 30, 32, 32, 34, 38, 43, 46, 50),
              ),
              _forgotPasswordForm(context, screenHeight),
              SizedBox(
                height: AppTheme.elementSize(
                    screenHeight, 30, 32, 32, 34, 38, 43, 46, 50),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _forgotPasswordForm(BuildContext context, double screenHeight) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Enter your email to receive a code",
            style: TextStyle(
                fontSize: AppTheme.elementSize(
                    screenHeight, 17, 18, 18, 19, 21, 26, 30, 35),
                fontWeight: FontWeight.w500,
                color: AppTheme.darkGrey),
          ),
          SizedBox(
            height: AppTheme.elementSize(
                screenHeight, 20, 22, 22, 24, 29, 33, 36, 40),
          ),
          CustomTextFormField(
            keyboardType: TextInputType.emailAddress,
            validator: validateEmail,
            controller: _emailController,
            hintText: "Email",
          ),
          SizedBox(
            height: AppTheme.elementSize(
                screenHeight, 30, 32, 32, 34, 36, 40, 42, 44),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: AppTheme.elementSize(
                screenHeight, 45, 45, 45, 45, 47, 56, 63, 70),
            child: FlatButton(
              color: AppTheme.lightBlue,
              child: Text(
                "SUBMIT",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppTheme.elementSize(
                      screenHeight, 16, 18, 18, 19, 19, 26, 28, 30),
                ),
              ),
              onPressed: this._handleForgotPassword,
            ),
          )
        ],
      ),
    );
  }
}
