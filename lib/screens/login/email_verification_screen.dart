import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/models/res/errorRes/error_res.dart';
import 'package:mule/screens/welcome_screen.dart';
import 'package:mule/widgets/alert_widget.dart';
import 'package:mule/widgets/custom_text_form_field.dart';
import 'package:mule/widgets/number_code_form.dart';

class EmailVerification extends StatelessWidget {
  final TextEditingController codeController = TextEditingController();
  NumberCodeForm numberCodeForm;

  EmailVerification() {
    this.numberCodeForm = NumberCodeForm(
      spacing: 10,
      numberOfFields: 5,
      controller: codeController,
      padding: EdgeInsets.all(50),
    );
  }

  Future<dynamic> _checkVerificationCode(BuildContext context) async {
    numberCodeForm.submitForm();
    print(codeController.text);

    final Response res =
        await httpClient.handleEmailVerificationCode(codeController.text);

    if (res.statusCode == 200) {
      // TODO show a little reminder that it successded
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      // TODO Response data field seems to be of the incorrect type
      ErrorRes _ = ErrorRes.fromJson(res.data);
      createDialogWidget(context, 'Failed!', 'Please try again');
    }
  }

  Future<dynamic> _resendVerificationCode() async {
    final Response res = await httpClient.handleEmailVerificationResend();

    if (res.statusCode != 200) {
      // TODO Response data field seems to be of the incorrect type
      ErrorRes _ = ErrorRes.fromJson(res.data);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Verify Email",
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkGrey),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    "Please enter verification code we've sent you",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17.0,
                        color: AppTheme.darkGrey),
                  ),
                  numberCodeForm,
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
                        onTap: () async => await _resendVerificationCode(),
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
                        onPressed: () async =>
                            await _checkVerificationCode(context),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
