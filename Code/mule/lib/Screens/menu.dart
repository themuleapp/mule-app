import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mule/Screens/drawer.dart';
import 'package:mule/Screens/profile.dart';
import 'package:mule/config/app_colors.dart';

import 'homepage.dart';
import 'homepage.dart';

class MainPage extends DrawerContent {
  MainPage({Key key, this.title});
  final String title;
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  child: Material(
                    shadowColor: Colors.transparent,
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                      onPressed: widget.onMenuPressed,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(widget.title),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainWidget extends StatefulWidget {
  MainWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> with TickerProviderStateMixin {
  HiddenDrawerController _drawerController;

  @override
  void initState() {
    super.initState();
    _drawerController = HiddenDrawerController(
      initialPage: MainPage(
        title: 'main',
      ),
      items: [
        DrawerItem(
          text: Text('Home', style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.home, color: Colors.white),
          page: MainPage(
            title: 'Home',
          ),
        ),
        DrawerItem(
          text: Text(
            'Places',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.map, color: Colors.white),
          page: MainPage(
            title: 'Places',
          ),
        ),
        DrawerItem(
          text: Text(
            'Orders',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.shopping_basket, color: Colors.white),
          page: MainPage(
            title: 'Orders',
          ),
        ),
        DrawerItem(
          text: Text(
            'Chat',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.chat, color: Colors.white),
          page: MainPage(
            title: 'Chat',
          ),
        ),
        DrawerItem(
          text: Text(
            'Profile',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.person, color: Colors.white),
          page: MainPage(
            title: 'Profile',
          ),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Profile()));
          },
        ),
        DrawerItem(
          text: Text(
            'Settings',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.settings, color: Colors.white),
          page: MainPage(
            title: 'Settings',
          ),
        ),
        DrawerItem(
          text: Text(
            'Logout',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.exit_to_app, color: Colors.white),
          onPressed: () {
            // TODO should call log out endpoint
            // Should remove the token from local storage
            print('hey');
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomePage()));
          },
          page: MainPage(title: 'Logout'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HiddenDrawer(
        controller: _drawerController,
        header: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, bottom: 0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    "https://images.pexels.com/photos/736716/pexels-photo-736716.jpeg"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 15, bottom: 0),
                child: Text(
                  "Nick Miller",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 0, bottom: 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Be a Mule",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white
                      ),
                    ),
                    Switch(
                      value: true,
                      activeColor: AppColors.lightBlue,
                      onChanged: (bool state) {},
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: AppColors.darkBlue,
        ),
      ),
    );
  }
}
