import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';

class Legal extends StatelessWidget {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Legal",
              style: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                color: AppTheme.darkGrey,
                fontSize: AppTheme.elementSize(
                    screenHeight, 30, 30, 30, 31, 34, 42, 45, 50),
              ),
            ),
            SizedBox(
              height: AppTheme.elementSize(
                  screenHeight, 10, 12, 14, 16, 18, 20, 22, 24),
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 0.0,
              ),
              leading: Icon(
                Icons.security,
                color: AppTheme.secondaryBlue,
                size: AppTheme.elementSize(
                    screenHeight, 25, 26, 27, 28, 30, 36, 38, 40),
              ),
              title: Text(
                "Privacy Policy",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: AppTheme.elementSize(
                      screenHeight, 16, 17, 18, 19, 20, 24, 26, 28),
                  color: AppTheme.darkGrey,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: AppTheme.secondaryBlue,
                size: AppTheme.elementSize(
                    screenHeight, 25, 26, 27, 28, 30, 36, 38, 40),
              ),
              /*onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PrivacyPolicy()));
              },*/
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 0.0,
              ),
              leading: Icon(
                Icons.verified_user,
                color: AppTheme.secondaryBlue,
                size: AppTheme.elementSize(
                    screenHeight, 25, 26, 27, 28, 30, 36, 38, 40),
              ),
              title: Text(
                "Terms of Service",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: AppTheme.elementSize(
                      screenHeight, 16, 17, 18, 19, 20, 24, 26, 28),
                  color: AppTheme.darkGrey,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: AppTheme.secondaryBlue,
                size: AppTheme.elementSize(
                    screenHeight, 25, 26, 27, 28, 30, 36, 38, 40),
              ),
              /*onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => TermsOfService()));
              },*/
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 0.0,
              ),
              leading: Icon(
                Icons.insert_drive_file,
                color: AppTheme.secondaryBlue,
                size: AppTheme.elementSize(
                    screenHeight, 25, 26, 27, 28, 30, 36, 38, 40),
              ),
              title: Text(
                "Licenses",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: AppTheme.elementSize(
                      screenHeight, 16, 17, 18, 19, 20, 24, 26, 28),
                  color: AppTheme.darkGrey,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: AppTheme.secondaryBlue,
                size: AppTheme.elementSize(
                    screenHeight, 25, 26, 27, 28, 30, 36, 38, 40),
              ),
              /*onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Licenses()));
              },*/
            ),
            Divider(),
            SizedBox(
              height: AppTheme.elementSize(
                  screenHeight, 10, 12, 14, 16, 18, 20, 22, 24),
            ),
          ],
        ),
      ),
    );
  }
}
