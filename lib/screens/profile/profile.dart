import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/screens/profile/Account/change_email.dart';
import 'package:mule/screens/profile/Account/change_password.dart';
import 'package:mule/screens/profile/Account/change_phone.dart';
import 'package:mule/screens/profile/Account/delete_account.dart';
import 'package:mule/screens/profile/Account/change_profile_picture.dart';
import 'package:mule/stores/global/user_info_store.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: AppTheme.elementSize(
                screenHeight, 25, 25, 26, 26, 30, 35, 40, 45),
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
        child: ListView(
          children: <Widget>[
            Text(
              "Profile",
              style: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                color: AppTheme.darkGrey,
                fontSize: AppTheme.elementSize(
                    screenHeight, 28, 29, 30, 31, 32, 35, 40, 48),
              ),
            ),
            SizedBox(
              height: AppTheme.elementSize(
                  screenHeight, 30, 32, 32, 32, 35, 40, 42, 44),
            ),
            Row(
              children: <Widget>[
                Stack(
                  fit: StackFit.loose,
                  children: <Widget>[
                    CircleAvatar(
                      radius: AppTheme.elementSize(
                          screenHeight, 50, 52, 52, 53, 55, 60, 62, 64),
                      backgroundImage: AssetImage(
                          'assets/images/profile_photo_nick_miller.jpg'),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 2,
                      child: CircleAvatar(
                        backgroundColor: AppTheme.lightBlue,
                        radius: AppTheme.elementSize(
                            screenHeight, 20, 20, 20, 20, 20, 21, 22, 24),
                        child: IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: AppTheme.white,
                            size: 22,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChangeProfilePicture()));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Observer(
                      builder: (_) => Text(
                        GetIt.I.get<UserInfoStore>().fullName,
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkGrey,
                          fontSize: AppTheme.elementSize(
                              screenHeight, 25, 25, 26, 27, 29, 30, 32, 33),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: AppTheme.elementSize(
                  screenHeight, 10, 12, 12, 14, 16, 20, 22, 24),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "Account Info",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkGrey,
                  fontSize: AppTheme.elementSize(
                      screenHeight, 24, 25, 25, 26, 28, 30, 32, 34),
                ),
              ),
            ),
            SizedBox(
              height: AppTheme.elementSize(
                  screenHeight, 10, 12, 12, 13, 15, 20, 22, 24),
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 0.0,
              ),
              leading: Padding(
                padding: EdgeInsets.only(top: 7.0),
                child: Icon(
                  Icons.mail,
                  color: AppTheme.secondaryBlue,
                  size: AppTheme.elementSize(
                      screenHeight, 25, 26, 27, 29, 34, 36, 38, 40),
                ),
              ),
              title: Text(
                "Email",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: AppTheme.elementSize(
                      screenHeight, 16, 17, 17, 18, 19, 21, 22, 23),
                  color: AppTheme.darkGrey,
                ),
              ),
              subtitle: Observer(
                builder: (_) => Text(
                  GetIt.I.get<UserInfoStore>().email,
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: AppTheme.elementSize(
                        screenHeight, 14, 14, 15, 16, 17, 19, 20, 21),
                    color: AppTheme.lightGrey,
                  ),
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: AppTheme.secondaryBlue,
                size: AppTheme.elementSize(
                    screenHeight, 25, 26, 27, 29, 34, 36, 38, 40),
              ),
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
                    Icons.phone,
                    color: AppTheme.secondaryBlue,
                    size: AppTheme.elementSize(
                        screenHeight, 25, 26, 27, 29, 34, 36, 38, 40),
                  )),
              title: Text(
                "Phone",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: AppTheme.elementSize(
                      screenHeight, 16, 17, 17, 18, 19, 21, 22, 23),
                  color: AppTheme.darkGrey,
                ),
              ),
              subtitle: Observer(
                builder: (_) => Text(
                  GetIt.I.get<UserInfoStore>().phoneNumber,
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: AppTheme.elementSize(
                        screenHeight, 14, 14, 15, 16, 17, 19, 20, 21),
                    color: AppTheme.lightGrey,
                  ),
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: AppTheme.secondaryBlue,
                size: AppTheme.elementSize(
                    screenHeight, 25, 26, 27, 29, 34, 36, 38, 40),
              ),
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
                  fontSize: AppTheme.elementSize(
                      screenHeight, 24, 25, 25, 26, 28, 30, 32, 34),
                ),
              ),
            ),
            SizedBox(
              height: AppTheme.elementSize(
                  screenHeight, 10, 12, 12, 14, 16, 20, 22, 24),
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 0.0,
              ),
              leading: Icon(
                Icons.lock,
                color: AppTheme.secondaryBlue,
                size: AppTheme.elementSize(
                    screenHeight, 25, 26, 27, 29, 34, 36, 38, 40),
              ),
              title: Text(
                "Change Password",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: AppTheme.elementSize(
                      screenHeight, 16, 17, 17, 18, 19, 21, 22, 23),
                  color: AppTheme.darkGrey,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: AppTheme.secondaryBlue,
                size: AppTheme.elementSize(
                    screenHeight, 25, 26, 27, 29, 34, 36, 38, 40),
              ),
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
              leading: Icon(
                Icons.delete_forever,
                color: Colors.red,
                size: AppTheme.elementSize(
                    screenHeight, 25, 26, 27, 29, 34, 36, 38, 40),
              ),
              title: Text(
                "Delete Account",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: AppTheme.elementSize(
                      screenHeight, 16, 17, 17, 18, 19, 21, 22, 23),
                  color: Colors.red,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.red,
                size: AppTheme.elementSize(
                    screenHeight, 25, 26, 27, 29, 34, 36, 38, 40),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DeleteAccount()));
              },
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
