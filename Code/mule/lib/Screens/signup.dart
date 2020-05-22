import 'package:flutter/material.dart';
import 'package:mule/Screens/menu.dart';
import 'package:mule/Widgets/custom_text_from_field.dart';

import 'login.dart';

class SignUp extends StatelessWidget {
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
          color: Color(0xFF6CD1E7),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Login()));
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Log In",
                style: TextStyle(
                  color: Color(0xFF6CD1E7),
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
                      color: Color(0xFF3D3D3D)
                  ),
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
                  color: Color(0xFF6CD1E7),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MainWidget()));
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
              ),
            ),
            SizedBox(width: 15.0),
            Expanded(
              child: CustomTextFormField(
                hintText: "Last name",
              ),
            )
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        CustomTextFormField(
          hintText: "Email",
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
              ),
            ),
            SizedBox(width: 15.0),
            Expanded(
              child: CustomTextFormField(
                hintText: "Phone number",
              ),
            )
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        CustomTextFormField(
          hintText: "Password",
        ),
        SizedBox(
          height: 25.0,
        ),
        Text(
          "By clicking \"Sign Up\" you agree to our terms and conditions as well as our privacy policy",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3D3D3D)),
        )
      ],
    );
  }
}
