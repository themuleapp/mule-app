import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/mixins/input_validation.dart';
import 'package:mule/models/req/verifyPassword/verify_password.dart';
import 'package:mule/models/res/errorRes/error_res.dart';
import 'package:mule/screens/login/login_screen.dart';
import 'package:mule/widgets/alert_widget.dart';
import 'package:mule/widgets/custom_text_form_field.dart';

class ResetPassword extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPassword({Key key, @required this.email, @required this.otp})
      : super(key: key);
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> with InputValidation {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstPassController = TextEditingController();
  final TextEditingController _secondPassController = TextEditingController();

  _clearPasswords() {
    _firstPassController.clear();
    _secondPassController.clear();
  }

  _handleSubmit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    final password1 = _firstPassController.text.trim();
    final password2 = _secondPassController.text.trim();
    if (password1 != password2) {
      createDialogWidget(
          context, 'Cannot change password!', 'Passwords do not match!');
      _clearPasswords();
      return;
    }

    VerifyPasswordReq verifyPasswordReq = VerifyPasswordReq(
      email: widget.email,
      resetToken: widget.otp,
      password: password1,
    );
    final Response res =
        await httpClient.handleResetPassword(verifyPasswordReq);
    if (res.statusCode == 200) {
      // TODO show a little reminder that it successded
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } else {
      ErrorRes errRes = ErrorRes.fromJson(res.data);
      createDialogWidget(context, 'Failed!', errRes.errors.join('\n'));
      _clearPasswords();
    }
  }

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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        "Reset Password",
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkGrey),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Enter a new password",
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.darkGrey),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    CustomTextFormField(
                      controller: _firstPassController,
                      hintText: "Password",
                      obscureText: true,
                      validator: validateNewPassword,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    CustomTextFormField(
                      controller: _secondPassController,
                      hintText: "Confirm Password",
                      obscureText: true,
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
                        onPressed: this._handleSubmit,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
