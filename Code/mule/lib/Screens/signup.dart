import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:mule/Screens/menu.dart';
import 'package:mule/Widgets/custom_text_form_field.dart';
import 'package:mule/config/app_colors.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/models/signup/signup_data.dart';

import 'login.dart';

class SignUp extends StatelessWidget {
  final TextEditingController firstNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController phoneNumberPrefixController =
      new TextEditingController();
  final TextEditingController phoneNumberController =
      new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //final ThemeData _theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      resizeToAvoidBottomPadding: false,
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
          color: AppColors.lightBlue,
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Login()));
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Log In",
                style: TextStyle(
                  color: AppColors.lightBlue,
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
          //color: Color(0xFFFFFFFF),
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              _signupForm(),
              SizedBox(
                height: 30.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 30.0),
                height: 45.0,
                child: FlatButton(
                  color: AppColors.lightBlue,
                  onPressed: () async {
                    final phoneNumber =
                        '${phoneNumberPrefixController.text.trim()}${phoneNumberController.text.trim()}';
                    SignupData signupData = SignupData(
                      firstName: firstNameController.text.trim(),
                      lastName: lastNameController.text.trim(),
                      email: emailController.text.trim(),
                      phoneNumber: phoneNumber,
                      password: passwordController.text.trim(),
                    );

                    final res = await httpClient.handleSignup(signupData);
                    final success = res.statusCode;
                    if (success == 201) {
                      // user is signed up successfully
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MainWidget()));
                    } else {
                      print('Nope you not authenticated yet!');
                      print(res.data);
                    }
                  },
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _signupForm() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: CustomTextFormField(
                hintText: "First name",
                controller: firstNameController,
                validator: (String value) => value.isEmpty
                    ? "Please enter a first name"
                    : null,
              ),
            ),
            SizedBox(width: 15.0),
            Expanded(
              child: CustomTextFormField(
                hintText: "Last name",
                controller: lastNameController,
                validator: (String value) => value.isEmpty
                    ? "Please enter a last name"
                    : null,
              ),
            )
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        CustomTextFormField(
          hintText: "Email",
          controller: emailController,
          validator: (value) => !EmailValidator.validate(value, true)
              ? "Not a valid email"
              : null,
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          children: <Widget>[
            Container(
              width: 80.0,
              child: CustomTextFormField(
                hintText: "+1",
                controller: phoneNumberPrefixController,
                validator: (String value) => value.isEmpty
                    ? "Please enter a country code"
                    : null,
              ),
            ),
            SizedBox(width: 15.0),
            Expanded(
              child: CustomTextFormField(
                hintText: "Phone number",
                controller: phoneNumberController,
                validator: (String value) => value.isEmpty
                    ? "Please enter a phone number"
                    : null,
              ),
            )
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        CustomTextFormField(
          hintText: "Password",
          obscureText: true,
          controller: passwordController,
          validator: (val) => val.length < 4
              ? "Password too short"
              : null,
        ),
        SizedBox(
          height: 20.0,
        ),
        CustomTextFormField(
          hintText: "Confirm Password",
          obscureText: true,
          controller: passwordController,
        ),
        SizedBox(
          height: 25.0,
        ),
        Text(
          "By clicking \"Sign Up\" you agree to our terms and conditions as well as our privacy policy",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkGrey),
        )
      ],
    );
  }
}
