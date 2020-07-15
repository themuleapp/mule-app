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
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        elevation: 0,
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
                            fontSize: AppTheme.elementSize(
                                screenHeight, 30, 30, 30, 30, 32, 40, 45, 50),
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkGrey),
                      ),
                    ),
                    SizedBox(
                      height: AppTheme.elementSize(
                          screenHeight, 30, 30, 32, 32, 34, 43, 46, 50),
                    ),
                    Text(
                      "Please enter the code we have emailed you",
                      style: TextStyle(
                          fontSize: AppTheme.elementSize(
                              screenHeight, 17, 17, 18, 18, 20, 26, 30, 35),
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
                      height: AppTheme.elementSize(
                          screenHeight, 20, 20, 22, 22, 24, 30, 36, 40),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Didn't receive a code?",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: AppTheme.elementSize(
                                screenHeight, 15, 15, 16, 16, 18, 22, 24, 26),
                          ),
                        ),
                        SizedBox(
                          width: AppTheme.elementSize(
                              screenHeight, 10, 10, 12, 12, 13, 15, 16, 17),
                        ),
                        GestureDetector(
                          child: Text(
                            "Resend Code",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: AppTheme.elementSize(
                                  screenHeight, 15, 15, 16, 16, 17, 22, 24, 26),
                              color: AppTheme.lightBlue,
                            ),
                          ),
                          onTap: this._handleResendResetCode,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppTheme.elementSize(
                          screenHeight, 30, 30, 32, 32, 34, 43, 46, 50),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: AppTheme.elementSize(
                          screenHeight, 45, 45, 45, 45, 47, 56, 63, 70),
                      child: FlatButton(
                        color: AppTheme.lightBlue,
                        child: Text(
                          "VERIFY",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppTheme.elementSize(
                                screenHeight, 16, 18, 18, 19, 19, 26, 28, 30),
                          ),
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
