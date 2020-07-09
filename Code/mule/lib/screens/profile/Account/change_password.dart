import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/mixins/input_validation.dart';
import 'package:mule/models/req/changePassword/change_password_req.dart';
import 'package:mule/models/res/errorRes/error_res.dart';
import 'package:mule/screens/profile/profile.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:mule/widgets/alert_widget.dart';
import 'package:mule/widgets/custom_text_form_field.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> with InputValidation {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPassword1Controller = TextEditingController();
  final TextEditingController _newPassword2Controller = TextEditingController();

  _clearNewPasswordFields() {
    _newPassword1Controller.clear();
    _newPassword2Controller.clear();
  }

  _clearOldPasswordField() {
    _oldPasswordController.clear();
  }

  _handleSubmitChangePassword() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    final String newPass1 = _newPassword1Controller.text.trim();
    final String newPass2 = _newPassword2Controller.text.trim();

    if (newPass1 != newPass2) {
      createDialogWidget(context, 'Cannot submit!',
          'New password does not match with confirm password');
      _clearNewPasswordFields();
      return;
    }
    final String oldPass = _oldPasswordController.text.trim();
    final ChangePasswordReq changePasswordReq =
        ChangePasswordReq(oldPassword: oldPass, newPassword: newPass1);

    final Response res =
        await httpClient.handleChangePassword(changePasswordReq);
    if (res.statusCode == 200) {
      Navigator.of(context).pop();
    } else {
      ErrorRes errRes = ErrorRes.fromJson(res.data);
      createDialogWidget(context, 'Failed!', errRes.errors.join('\n'));
      _clearOldPasswordField();
      _clearNewPasswordFields();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: AppTheme.elementSize(
                screenHeight, 25, 28, 30, 33, 25, 26, 27, 29),
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
              child: ListView(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          //padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "Change Password",
                            style: TextStyle(
                                fontSize: AppTheme.elementSize(screenHeight, 30,
                                    32, 34, 36, 38, 40, 42, 48),
                                fontWeight: FontWeight.w700,
                                color: AppTheme.darkGrey),
                          ),
                        ),
                        SizedBox(
                          height: AppTheme.elementSize(
                              screenHeight, 30, 31, 32, 33, 35, 36, 37, 44),
                        ),
                        CustomTextFormField(
                          controller: _oldPasswordController,
                          hintText: "Current Password",
                          obscureText: true,
                          validator: validateNewPassword,
                          //controller: passwordController,
                        ),
                        SizedBox(
                          height: AppTheme.elementSize(
                              screenHeight, 20, 22, 24, 26, 28, 30, 32, 34),
                        ),
                        CustomTextFormField(
                          controller: _newPassword1Controller,
                          hintText: "New Password",
                          obscureText: true,
                          validator: validateNewPassword,
                        ),
                        SizedBox(
                          height: AppTheme.elementSize(
                              screenHeight, 20, 22, 24, 26, 28, 30, 32, 34),
                        ),
                        CustomTextFormField(
                          controller: _newPassword2Controller,
                          validator: validateNewPassword,
                          hintText: "Confirm New Password",
                          obscureText: true,
                          //controller: passwordController,
                        ),
                        SizedBox(
                          height: AppTheme.elementSize(
                              screenHeight, 30, 32, 34, 36, 38, 40, 42, 48),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: AppTheme.elementSize(
                              screenHeight, 45, 46, 47, 50, 55, 62, 70, 76),
                          child: FlatButton(
                            color: AppTheme.lightBlue,
                            child: Text(
                              "SUBMIT",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppTheme.elementSize(screenHeight, 16,
                                    18, 20, 22, 24, 26, 28, 30),
                              ),
                            ),
                            onPressed: this._handleSubmitChangePassword,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
