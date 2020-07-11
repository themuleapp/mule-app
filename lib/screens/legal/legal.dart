import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';

class Legal extends StatelessWidget {
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Legal",
              style: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                color: AppTheme.darkGrey,
                fontSize: 30,
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
              leading: Icon(
                  Icons.security,
                  color: AppTheme.secondaryBlue
              ),
              title: Text(
                "Privacy Policy",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  color: AppTheme.darkGrey,
                ),
              ),
              trailing: Icon(
                  Icons.chevron_right,
                  color: AppTheme.secondaryBlue
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
                  color: AppTheme.secondaryBlue
              ),
              title: Text(
                "Terms of Service",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  color: AppTheme.darkGrey,
                ),
              ),
              trailing: Icon(
                  Icons.chevron_right,
                  color: AppTheme.secondaryBlue
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
                  color: AppTheme.secondaryBlue
              ),
              title: Text(
                "Licenses",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  color: AppTheme.darkGrey,
                ),
              ),
              trailing: Icon(
                  Icons.chevron_right,
                  color: AppTheme.secondaryBlue
              ),
              /*onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Licenses()));
              },*/
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
