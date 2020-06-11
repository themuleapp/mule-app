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
    final String email = GetIt.I.get<UserInfoStore>().email;
    final ChangePasswordReq changePasswordReq = ChangePasswordReq(
        email: email, oldPassword: oldPass, newPassword: newPass1);

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
    return Scaffold(
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      //padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Change Password",
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.darkGrey
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    CustomTextFormField(
                      controller: _oldPasswordController,
                      hintText: "Current Password",
                      obscureText: true,
                      validator: validateNewPassword,
                      //controller: passwordController,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    CustomTextFormField(
                      controller: _newPassword1Controller,
                      hintText: "New Password",
                      obscureText: true,
                      validator: validateNewPassword,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    CustomTextFormField(
                      controller: _newPassword2Controller,
                      validator: validateNewPassword,
                      hintText: "Confirm New Password",
                      obscureText: true,
                      //controller: passwordController,
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
                        onPressed: this._handleSubmitChangePassword,
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
