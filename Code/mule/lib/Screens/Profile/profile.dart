import 'package:flutter/material.dart';
import 'package:mule/Screens/Profile/Account/change_email.dart';
import 'package:mule/Screens/Profile/Account/change_password.dart';
import 'package:mule/Screens/Profile/Account/change_phone.dart';
import 'package:mule/config/app_theme.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
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
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Profile",
              style: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                color: AppTheme.darkGrey,
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              children: <Widget>[
                Stack(
                  fit: StackFit.loose,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage: AssetImage(
                          'assets/images/profile_photo_nick_miller.jpg'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60.0, left: 70.0),
                      child: CircleAvatar(
                        backgroundColor: AppTheme.lightBlue,
                        radius: 20.0,
                        child: Icon(
                          Icons.camera_alt,
                          color: AppTheme.white,
                          size: 22,
                        ),
                      )
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Nick Miller",
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkGrey,
                      fontSize: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: GestureDetector(
                    child: Icon(
                      Icons.edit,
                      color: AppTheme.lightGrey,
                      size: 20,
                    ),
                    onTap: (){},
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "Account Info",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkGrey,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 0.0,
              ),
              leading: Padding(
                  padding: EdgeInsets.only(top: 7.0),
                  child: Icon(
                      Icons.mail
                  )
              ),
              title: Text(
                "Email",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  color: AppTheme.darkGrey,
                ),
              ),
              subtitle: Text(
                "nickmiller@gmail.com",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                  color: AppTheme.lightGrey,
                ),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ChangeEmail()));
              },
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 0.0,
              ),
              leading: Padding(
                  padding: EdgeInsets.only(top: 7.0),
                  child: Icon(
                      Icons.phone
                  )
              ),
              title: Text(
                "Phone",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  color: AppTheme.darkGrey,
                ),
              ),
              subtitle: Text(
                "+1 123-456-7890",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                  color: AppTheme.lightGrey,
                ),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ChangePhone()));
              },
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "Account Preferences",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkGrey,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 0.0,
              ),
              leading: Icon(Icons.lock),
              title: Text(
                "Change Password",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  color: AppTheme.darkGrey,
                ),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ChangePassword()));
              },
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 0.0,
              ),
              leading: Icon(Icons.delete_forever),
              title: Text(
                "Delete Account",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  color: AppTheme.darkGrey,
                ),
              ),
              trailing: Icon(Icons.chevron_right),
            ),
            Divider(),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}