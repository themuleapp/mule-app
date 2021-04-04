import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/services/mule_api_service.dart';
import 'package:mule/mixins/input_validation.dart';
import 'package:mule/models/req/changePassword/change_password_req.dart';
import 'package:mule/models/res/errorRes/error_res.dart';
import 'package:mule/widgets/alert_widget.dart';
import 'package:mule/widgets/button.dart';
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
        await muleApiService.handleChangePassword(changePasswordReq);
    if (res.statusCode == 200) {
      Navigator.of(context).pop();
      createDialogWidget(context, 'Success!', 'Your password has been changed');
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
                screenHeight, 25, 25, 25, 25, 27, 33, 38, 45),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Change Password",
                                style: TextStyle(
                                    fontSize: AppTheme.elementSize(screenHeight,
                                        24, 26, 28, 30, 32, 40, 45, 50),
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.darkGrey),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: AppTheme.elementSize(
                              screenHeight, 20, 20, 22, 22, 24, 33, 36, 40),
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
                              screenHeight, 30, 30, 32, 32, 35, 43, 46, 50),
                        ),
                        CustomTextFormField(
                          controller: _newPassword1Controller,
                          hintText: "New Password",
                          obscureText: true,
                          validator: validateNewPassword,
                        ),
                        SizedBox(
                          height: AppTheme.elementSize(
                              screenHeight, 14, 15, 16, 17, 18, 20, 24, 28),
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
                              screenHeight, 30, 30, 32, 32, 34, 40, 42, 48),
                        ),
                        button("Submit", _handleSubmitChangePassword,
                            screenHeight, context)
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
