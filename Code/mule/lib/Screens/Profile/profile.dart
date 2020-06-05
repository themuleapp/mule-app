import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mule/Widgets/custom_text_form_field.dart';
import 'package:mule/config/app_theme.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: AppTheme.white,
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Hey there, Nick!",
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.darkGrey,
                      fontSize: 30,
                    ),
                  ),
                  CircleAvatar(
                    radius: 40.0,
                    backgroundImage: AssetImage(
                        'assets/images/profile_photo_nick_miller.jpg'),
                  )
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              CustomTextFormField(
                hintText: "Name",
                value: "Nick Miller",
              ),
              SizedBox(
                height: 15.0,
              ),
              CustomTextFormField(
                hintText: "Email",
                value: "nickmiller@gmail.com",
                suffixIcon: Icon(
                  Icons.check_circle,
                  color: AppTheme.lightBlue,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              CustomTextFormField(
                hintText: "Phone Number",
                value: "123-345-7890",
                suffixIcon: Icon(
                  Icons.check_circle,
                  color: AppTheme.lightBlue,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                "PREFERENCES",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.0,
                  color: AppTheme.lightGrey,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  border: Border.all(
                    color: AppTheme.lightGrey,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Be a Mule",
                            style: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.darkGrey,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Switch(
                          value: true,
                          activeColor: AppTheme.lightBlue,
                          onChanged: (bool state) {},
                        )
                      ],
                    ),
                    Text(
                      "Turn on to be considered being a Mule.",
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.darkGrey,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "SOCIAL NETWORK",
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0,
                        color: AppTheme.lightGrey,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 45.0,
                      child: FlatButton(
                        onPressed: () {},
                        color: AppTheme.facebookBlue,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.facebookSquare,
                              color: Colors.white,
                            ),
                            Expanded(
                              child: Text(
                                "Connect with Facebook",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.redAccent,
                          ),
                          borderRadius: BorderRadius.circular(3.0)),
                      margin: EdgeInsets.only(top: 10.0),
                      height: 45.0,
                      child: FlatButton(
                        onPressed: () {},
                        color: AppTheme.white,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.google,
                              size: 18.0,
                              color: Colors.redAccent,
                            ),
                            Expanded(
                              child: Text(
                                "Connect with Google",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.redAccent,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
