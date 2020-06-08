import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mule/Screens/Login/login_screen.dart';
import 'package:mule/Screens/Login/ForgotPassword/otp_verification.dart';
import 'package:mule/Widgets/alert_widget.dart';
import 'package:mule/Widgets/custom_text_form_field.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/mixins/input_validation.dart';
import 'package:mule/models/req/forgotPassword/forgot_password_req.dart';
import 'package:mule/models/res/errorRes/error_res.dart';

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
    Response res = await httpClient.handleForgotPassword(forgotPassword);
    if (res.statusCode == 200) {
      print(res.data);
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
                  "Forgot Password",
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGrey),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              _forgotPasswordForm(context),
              SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _forgotPasswordForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Don't worry, enter your email to receive an OTP!",
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkGrey),
          ),
          SizedBox(
            height: 20.0,
          ),
          CustomTextFormField(
            keyboardType: TextInputType.emailAddress,
            validator: validateEmail,
            controller: _emailController,
            hintText: "Email",
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
              onPressed: this._handleForgotPassword,
            ),
          )
        ],
      ),
    );
  }
}
