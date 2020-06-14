import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/screens/profile/profile.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Settings",
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
              leading: Icon(Icons.account_circle),
              title: Text(
                "Profile",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  color: AppTheme.darkGrey,
                ),
              ),
              trailing: Icon(Icons.chevron_right),
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
              leading: Icon(Icons.location_on),
              title: Text(
                "Location",
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
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 0.0,
              ),
              leading: Icon(Icons.notifications),
              title: Text(
                "Notifications",
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
