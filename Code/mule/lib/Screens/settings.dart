import 'package:flutter/material.dart';
import 'package:mule/Screens/change_password.dart';
import 'package:mule/config/app_colors.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          color: AppColors.lightBlue,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Settings",
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey),
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              "SECURITY",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14.0,
                color: Color(0xFF9CA4AA),
              ),
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 0.0,
              ),
              leading: Icon(Icons.lock_open),
              title: Text(
                "Change Password",
                style: TextStyle(fontWeight: FontWeight.w500),
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
              leading: Icon(Icons.location_on),
              title: Text(
                "Location",
                style: TextStyle(fontWeight: FontWeight.w500),
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
                style: TextStyle(fontWeight: FontWeight.w500),
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
