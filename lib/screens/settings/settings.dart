import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/screens/profile/profile.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Settings",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkGrey,
                  fontSize: AppTheme.elementSize(
                      screenHeight, 24, 26, 28, 30, 32, 40, 45, 50),
                ),
              ),
              SizedBox(
                height: AppTheme.elementSize(
                    screenHeight, 10, 10, 12, 12, 14, 20, 20, 22),
              ),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 0.0,
                ),
                leading: Icon(
                  Icons.account_circle,
                  color: AppTheme.secondaryBlue,
                  size: AppTheme.elementSize(
                      screenHeight, 25, 25, 26, 26, 28, 36, 38, 40),
                ),
                title: Text(
                  "Profile",
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: AppTheme.elementSize(
                        screenHeight, 16, 16, 17, 17, 18, 24, 26, 28),
                    color: AppTheme.darkGrey,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: AppTheme.secondaryBlue,
                  size: AppTheme.elementSize(
                      screenHeight, 25, 25, 26, 26, 28, 36, 38, 40),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Profile()));
                },
              ),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 0.0,
                ),
                leading: Icon(
                  Icons.location_on,
                  color: AppTheme.secondaryBlue,
                  size: AppTheme.elementSize(
                      screenHeight, 25, 25, 26, 26, 28, 36, 38, 40),
                ),
                title: Text(
                  "Location",
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: AppTheme.elementSize(
                        screenHeight, 16, 16, 17, 17, 18, 24, 26, 28),
                    color: AppTheme.darkGrey,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: AppTheme.secondaryBlue,
                  size: AppTheme.elementSize(
                      screenHeight, 25, 25, 26, 26, 28, 36, 38, 40),
                ),
                onTap: () {
                  AppSettings.openLocationSettings;
                },
              ),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 0.0,
                ),
                leading: Icon(
                  Icons.notifications,
                  color: AppTheme.secondaryBlue,
                  size: AppTheme.elementSize(
                      screenHeight, 25, 25, 26, 26, 28, 36, 38, 40),
                ),
                title: Text(
                  "Notifications",
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: AppTheme.elementSize(
                        screenHeight, 16, 16, 17, 17, 18, 24, 26, 28),
                    color: AppTheme.darkGrey,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: AppTheme.secondaryBlue,
                  size: AppTheme.elementSize(
                      screenHeight, 25, 25, 26, 26, 28, 36, 38, 40),
                ),
                onTap: () {
                  AppSettings.openNotificationSettings;
                },
              ),
              Divider(),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
