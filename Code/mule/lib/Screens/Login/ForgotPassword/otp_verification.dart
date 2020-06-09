import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mule/Screens/Login/ForgotPassword/reset_password.dart';
import 'package:mule/Widgets/alert_widget.dart';
import 'package:mule/Widgets/custom_text_form_field.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/mixins/input_validation.dart';
import 'package:mule/models/req/verifyTokenAndEmail/verify_token_and_email_req.dart';
import 'package:mule/models/res/errorRes/error_res.dart';

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

  _handleVerify() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final String otp = _otpController.text;
    final Response res = await httpClient.handleVerifyTokenAndEmail(
        VerifyTokenAndEmailReq(email: widget.email, token: otp));
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
      print('Error!');
      print(res.data);
      ErrorRes errRes = ErrorRes.fromJson(res.data);
      createDialogWidget(context, 'Failed!', errRes.errors.join('\n'));
      _otpController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
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
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      "Verify Email",
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
                    "Check your email, we've sent you an OTP",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
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
                  Wrap(
                    children: <Widget>[
                      Text(
                        "Didn't receive a code?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      GestureDetector(
                        child: Text(
                          "Resend Code",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.lightBlue,
                          ),
                        ),
                        onTap: () {},
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
          ],
        ),
      ),
    );
  }
}
