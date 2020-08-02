import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/screens/feedback/feedback_screen.dart';
import 'package:mule/screens/help/help_screen.dart';
import 'package:mule/screens/home/home_screen.dart';
import 'package:mule/screens/menu/drawer_user_controller.dart';
import 'package:mule/screens/menu/home_drawer.dart';
import 'package:mule/screens/settings/settings.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = const MyHomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.white,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexData) {
    if (drawerIndex == drawerIndexData) {
      return;
    }
    switch (drawerIndexData) {
      case DrawerIndex.Settings:
        _pushInContext(context, Settings());
        break;
      case DrawerIndex.Feedback:
        _pushInContext(context, FeedbackScreen());
        break;
      case DrawerIndex.Help:
        _pushInContext(context, HelpScreen());
        break;
      default:
        throw UnimplementedError("Called screen not currently implemented");
    }
  }

  _pushInContext(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }
}
