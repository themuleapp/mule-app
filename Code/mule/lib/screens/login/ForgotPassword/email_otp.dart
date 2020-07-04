import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/mixins/input_validation.dart';
import 'package:mule/models/req/forgotPassword/forgot_password_req.dart';
import 'package:mule/models/req/verifyTokenAndEmail/verify_token_and_email_req.dart';
import 'package:mule/models/res/errorRes/error_res.dart';
import 'package:mule/screens/login/ForgotPassword/reset_password.dart';
import 'package:mule/widgets/alert_widget.dart';
import 'package:mule/widgets/custom_text_form_field.dart';

class OtpVerification extends StatefulWidget {
  final String email;

  const OtpVerification({Key key, this.email}) : super(key: key);

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification>
    with InputValidation {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  _handleResendResetCode() async {
    await httpClient.handleReRequestOtp(ForgotPasswordReq(email: widget.email));
    createDialogWidget(
        context, 'Another reset token has been sent your way!', '');
  }

  _handleVerify() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final String otp = _otpController.text;
    final Response res = await httpClient.handleVerifyTokenAndEmail(
        VerifyTokenAndEmailReq(email: widget.email, resetToken: otp));
    if (res.statusCode == 200) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResetPassword(
            email: widget.email,
            otp: otp,
          ),
        ),
      );
    } else {
      ErrorRes errRes = ErrorRes.fromJson(res.data);
      createDialogWidget(context, 'Failed!', errRes.errors.join('\n'));
      _otpController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          color: AppTheme.black,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Verify Email",
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkGrey),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      "Please enter the code we have emailed you",
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.darkGrey),
                    ),
                    Form(
                      key: _formKey,
                      child: CustomTextFormField(
                        keyboardType: TextInputType.number,
                        validator: validateNotEmptyInput,
                        controller: _otpController,
                        hintText: "",
                        verticalPadding: 25.0,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Didn't receive a code?",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        GestureDetector(
                          child: Text(
                            "Resend Code",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: AppTheme.lightBlue,
                            ),
                          ),
                          onTap: this._handleResendResetCode,
                        ),
                      ],
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
                          "VERIFY",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                        onPressed: this._handleVerify,
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
