import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/screens/profile/profile.dart';

class Settings extends StatelessWidget {
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
                      screenHeight, 28, 29, 30, 31, 32, 35, 40, 48),
                ),
              ),
              SizedBox(
                height: AppTheme.elementSize(
                    screenHeight, 10, 12, 14, 16, 18, 20, 20, 22),
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
                      screenHeight, 25, 28, 30, 32, 34, 36, 38, 40),
                ),
                title: Text(
                  "Profile",
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: AppTheme.elementSize(
                        screenHeight, 16, 17, 18, 20, 22, 24, 26, 28),
                    color: AppTheme.darkGrey,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: AppTheme.secondaryBlue,
                  size: AppTheme.elementSize(
                      screenHeight, 25, 28, 30, 32, 34, 36, 38, 40),
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
                      screenHeight, 25, 28, 30, 32, 34, 36, 38, 40),
                ),
                title: Text(
                  "Location",
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: AppTheme.elementSize(
                        screenHeight, 16, 17, 18, 20, 22, 24, 26, 28),
                    color: AppTheme.darkGrey,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: AppTheme.secondaryBlue,
                  size: AppTheme.elementSize(
                      screenHeight, 25, 28, 30, 32, 34, 36, 38, 40),
                ),
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
                      screenHeight, 25, 28, 30, 32, 34, 36, 38, 40),
                ),
                title: Text(
                  "Notifications",
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: AppTheme.elementSize(
                        screenHeight, 16, 17, 18, 20, 22, 24, 26, 28),
                    color: AppTheme.darkGrey,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: AppTheme.secondaryBlue,
                  size: AppTheme.elementSize(
                      screenHeight, 25, 28, 30, 32, 34, 36, 38, 40),
                ),
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
