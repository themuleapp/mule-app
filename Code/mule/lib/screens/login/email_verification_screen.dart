import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/models/res/errorRes/error_res.dart';
import 'package:mule/screens/welcome_screen.dart';
import 'package:mule/widgets/alert_widget.dart';

class EmailVerification extends StatefulWidget {
  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  String code = "";

  @override
  void initState() {
    super.initState();
  }

  _checkVerificationCode() async {
    final Response res = await httpClient.handleEmailVerificationCode(code);

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

  _resendVerificationEmail() async {
    final Response res = await httpClient.handleEmailVerificationResend();

    if (res.statusCode != 200) {
      // TODO Response data field seems to be of the incorrect type
      ErrorRes _ = ErrorRes.fromJson(res.data);
      createDialogWidget(context, 'Oh, no...',
          'Sorry, something went wrong with resending the verification code. Please check your internet connection and try again!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SafeArea(
              child: Container(
                color: AppTheme.white,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top + 20,
                            left: 16,
                            right: 16
                        ),
                        // TODO Image not decompressable error
                        // child: Image.asset('assets/images/Delete.png'),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 25),
                        child: Text(
                          "Please verify your email",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildComposer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
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
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        _resendVerificationEmail();
                                      },
                                      child: Text(
                                        'Resend',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
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
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        _checkVerificationCode();
                                      },
                                      child: Text(
                                        'Verify',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildComposer() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 32, right: 32),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                offset: const Offset(4, 4),
                blurRadius: 8),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.all(4.0),
            constraints: const BoxConstraints(minHeight: 80, maxHeight: 160),
            color: AppTheme.white,
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
              child: TextField(
                maxLines: null,
                onChanged: (String code) {
                  this.code = code;
                },
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontSize: 16,
                  color: AppTheme.darkGrey,
                ),
                cursorColor: AppTheme.lightBlue,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Please enter your code here'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
